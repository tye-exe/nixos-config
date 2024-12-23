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
}

/// The persistent configuration data for this program.
#[derive(Serialize, Deserialize, Debug, Default)]
struct Config {
    identity: Identities,
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
        } => {
            // Separated due to ownership limitations.
            let path = config.nix_path.ok_or(Errors::PathNotSet)?;
            let path = path.to_str().ok_or(Errors::NotUTFPath)?;

            let identity = format!("{:?}", config.identity).to_lowercase();

            // Display/Execute command.
            let mut command;
            if display_command {
                command = Command::new("echo");
            } else {
                command = Command::new("sh");
                command.arg("-c");
            }

            match target {
                SwitchTarget::Home => {
                    command.arg(format!(
                        "home-manager switch --flake {path}#{identity} --impure",
                    ));
                }
                SwitchTarget::System => {
                    command.arg(format!(
                        "sudo nixos-rebuild switch --flake {path}#{identity} --impure"
                    ));
                }
            }

            let _ = command.status();
        }
        Operations::Identity { operation } => match operation {
            IdentityOptions::Get => {
                println!("Identity: {:?}", config.identity)
            }
            IdentityOptions::Set { identity } => {
                println!("Old identity: {:?}", config.identity);

                config.identity = identity;
                write_config(&config, config_path.clone(), cli.debug)?;

                println!("New identity: {:?}", config.identity)
            }
        },
        Operations::Path { path } => {
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