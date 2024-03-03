{ pkgs, ... }:
let
  additionalJDKs = [ pkgs.zulu17 pkgs.zulu8 ];
  gdk = pkgs.google-cloud-sdk.withExtraComponents( with pkgs.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
    kubectl
    cloud_sql_proxy
  ]);
in
{

  fonts.fontconfig.enable = true;

  home.sessionPath = [ "$HOME/.jdks" ];
  home.file = (builtins.listToAttrs (builtins.map
    (jdk: {
      name = ".jdks/${jdk.version}";
      value = { source = jdk; };
    })
    additionalJDKs));

  # Only available in unstable branch ...
  # xdg.portal.xdgOpenUsePortal = true;

  home.packages = [
    gdk
    pkgs.jetbrains.datagrip
    pkgs.insomnia
    pkgs.keepassxc
  ];

  programs.git = {
    enable = true;
    delta.enable = true;
    extraConfig = {
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
          pkgs.git.override { withLibsecret = true; }
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
    shellAliases = { lat = "ls -lat"; lg = "lazygit"; };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "colored-man-pages" "history" "jsontools" "copypath" ];
    };
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
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
    '';
    envExtra = ''
      if [[ -z "$NIX_LD" ]]; then
        export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "''${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
      fi
      if [[ -z "$PNPM_HOME" ]]; then
        export PNPM_HOME="$HOME/.local/share/pnpm"
        case ":$PATH:" in
          *":$PNPM_HOME:"*) ;;
          *) export PATH="$PNPM_HOME:$PATH" ;;
        esac
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
      shell = {
        args = [ "-l" ];
        program = "${pkgs.tmux}/bin/tmux";
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
