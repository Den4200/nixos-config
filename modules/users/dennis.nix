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
          oh-my-zsh = {
            enable = true;
            theme = "robbyrussell";
            plugins = [
              "ansible"
              "argocd"
              "aws"
              "azure"
              "bun"
              "docker"
              "docker-compose"
              "gh"
              "git"
              "git-lfs"
              "gitignore"
              "golang"
              "helm"
              "istioctl"
              "kubectl"
              "kubectx"
              "mise"
              "npm"
              "pip"
              "poetry"
              "postgres"
              "pre-commit"
              "python"
              "opentofu"
              "redis-cli"
              "rsync"
              "rust"
              "sigstore"
              "ssh"
              "sudo"
              "systemd"
              "terraform"
              "uv"
              "vscode"
              "yarn"
            ];
          };
        };

        programs.direnv = {
          enable = true;
          enableZshIntegration = true;
          mise.enable = true;
          nix-direnv.enable = true;
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
          package = pkgs.gitFull;
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
            credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
          };
        };

        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
          settings = {
            "Host panda" = {
              HostName = "150.230.161.22";
              User = "ubuntu";
            };
            "Host tigress" = {
              HostName = "129.153.154.246";
              User = "ubuntu";
            };
            "Host monkey" = {
              HostName = "132.226.36.8";
              User = "ubuntu";
            };
            "Host oki" = {
              HostName = "192.168.1.50";
              User = "admin";
            };
            "Host anvil" = {
              HostName = "anvil.rcac.purdue.edu";
              User = "x-den";
            };
            "Host cs-borg01" = {
              HostName = "borg01.cs.purdue.edu";
              User = "pham143";
              ForwardX11 = true;
              ForwardX11Trusted = true;
            };
            "Host cs-data" = {
              HostName = "data.cs.purdue.edu";
              User = "pham143";
              ForwardX11 = true;
              ForwardX11Trusted = true;
            };
            "Host cs-lore" = {
              HostName = "lore.cs.purdue.edu";
              User = "pham143";
            };
            "Host cs-xinu01" = {
              HostName = "xinu01.cs.purdue.edu";
              User = "pham143";
              ForwardX11 = true;
              ForwardX11Trusted = true;
            };
            "Host cs-xinu02" = {
              HostName = "xinu02.cs.purdue.edu";
              User = "pham143";
              ForwardX11 = true;
              ForwardX11Trusted = true;
            };
            "Host cs-xinu16" = {
              HostName = "xinu16.cs.purdue.edu";
              User = "pham143";
              ForwardX11 = true;
              ForwardX11Trusted = true;
            };
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
          ghostty
          git-crypt
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
