# System-Manager
Manages the nixos configuration for the system & home-manager.
I got tired of using complicated nix commands & cobbeled together scripts so i sat down one evening & made system-manager!

In less words, it makes managing the nix configurations less tedious, with some quality of life options.
A notable benefit is that it makes relocating the nix configuration directory easy, as the directory only needs setting
once & all future invocations will point to the set configuration path.

For a high-level usage overview see the [root README](../README.md). For other curiousites indulge in the help menu.

## Build Insructions
There are two provided options for building system-manager:

#### With My Nix Config
If you use my nix configuration, system-manager will get added to the path & is usable directly from the shell. This is
the only supported way to manage a nix system with my configuration.

#### Cargo
Just run `cargo build --release` in this dir & the binary will be in `./target/releases/`. There's nothing that fancy 
here.
