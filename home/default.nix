{
  pkgs,
  config,
  unstable,
  ...
}: let
  gdk = pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
    kubectl
    cloud_sql_proxy
  ]);
in {
  fonts.fontconfig.enable = true;

  home.packages = [
    gdk
    pkgs.jetbrains.clion
    pkgs.jetbrains.datagrip
    pkgs.jetbrains.webstorm
    pkgs.jetbrains.idea-ultimate
    pkgs.jetbrains.pycharm-professional
    pkgs.postman
    pkgs.keepassxc
    pkgs.spotify
    pkgs.flatpak
    pkgs.distrobox
  ];

  services.mpris-proxy.enable = true;

  programs.zathura = {
    enable = true;
    options = {
      ###########
      # Options #
      ###########
      font = "DejaVu Sans 14";
      adjust-open = "width";
      pages-per-row = 1;
      selection-clipboard = "clipboard";
      incremental-search = true;

      window-title-home-tilde = true;
      window-title-basename = true;
      statusbar-home-tilde = true;
      show-hidden = true;

      statusbar-h-padding = 0;
      statusbar-v-padding = 0;
      page-padding = 1;

      #########
      # Theme #
      #########
      # GRUVBOX Theme
      # https://github.com/eastack/zathura-gruvbox/blob/master/zathura-gruvbox-dark

      notification-error-bg = "#282828"; # bg
      notification-error-fg = "#fb4934"; # bright:red
      notification-warning-bg = "#282828"; # bg
      notification-warning-fg = "#fabd2f"; # bright:yellow
      notification-bg = "#282828"; # bg
      notification-fg = "#b8bb26"; # bright:green

      completion-bg = "#504945"; # bg2
      completion-fg = "#ebdbb2"; # fg
      completion-group-bg = "#3c3836"; # bg1
      completion-group-fg = "#928374"; # gray
      completion-highlight-bg = "#83a598"; # bright:blue
      completion-highlight-fg = "#504945"; # bg2

      # Define the color in index mode
      index-bg = "#504945"; # bg2
      index-fg = "#ebdbb2"; # fg
      index-active-bg = "#83a598"; # bright:blue
      index-active-fg = "#504945"; # bg2

      inputbar-bg = "#282828"; # bg
      inputbar-fg = "#ebdbb2"; # fg

      statusbar-bg = "#504945"; # bg2
      statusbar-fg = "#ebdbb2"; # fg

      highlight-color = "#fabd2f"; # bright:yellow
      highlight-active-color = "#fe8019"; # bright:orange

      default-bg = "#282828"; # bg
      default-fg = "#ebdbb2"; # fg
      render-loading = true;
      render-loading-bg = "#282828"; # bg
      render-loading-fg = "#ebdbb2"; # fg

      # Recolor book content's color
      recolor-lightcolor = "#282828"; # bg
      recolor-darkcolor = "#ebdbb2"; # fg
      recolor-keephue = true; # keep original color
    };
    ################
    # Key mappings #
    ################
    mappings = {
      K = "zoom in";
      J = "zoom out";

      r = "reload";
      R = "rotate";

      u = "scroll half-up";
      d = "scroll half-down";

      D = "toggle_page_mode";

      i = "recolor";

      # next/previous page
      H = "navigate previous";
      L = "navigate next";

      "<Right>" = "navigate next";
      "<Left>" = "navigate previous";
      "<Down>" = "scroll down";
      "<Up>" = "scroll up";
    };
  };

  programs.obs-studio = {
    enable = true;
    plugins = [
      pkgs.obs-studio-plugins.obs-backgroundremoval
      pkgs.obs-studio-plugins.obs-pipewire-audio-capture
    ];
  };

  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = true;
    userSettings = {
      "workbench.startupEditor" = "none";
      "workbench.colorTheme" = "Dracula Theme";
      "workbench.editor.enablePreview" = false;

      "terminal.integrated.scrollback" = 50000;
      "git.confirmSync" = false;

      "security.workspace.trust.untrustedFiles" = "open";
      "security.workspace.trust.enabled" = false;
      "security.workspace.trust.startupPrompt" = "never";

      "java.debug.settings.hotCodeReplace" = "auto";
      "java.jdt.ls.vmargs" = "--add-opens=java.base/java.io=ALL-UNNAMED -XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m -Xlog:disable";
      "java.help.showReleaseNotes" = false;
      "java.debug.settings.forceBuildBeforeLaunch" = false;
      "java.server.launchMode" = "Standard";
      "java.showBuildStatusOnStart.enabled" = "off";
      "java.import.maven.offline.enabled" = true;
      "java.maven.downloadSources" = false;
      "java.eclipse.downloadSources" = false;
      "java.progressReports.enabled" = false;
      "java.configuration.runtimes" = [
        {
          "name" = "JavaSE-1.8";
          "path" = "${pkgs.jdk8}/lib/openjdk/jre/";
          "default" = true;
        }
        {
          "name" = "JavaSE-17";
          "path" = "${pkgs.jdk17}/lib/openjdk/";
        }
        {
          "name" = "JavaSE-21";
          "path" = "${pkgs.jdk21_headless}/lib/openjdk/";
        }
      ];
      "rsp-ui.enableStartServerOnActivation" = [
        {
          "id" = "redhat.vscode-community-server-connector";
          "name" = "Community Server Connector";
          "startOnActivation" = true;
        }
        {
          "id" = "redhat.vscode-server-connector";
          "name" = "Red Hat Server Connector";
          "startOnActivation" = false;
        }
      ];
      "rsp-ui.rsp.java.home" = "${pkgs.jdk21_headless}/lib/openjdk/";
      "maven.executable.options" = "-Dmaven.javadoc.skip=true -Dmaven.test.skip=true";
      "redhat.telemetry.enabled" = false;

      "editor.fontFamily" = "'Comic Code Ligatures Medium'";
      "editor.fontLigatures" = true;
      "editor.minimap.enabled" = false;
      "editor.wordBasedSuggestions" = "off";
      "editor.rulers" = [79 120];

      "diffEditor.ignoreTrimWhitespace" = true;
      "diffEditor.hideUnchangedRegions.enabled" = true;

      "task.allowAutomaticTasks" = "on";
      "triggerTaskOnSave.on" = false;

      "window.zoomLevel" = -1;
      "update.mode" = "none";
      "update.showReleaseNotes" = false;
      "extensions.autoUpdate" = false;
    };
  };

  programs.git = {
    enable = true;
    delta.enable = true;
    extraConfig = {
      safe.directory = ["/usr/local/var/nixcfg"];
      core = {
        autocrlf = "input";
        whitespace = "indent-with-non-tab,tabwidth=4";
        eol = "native";
      };
      pager = {
        diff = "delta";
        log = "delta";
        reflog = "delta";
        show = "delta";
      };
      delta = {
        features = "side-by-side line-numbers decorations";
        syntax-theme = "Dracula";
        plus-style = "syntax \"#003800\"";
        minus-style = "syntax \"#3f0001\"";
        whitespace-error-style = "22 reverse";
        interactive = {
          keep-plus-minus-markers = false;
        };
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-style = "bold yellow ul";
          file-decoration-style = "none";
          hunk-header-decoration-style = "cyan box ul";
          hunk-header-style = "file line-number syntax";
        };
        line-numbers = {
          line-numbers-left-style = "cyan";
          line-numbers-right-style = "cyan";
          line-numbers-minus-style = "124";
          line-numbers-plus-style = "28";
        };
        magit-delta = {
          line-numbers = false;
          side-by-side = false;
        };
      };
      push = {
        default = "simple";
      };
      pull = {
        rebase = true;
      };
      fetch = {
        prune = true;
      };
      diff = {
        colormoved = "zebra";
      };
      rebase = {
        autostash = true;
        autosquash = true;
      };
      http = {
        sslVerify = false;
      };
      credential.helper = "${
        pkgs.git.override {withLibsecret = true;}
      }/bin/git-credential-libsecret";
      merge = {
        conflictStyle = "diff3";
      };
      checkout = {
        defaultRemote = "origin";
      };
    };
  };

  programs.lazygit.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.mr = {
    enable = true;
    settings = {
      ".config/nvim" = {
        checkout = "rm -rf $HOME/.config/nvim;rm -rf $HOME/.local/share/nvim;rm -rf $HOME/.local/state/nvim;rm -rf $HOME/.cache/nvim;git clone -b nixos https://github.com/devjrios/neoconfig.git $HOME/.config/nvim";
      };
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      lat = "ls -lat";
      lg = "lazygit";
    };
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "colored-man-pages" "history" "jsontools" "copypath"];
    };
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    initExtra = ''
      nixify() {
        if [ ! -e ./.envrc ]; then
          echo "use nix" > .envrc
          direnv allow
        fi
        if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
          cat > default.nix <<'EOF'
      with import <nixpkgs> {};
      mkShell {
        nativeBuildInputs = [ bashInteractive ];
      }
      EOF
          ''${EDITOR:-nvim} default.nix
        fi
      }

      flakify() {
        if [ ! -e flake.nix ]; then
          nix flake new -t github:nix-community/nix-direnv .
        elif [ ! -e .envrc ]; then
          echo "use flake" > .envrc
          direnv allow
        fi
        ''${EDITOR:-nvim} flake.nix
      }

      mk_devshell() {
        if [ ! -e flake.nix ]; then
          nix flake new -t "github:numtide/devshell" .
        elif [ ! -e .envrc ]; then
          echo "use flake" > .envrc
          direnv allow
        fi
        ''${EDITOR:-nvim} flake.nix
      }

      compile_java() {
        skipTests="$1"
        profile="$2"
        if [ -z "$profile" ]; then
          profile="all"
        fi
        if [ -z "$skipTests" ]; then
          skipTests="true"
        fi
        mvn -Dmaven.test.skip=$skipTests -T 1.0C clean install -P$profile
      }

      run_java() {
        core_name=$(find -L $PWD -type d -regex ".+-core$" | grep -P -v "(trx|bpm)")
        echo "Here is my core name: $core_name"
        jar_file=$(find -L "$core_name/target" -regex ".+SNAPSHOT.jar$")
        [ -z "$jar_file" ] && jar_file=$(find -L "$core_name/target" -regex ".+SMLB.jar$")
        echo "Here is my jar file: $jar_file"
        profiles="''${1:-local,token,nomultitenant}"
        java -Dspring.profiles.active="$profiles" -Dspring.cloud.discovery.enabled=false -Deureka.client.enabled=false -Dribbon.eureka.enabled=false -Deureka.client.registerWithEureka=false -Deureka.client.fetchRegistry=false -Dspring.cloud.service-registry.auto-registration.enabled=false -Xmx512M -XX:MaxMetaspaceSize=256M -jar $jar_file
      }

      init_db() {
        script_dos="$(/usr/bin/env find -L "''${PWD}" -maxdepth 3 -type f -name 'init-db.bat')"
        script_sql="$(/usr/bin/env find -L "''${PWD}" -maxdepth 4 -type f -name 'init-db.sql')"

        /usr/bin/env dos2unix "''${script_dos}"
        /usr/bin/env dos2unix "''${script_sql}"

        db_name="$(/usr/bin/env grep -Po '(?<=\-U sm )\w+$' "''${script_dos}" | /usr/bin/env xargs)"

        /usr/bin/env dropdb -U sm --if-exists "''${db_name}"
        /usr/bin/env createdb -U sm --encoding=UTF8 "''${db_name}"
        /usr/bin/env psql -U sm -f "''${script_sql}" "''${db_name}"
      }
    '';
    envExtra = ''
      if [[ -z "$NIX_LD" ]]; then
        export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "''${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
      fi
      if [[ -z "$SSH_ASKPASS_REQUIRE" ]]; then
        export SSH_ASKPASS_REQUIRE="prefer"
      fi
    '';
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    clock24 = true;
    historyLimit = 9999;
    keyMode = "vi";
    mouse = true;
    prefix = "Home";
    baseIndex = 1;
    escapeTime = 0;
    customPaneNavigationAndResize = false;
    extraConfig = ''
      set -g status-right ""
      set -g status-left ""
      set -g status-justify centre
      set -g set-titles on
      set -g set-titles-string '#W'
      setw -g automatic-rename on

      set-option -g status-style bg=colour237,fg=colour223 # bg=bg1, fg=fg1
      set-window-option -g window-status-style bg=colour214,fg=colour237 # bg=yellow, fg=bg1
      set-window-option -g window-status-current-style bg=red,fg=colour237 # fg=bg1

      set-window-option -g window-status-format "\
      #[fg=colour237,bg=colour239,noitalics]\uE0B0\
      #[fg=colour223,bg=colour239] #I \uE0B1\
      #[fg=colour223, bg=colour239] #W \
      #[fg=colour239, bg=colour237]\uE0B0"

      set-window-option -g window-status-current-format "\
      #[fg=colour237, bg=colour214]\uE0B0\
      #[fg=colour239, bg=colour214] #I* \uE0B1\
      #[fg=colour239, bg=colour214, bold] #W \
      #[fg=colour214, bg=colour237]\uE0B0"

      set -ga terminal-overrides ",alacritty:Tc"
      bind [ split-window -h
      set -g focus-events on
    '';
    sensibleOnTop = false;
    plugins = [
      pkgs.tmuxPlugins.sensible
      pkgs.tmuxPlugins.pain-control
      pkgs.tmuxPlugins.yank
      pkgs.tmuxPlugins.open
      pkgs.tmuxPlugins.logging
    ];
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = {
        strict_env = true;
        hide_env_diff = true;
      };
    };
    stdlib = ''
      : ''${XDG_RUNTIME_DIR:=/run/user/$UID}
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
        local hash path
        echo "''${direnv_layout_dirs[$PWD]:=$(
          hash="$(sha1sum - <<< "$PWD" | head -c40)"
          path="''${PWD//[^a-zA-Z0-9]/-}"
          echo "''${XDG_RUNTIME_DIR}/direnv/layouts/''${hash}''${path}"
        )}"
      }
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        bold = {
          family = "Glorious Monospaced Shell";
          style = "Bold";
        };
        bold_italic = {
          family = "Glorious Monospaced Shell";
          style = "Bold Italic";
        };
        italic = {
          family = "Glorious Monospaced Shell";
          style = "Italic";
        };
        normal = {
          family = "Glorious Monospaced Shell";
          style = "Regular";
        };
        offset = {
          x = 0;
          y = 0;
        };
        glyph_offset = {
          x = 0;
          y = 0;
        };
      };
      terminal = {
        shell = {
          args = ["-l"];
          program = "${pkgs.tmux}/bin/tmux";
        };
      };
      window = {
        blur = true;
        opacity = 1.0;
        padding = {
          x = 2;
          y = 2;
        };
      };
      scrolling = {
        history = 10001;
      };
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      character = {
        error_symbol = "[❌](bold red) ";
      };
      cmd_duration = {
        min_time = 10000;
        format = " took [\$duration](\$style)";
      };
      directory = {
        truncation_length = 5;
        format = "[\$path](\$style)[\$lock_symbol](\$lock_style) ";
      };
      git_branch = {
        format = " [\$symbol\$branch](\$style) ";
        symbol = "🌱 ";
        style = "bold yellow";
      };
      git_commit = {
        commit_hash_length = 8;
        style = "bold white";
      };
      git_status = {
        conflicted = "⚔️";
        ahead = "🐅 x\${count} ";
        behind = "🐢 x\${count} ";
        diverged = "🔱 🐅 x\${ahead_count} 🐢 x\${behind_count} ";
        untracked = "🤷 x\${count} ";
        stashed = "🎁 ";
        modified = "📝 x\${count} ";
        staged = "🎬 x\${count} ";
        renamed = "📛 X\${count} ";
        deleted = "🗑️ x\${count} ";
        style = "bright-white";
        format = "\$all_status\$ahead_behind";
      };
      hostname = {
        ssh_only = false;
        format = "<[\$hostname](\$style)>";
        trim_at = "-";
        style = "bold dimmed white";
        disabled = true;
      };
      memory_usage = {
        format = "\n\$symbol[\${ram}](\$style) ";
        threshold = 50;
        style = "bold dimmed white";
        disabled = false;
      };
      package = {
        disabled = true;
      };
      conda = {
        format = "[\$symbol\$environment](dimmed green) ";
        symbol = "🐍 ";
      };
      python = {
        format = "[\$symbol\$version](\$style) ";
        style = "bold green";
      };
      nodejs = {
        symbol = "📦 ";
      };
      time = {
        time_format = "%T";
        format = "🕙 \$time(\$style) ";
        style = "bright-white";
        disabled = false;
      };
      username = {
        style_user = "bold dimmed blue";
        show_always = false;
      };
    };
  };

  home.stateVersion = "23.11";
}
