{
  description = "My home manager configuration";

  inputs.nixpkgs.url = "nixpkgs/nixos-24.05";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      pkgs.hello = pkgs.hello;
      programs.hello.enable = true;
    };

}
