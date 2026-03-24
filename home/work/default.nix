{
  pkgs,
  inputs,
  system,
  lib,
  ...
}:
{
  imports = [
    ../optional/preset/helix.nix
    ../optional/preset/git.nix
    ../optional/preset/cli.nix
    ../optional/preset/rust.nix

    ../optional/module/systemd.nix
  ];

  home = {
    packages =
      with pkgs;
      [
        ncdu # Disk usage analyzer
        viu # Terminal image viewer
        ripgrep # Faster alternative to grep
        caligula # Every time i need this i have to spend 5 minuets searching for it
        remmina

        # C# development
        jetbrains.rider
        (
          with dotnetCorePackages;
          combinePackages [
            sdk_8_0
            sdk_10_0
          ]
        )

        libreoffice
      ]
      ++ (with inputs.nix-alien.packages.${system}; [
        nix-alien
      ])
      ++ (with inputs.winapps.packages.${system}; [
        winapps
        winapps-launcher
      ]);
  };

  fonts = {
    fontconfig.enable = true;
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.warn_timeout = "1m";
    };

    nix-index.enable = true;

    git.settings.user = {
      name = "tye-travcomuk";
      email = "tye@travcomuk.com";
    };
  };

  tye-services.enabled = {
    syncthingtray = lib.mkForce false;
    keyboard = lib.mkForce false;
  };

  home.file."ideavim" = {
    enable = true;
    target = ".ideavimrc";
    text = ''
      let mapleader=" "

      set which-key
      set easymotion

      " Increase the timeout to make the possible keys pop-up useable
      set timeoutlen=5000

      " Recommended settings
      map <leader>f <Plug>(easymotion-s)
      map <leader>e <Plug>(easymotion-f)

      map <leader>d <Action>(Debug)
      map <leader>r <Action>(RenameElement)
      map <leader>c <Action>(Stop)
      map <leader>z <Action>(ToggleDistractionFreeMode)

      map <leader>s <Action>(SelectInProjectView)
      "map <leader>a <Action>(Annotate)
      map <leader>h <Action>(Vcs.ShowTabbedFileHistory)
      map <S-Space> <Action>(GotoNextError)

      map <leader>b <Action>(ToggleLineBreakpoint)
      map <leader>o <Action>(FileStructurePopup)

      "Mine 

      map gw <Plug>(easymotion-jumptoanywhere)
      map <leader>k <Action>(ShowHoverInfo)
      map <leader>a <Action>(ShowIntentionActions)

      "MY EARS
      set visualbell
      set noerrorbells
    '';
  };
}
