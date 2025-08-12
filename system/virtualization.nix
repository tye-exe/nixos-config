{ pkgs, ... }:
# References:
# https://github.com/bryansteiner/gpu-passthrough-tutorial/
# https://forum.level1techs.com/t/nixos-vfio-pcie-passthrough/130916
{
  environment.systemPackages = with pkgs; [
    virt-manager
    libvirt
  ];

  boot = {
    kernelParams = [ "intel_iommu=on" ];
    blacklistedKernelModules = [
      "nvidia"
      "nouveau"
    ];
    kernelModules = [
      "vfio_virqfd"
      "vfio_pci"
      "vfio_iommu_type1"
      "vfio"
    ];
    extraModprobeConfig = "options vfio-pci ids=10de:1c81,10de:0fb";
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  virtualisation = {
    # What the name says
    spiceUSBRedirection.enable = true;

    libvirtd = {
      enable = true;
      qemu.ovmf.enable = true;
      # Required for shared file system.
      # Set up on windows side: https://virtio-fs.gitlab.io/howto-windows.html
      # For linux setup: 'sudo mount -t virtiofs mount_tag ./shared'
      qemu.vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };

  # Enable clipboard sharing
  # For linux setup: 'sudo apt install spice-vdagent'
  services.spice-vdagentd.enable = true;
}
