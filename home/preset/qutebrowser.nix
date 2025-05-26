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

      c.url.searchengines = {
        'DEFAULT': 'https://duckduckgo.com/?q={}',
        '!hm': 'https://home-manager-options.extranix.com/?query={}',
        '!nix': 'https://search.nixos.org/packages?query={}',
        '!gl': 'https://www.google.com/search?udm=14&q={}',
        '!yt': 'https://www.youtube.com/results?search_query={}',
        '!git': 'https://github.com/search?q={}&type=repositories',
        '!sx': 'https://searx.tiekoetter.com/search?q={}&preferences=eJx1WMuS67gN_Zp4o7qumdxUUll4k6lkfmD2KoqEJFxRhJoP2-qvD6CHRVrdi3ZbhxQI4nEAWKsIHXmEcOvAgVf2YpXrkurgBu7Hn_-5WNLKysNFpUiaxslChFtH1Fm4tOqOmlztIZC9g99xHFlCPXl6zre_fILLCLEnc_vzv39dgmohgPK6v_12iT2McAsoYi8sJdkYahbo4FFH1dz-p2yAiyE8jiDFj1fy3WV9rQ5xZg2N8sNFg4vga2WxcyN_395X5q6cBlNv567oRwI_1-jqiJEFLHqia9FhZKHak7XbzvU10UuvBptZkgUd15d6igPM4WagVXyBS_K2bsmPKkZ03W3yEON8MRhUY1kJcB06tvjPf_62Ca434__t73-8wOqOBijU9fqfl_7dqa6uA2lUthrBoGJQ6Ta5bBMbp4EqsKuGul7c8Iaucr9-o1LJIK-NKaCWJQtP5YxHlauo7MT6VxZdelaT0oMcwodFWXNOhUr0xzvUdYt2Pd8FFsFOXR6moRrRe_L5BsVxZNQuxkfUuf5hyDVoWCmtxunQtFFoUrmFgWoVkAla4UFhux_VoEX5yyzSsNcKWfx8dkeDUfeJQ6WAmqQHiLvsqSnkRINdd1yaJnAc0QEyBRe_XrXWV5NL1j20A0moEKeMF8RSMq1VHhTmh-iJ460FDxzwmxocyiEwyMGjUfAVe5g7cppl784wvT2eLSigOPLlTgPwyTn3coWBEFXEcKhq4I7KRXZqJseYruKEkWxDciE_l1Wc-Xrn5ABWGs0h-IEDGhWL6DTsAPnr6E3NA3-AEgGHHDUxj1Sjmng7f8pJI_3CSXxx7OJkhhkKfeI8kuNEgGPX78_sknw9E3sVR2a5HLaoB58DHjgFqY0P9mdl0DO3CMus_ms9ugFVnhDtPGd26AA_e2aqHHGYwuEUTQYa8N0msWOK4yijcX8mMhxIJpewMHkVdE8cZHnobCuTVXM1EsdQnhVMeuCFoKQu5HHTq8Yr-diO7Jk4wK8uWgF47t-WA7YHtNVEIb782KeO6bNr1Su8M6SSaAgQwxdLganqxVM4mua4K45dyt2BTmVX4jjwHKVzvuED55wxfmHo6ZA3sHtVCEemWxjHuWJ7j0niXdR44_F1RwpMB9-siRW-WxPJXO6-WEa2up8ridmAmUafP7alTMltL7Usz3VccHP_ySpEz0xuVSyywFITIlz9btvRuP0bRKUn9XpEYSKO8spyah_oc-GyI1hH-uwLThsfY2NzwEl08V_mAjftwexmpY5bjYpzB_aoG5O1d2W4hylII4MrNsK9uB-ZOUBOxtwYqHGvH0LiihP2iLwjU_a1KTWc8WojunL95YY9eARkwwGVEEuhzH9r3cWwl5rJNJCLnrgp4X5lo7NJuCy7wfJ8Xex9mH1Cz55tVBYSE3GdDUx8RpJzV4cLzJmbX-C5ZBxLexH96rWCrdliXADv--VSM4r-2fXmCbfFj8SdXy5yAc5afDy4BhX7BCiPXaGvXz13AF5xt8TxQo-QF0AP3BX4Q6jHro_MTJQf7ilGzlhiviTIaHc1xjgHLJMswIRqt_pLg0AdFW3PApwvsMKnC6zwAzSXqKNQYtAphOs0c8u-J6lWxszXncD2wjThD64OcMJXPaXmVPLxQjkXua_7qqYE6Q4mGRryy-xg6aQDPt-Ty9qYVWwaZk4D5uZBSGiP6ii7WQlVmC5Ht5NiUSWSC1zzQp83Q4prVdEyUYqpycnCKLTcJUjuZ-gdx6IJf2Az53Kks2mIhvAOFpYQ4CNRGSkCBkpen9EJ9FJ7voEPdzAsChe8JFulW13cXEq40_zmOkElKpjwricv5YunmMwX38aRfGnx5eHSB9nWMynbqS-7QdTxk1yh2zhzO8bdVfWqZqZsIA24PCE_ncRU9j79AhjOyDkcN7zw2dIxTWgpHmc4rji-qG8CnOWtcCFuhc7UlJq5g3EvyROAf4vLpUPg8wcZAh7QZEuz0oWL5fmsjE9clHOJlsNjabJyb5I3DocsiuiJAzkm9yrMjtw8Qm5rGN7ut0LnRF_gM6GxS3VB8uHeSeXMXo1EUfpysfhbt3QnNMtYu5ntoazt2cDuLXhHnlqKaI_RXzELmjmNo81yZ-kpruXFlhTlAfJowctZ8R_ZpDgN3bWjrCIGcEF7biU_0m6_C_caxe8L61TDnzLc-3wa78dlrnHSj8izlN91nJfb7W0UPinkgPJPvL-xxD4jvQ3L57lb0OL-OnmZUYtAMyQzQdWnZjvyGNq-GfFOB2Vrp-hojScZH3c7dFKA6RiJrGqOh0OJbhtHDgW2Ceh0-IYX99ywkzL5FMU-yrhMSxvGtLlrho5fQkr52xm2syM7sLuXXS23bmTIfTNWvJZ7Lmpc_c47pO_klAKI3EYevaT8xgYhH-bXBrcy3M6gW-1y_Ah0MAYYg_F0CmeCM28jANd4PRBTW2vpscdfGFKTXEx7DiQezFJ49fZh4irbzpkQsmg49P06Gr3KPy1N1Cv8lyJeOu1VxndRv__8-a_nIeI0I6wJfg77BT75nnv-bVw6fhWcbOK0DTdhME6CWn5E9Fyn7llm73u0sjpx4SLhFvHetrI0KWxhHo74tbhxqm1rdC3JVh4huZitPz6pev1Z9cE0AqtZat2DHi7cNrHfb_8H4EJVeA==',
        '!nl': 'https://noogle.dev/q?term={}',
      }
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
