{ pkgs-unstable, ... }:
{
  home.packages = with pkgs-unstable; [
    # Faster rust linker
    mold-wrapped
  ];

  home.file.cargo = {
    enable = true;
    target = ".cargo/config.toml";
    text = ''
      [target.x86_64-unknown-linux-gnu]
      rustflags = ["-C", "link-arg=-fuse-ld=mold"]
    '';
  };
}
