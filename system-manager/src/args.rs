use std::path::Path;

use clap::{Parser, Subcommand};
use serde::{Deserialize, Serialize};

#[derive(Parser)]
#[command(version, about, long_about = None)] // Read from `Cargo.toml`
#[command(propagate_version = true)]
pub(crate) struct Cli {
    #[command(subcommand)]
    pub(crate) operation: Operations,

    /// Whether to output debug information.
    #[arg(short, long, global = true)]
    pub(crate) debug: bool,
}

#[derive(Clone, Debug, Subcommand)]
pub(crate) enum Operations {
    /// Switch the current system to the one specified in the nix configuration.
    Switch {
        #[command(subcommand)]
        target: SwitchTarget,

        /// Display the switch commands instead of executing them.
        #[arg(long = "display", global = true)]
        display_command: bool,

        /// Don't update the inputs (`flake.lock` file), only rebuild the system.
        #[arg(long = "no_update", global = true)]
        no_update: bool,
    },
    /// The identity of the nix configuration used. Different machines have different configuration.
    Identity {
        #[command(subcommand)]
        operation: IdentityOptions,
    },
    /// The path to the nix configuration; Relative paths are converted into absolute paths.
    Path {
        #[command(subcommand)]
        operation: PathOption,
    },
    /// Displays "tye-nix" in ASCII; Ignore the vanity.
    Logo,
}

#[derive(Clone, Debug, Subcommand)]
pub(crate) enum SwitchTarget {
    /// Perform a home-manager switch.
    Home,
    /// Perform a system switch.
    System,
}

#[derive(Clone, Debug, Subcommand)]
pub(crate) enum IdentityOptions {
    /// Set the identity of the configuration.
    Set {
        #[command(subcommand)]
        identity: Identities,
    },
    /// Get the identity of the configuration.
    Get {
        /// Display the raw config value.
        #[arg(long)]
        raw: bool,
    },
}

#[derive(Serialize, Deserialize, Debug, Subcommand, Clone)]
pub(crate) enum Identities {
    /// Desktop configuration.
    Desktop,
    /// Laptop configuration.
    Laptop,
    /// NAS configuration.
    NAS,
    /// Anything else; Use this if you are unsure.
    Undefined,
}

impl Default for Identities {
    fn default() -> Self {
        Self::Undefined
    }
}

#[derive(Clone, Debug, Subcommand)]
pub(crate) enum PathOption {
    /// Sets the path to the nix configuration.
    Set { path: Box<Path> },
    /// Gets the absolute path of the nix configuration.
    Get {
        /// Display the raw config value.
        #[arg(long)]
        raw: bool,
    },
}
