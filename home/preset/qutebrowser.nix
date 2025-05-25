{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Required for content.block.method = "both"
    python312Packages.adblock

    # Bitwarden compatibility
    bitwarden-cli
    python312Packages.tldextract
    keyutils
    rofi
  ];

  programs.qutebrowser = {
    enable = true;
    keyBindings = {
      normal = {
        "zb" = "spawn --userscript qute-bitwarden";
      };
    };
    extraConfig = ''
      # set the flavor you'd like to use
      # valid options are 'mocha', 'macchiato', 'frappe', and 'latte'
      # last argument (optional, default is False): enable the plain look for the menu rows
      import catppuccin
      catppuccin.setup(c, 'mocha', True)
    '';
    settings = {
      colors.webpage = {
        darkmode = {
          enabled = true;

        };
        preferred_color_scheme = "dark";
      };

      content.blocking.method = "both";
      content.blocking.adblock.lists = [
        # Default
        "https://easylist.to/easylist/easylist.txt"
        "https://easylist.to/easylist/easyprivacy.txt"

        # Ublock
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt"
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt"
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt"
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt"
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt"
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt"
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt"
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt"
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt"
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt"
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt"
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt"
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-others.txt"
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt"
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/quick-fixes.txt"
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt"
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"
      ];

      downloads.location.remember = false;

      editor.command = [
        "hx"
        "{file}:{line}:{column0}"
      ];

      # I don't know what these should do.
      # And the default program is not installed.
      fileselect = {
        folder.command = [ "break 1;" ];
        multiple_files.command = [ "break 1;" ];
        single_file.command = [ "break 1;" ];
      };

      hints = {
        dictionary = "${builtins.fetchurl {
          url = "https://raw.githubusercontent.com/dwyl/english-words/refs/heads/master/words.txt";
          sha256 = "sha256:1ry5fgrg5k0xm591pnr4lz5dch5knkkmiv7jhzg870ncg7cfm91r";
        }}";
        scatter = false;
      };

      input.insert_mode.auto_load = true;
      # Causes page navigation to use selectable elements.
      input.spatial_navigation = false;

      keyhint.delay = 0;

      scrolling.bar = "when-searching";
      # Slows down using the browser
      scrolling.smooth = false;

      session.lazy_restore = true;

      tabs = {
        mode_on_change = "restore";
        title.format = "{private}{audio}{index}: {current_title}";
        last_close = "default-page";
      };

      url = {
        default_page = "about:blank";
        start_pages = "about:blank";
        searchengines = {
          hm = "https://home-manager-options.extranix.com/?query={}";
          nix = "https://search.nixos.org/packages?query={}";
          google = "https://www.google.com/search?udm=14&q={}";
        };
      };
    };
  };

  # qutebrowser theme.
  home.file."catppuccin" = {
    enable = true;
    target = ".config/qutebrowser/catppuccin";
    source = builtins.fetchGit {
      url = "https://github.com/catppuccin/qutebrowser.git";
      ref = "main";
      rev = "808adc3d7d5be6fc573d6be6e9c888cb96b5d6e6";
    };
  };
}
