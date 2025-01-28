mod args;

use app_dirs2::{AppDataType, AppInfo};
use args::{Cli, Identities, IdentityOptions, Operations, SwitchTarget};
use clap::Parser;
use serde::{Deserialize, Serialize};
use std::{path::Path, process::Command};

/// Holds data for [app_dirs2].
const APP_INFO: AppInfo = AppInfo {
    name: "SystemManager",
    author: "tye",
};

/// ASCII art of "tye-nix".
const LOGO: &str = r#"
------------------------------------------------------------------
 ______   __  __     ______           __   __     __     __  __
/\__  _\ /\ \_\ \   /\  ___\         /\ "-.\ \   /\ \   /\_\_\_\
\/_/\ \/ \ \____ \  \ \  __\         \ \ \-.  \  \ \ \  \/_/\_\/_
   \ \_\  \/\_____\  \ \_____\        \ \_\\"\_\  \ \_\   /\_\/\_\
    \/_/   \/_____/   \/_____/         \/_/ \/_/   \/_/   \/_/\/_/

------------------------------------------------------------------
"#;

/// The possible errors this program can encounter.
#[derive(thiserror::Error, Debug)]
enum Errors {
    #[error("This program only supports Linux, because it only makes sense to run on Linux.")]
    NotLinux,

    #[error("{0}")]
    ConfigPath(#[from] app_dirs2::AppDirsError),
    #[error("Unable to read config at path: {path}")]
    ConfigFileRead { path: Box<Path> },
    #[error("{0}")]
    ConfigParse(#[from] serde_json::Error),
    #[error("Unable to write config to path: {path}")]
    ConfigWrite { path: Box<Path> },

    #[error("{error}")]
    InvalidPath { error: std::io::Error },
    #[error("The path to the nix config has not been set. See option \"path\".")]
    PathNotSet,
    #[error(
        "The set path is not a valid UTF-8 string. Please set the path to a valid UTF-8 string."
    )]
    NotUTFPath,

    #[error("Failed to execute command. Error: {error}")]
    CommandExecutionFail { error: std::io::Error },
    #[error("Command failed")]
    CommandFailed { command: String },
}

/// The persistent configuration data for this program.
#[derive(Serialize, Deserialize, Debug, Default)]
struct Config {
    /// The identity of this system.
    identity: Identities,
    /// The path to the nix configuration.
    nix_path: Option<Box<Path>>,
}

fn main() -> Result<(), Errors> {
    // The program is designed to manage nix configs, on linux.
    if cfg!(not(target_os = "linux")) {
        Err(Errors::NotLinux)?;
    }

    let cli = Cli::parse();
    if cli.debug {
        println!("Debug: true");
    }

    let config_dir = app_dirs2::app_root(AppDataType::UserConfig, &APP_INFO)?;
    if cli.debug {
        println!("Config Dir: {:?}", config_dir);
    }

    // Path to config file
    let config_path = {
        let mut path = config_dir.clone();
        path.push("config.json");
        path.into_boxed_path()
    };
    if cli.debug {
        println!("Config Path: {:?}", config_path.clone())
    }

    let mut config;
    let config_exists =
        !std::fs::exists(config_path.clone()).map_err(|_| Errors::ConfigFileRead {
            path: config_path.clone(),
        })?;
    // Create config file
    if config_exists {
        config = Config::default();
        write_config(&config, config_path.clone(), cli.debug)?;
    }
    // Read config values
    else {
        config =
            serde_json::from_str(&std::fs::read_to_string(config_path.clone()).map_err(|_| {
                Errors::ConfigFileRead {
                    path: config_path.clone(),
                }
            })?)?;
    }

    if cli.debug {
        println!("Parsed Config: {:?}", config);
    }

    match cli.operation {
        Operations::Switch {
            target,
            display_command,
            no_update,
        } => {
            // Separated due to ownership limitations.
            let path = config.nix_path.clone().ok_or(Errors::PathNotSet)?;
            let path = path.to_str().ok_or(Errors::NotUTFPath)?;

            let identity = format!("{:?}", config.identity).to_lowercase();

            // Get sudo perms firms, as flake update can take a minuet or two.
            match target {
                SwitchTarget::System => {
                    command_arg(
                        display_command,
                        "echo 'Sudo perms required for system rebuild.'".to_owned(),
                    )?;
                    command_arg(
                        display_command,
                        "sudo echo 'Sudo perms given for system rebuild.'".to_owned(),
                    )?;
                }
                SwitchTarget::Home => {}
            }

            // Update flake lock file
            if !no_update {
                command_arg(display_command, format!("nix flake update --flake {path}"))?;
            }

            // Perform switch
            command_arg(
                display_command,
                match target {
                    SwitchTarget::Home => {
                        format!("home-manager switch --flake {path}#{identity} --impure")
                    }
                    SwitchTarget::System => {
                        format!("sudo nixos-rebuild switch --flake {path}#{identity} --impure")
                    }
                },
            )?;
        }
        Operations::Identity { operation } => match operation {
            IdentityOptions::Get { raw } => {
                if raw {
                    let identity = format!("{:?}", config.identity).to_lowercase();
                    println!("{identity}")
                } else {
                    println!("Identity: {:?}", config.identity)
                }
            }
            IdentityOptions::Set { identity } => {
                println!("Old identity: {:?}", config.identity);

                config.identity = identity;
                write_config(&config, config_path.clone(), cli.debug)?;

                println!("New identity: {:?}", config.identity)
            }
        },
        Operations::Path { operation } => match operation {
            args::PathOption::Set { path } => {
                if cli.debug {
                    println!("Raw Path: {path:?}")
                }

                let true_path = path
                    .canonicalize()
                    .map_err(|err| Errors::InvalidPath { error: err })?
                    .into_boxed_path();

                if cli.debug {
                    println!("Canonicalized Path: {true_path:?}")
                }

                config.nix_path = Some(true_path);
                write_config(&config, config_path, cli.debug)?;
            }
            args::PathOption::Get { raw } => {
                if raw {
                    let output = match config.nix_path {
                        Some(path) => path.to_str().ok_or(Errors::NotUTFPath)?.to_owned(),
                        None => "None".to_owned(),
                    };
                    println!("{output}")
                } else {
                    println!("Nix Path: {:?}", config.nix_path)
                }
            }
        },
        Operations::Logo => println!("{}", LOGO),
    }

    Ok(())
}

/// Writes the given config to the given file.
fn write_config(config: &Config, config_path: Box<Path>, debug: bool) -> Result<(), Errors> {
    if debug {
        println!(
            "Writing new config:\nConfig: {:?}\nPath: {:?}",
            config, config_path
        )
    }

    let text = serde_json::to_string(config)?;
    std::fs::write(config_path.clone(), text).map_err(|_| Errors::ConfigWrite {
        path: config_path.clone(),
    })?;
    Ok(())
}

fn command_arg(display_command: bool, arg: String) -> Result<(), Errors> {
    // Display/Execute command.
    let mut command;
    if display_command {
        command = Command::new("echo");
    } else {
        command = Command::new("sh");
        command.arg("-c");
    }
    // Run command.
    let success = command
        .arg(arg.clone())
        .status()
        .map_err(|err| Errors::CommandExecutionFail { error: err })?
        .success();

    // If the run command failed that's an error.
    if !success {
        Err(Errors::CommandFailed { command: arg })?;
    }

    Ok(())
}
