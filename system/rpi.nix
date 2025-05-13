{ pkgs, lib, ... }:
{
  imports = [
    ./core.nix
  ];

  boot = lib.mkForce {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  system.stateVersion = "24.11";
}
