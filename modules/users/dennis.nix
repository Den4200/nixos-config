{ den, ... }:
{
  den.aspects.dennis = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];

    homeManager =
      { pkgs, lib, ... }:
      {
        gtk = {
          enable = true;
          gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
          gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
        };

        qt = {
          enable = true;
          platformTheme.name = "adwaita";
          style.name = "adwaita-dark";
        };

        programs.zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
        };

        programs.mise = {
          enable = true;
          enableZshIntegration = true;
          globalConfig = {
            settings = {
              minimum_release_age = "7d";
            };
            settings.python = {
              compile = false;
            };
          };
        };

        programs.git = {
          enable = true;
          signing = {
            key = null;
            signByDefault = true;
          };
          settings = {
            user = {
              name = "Dennis Pham";
              email = "dennis@dennispham.me";
            };
            advice.diverging = false;
            init.defaultBranch = "main";
            pull.ff = "only";
            push.autoSetupRemote = true;
            core.editor = lib.getExe pkgs.neovim;
          };
        };

        programs.rbw = {
          enable = true;
          settings = {
            email = "dennis@dennispham.me";
            pinentry = pkgs.pinentry-tty;
          };
        };

        home.pointerCursor = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
          size = 24;
          gtk.enable = true;
          x11.enable = true;
        };

        home.packages = with pkgs; [
          # editors
          neovim
          zed-editor

          # tools
          ansible
          awscli2
          azure-cli
          fastfetch
          gcc
          gh
          github-copilot-cli
          gnumake
          htop
          jq
          kubectl
          kubelogin
          nixd
          nixfmt
          nixfmt-tree
          opentofu
          pinentry-tty
          prek
          python3
          snyk
          talosctl
          yq

          # apps
          cider-2
          obsidian
          vesktop
        ];
      };

    provides.to-hosts.nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          gnupg
        ];

        environment.shellInit = ''
          gpg-connect-agent /bye
          export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
        '';

        programs.gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };

        programs.ssh.startAgent = false;
        services.pcscd.enable = true;

        # Enable nix-ld for dynamically linked binaries (mise, etc.)
        programs.nix-ld.enable = true;

        virtualisation.docker = {
          enable = true;
          daemon.settings = {
            features = {
              containerd-snapshotter = true;
            };
          };
        };
      };
  };
}
