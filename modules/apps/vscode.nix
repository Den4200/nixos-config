{ inputs, ... }:
{
  den.aspects.dennis.homeManager =
    { pkgs, lib, ... }:
    let
      extensions = (
        import inputs.nixpkgs {
          system = pkgs.stdenv.hostPlatform.system;
          config.allowUnfree = true;
          overlays = [ inputs.nix-vscode-extensions.overlays.default ];
        }
      );
      marketplace = extensions.vscode-marketplace;
    in
    {
      programs.vscode = {
        enable = true;
        argvSettings = {
          enable-crash-reporter = true;
          crash-reporter-id = "429f0eeb-00f4-4095-a3ae-a4883c6f5b27";
          password-store = "gnome-libsecret";
        };
        profiles.default = {
          extensions = with marketplace; [
            # Theme
            monokai.theme-monokai-pro-vscode

            # Languages
            astro-build.astro-vscode
            charliermarsh.ruff
            golang.go
            grafana.vscode-jsonnet
            graphql.vscode-graphql-syntax
            hashicorp.hcl
            jnoortheen.nix-ide
            jq-syntax-highlighting.jq-syntax-highlighting
            marketplace."13xforever".language-x86-64-assembly
            mikestead.dotenv
            ms-python.debugpy
            ms-python.flake8
            ms-python.isort
            ms-python.python
            ms-python.vscode-pylance
            ms-python.vscode-python-envs
            opentofu.vscode-opentofu
            prisma.prisma
            redhat.vscode-xml
            redhat.vscode-yaml
            rust-lang.rust-analyzer
            svelte.svelte-vscode
            tamasfe.even-better-toml
            unifiedjs.vscode-mdx
            vue.volar
            william-voyek.vscode-nginx

            # Web dev
            bradlc.vscode-tailwindcss
            dbaeumer.vscode-eslint
            esbenp.prettier-vscode
            expo.vscode-expo-tools
            ritwickdey.liveserver

            # AI
            # anthropic.claude-code
            github.copilot-chat
            openai.chatgpt

            # Docker / K8s
            kennylong.kubernetes-yaml-formatter
            ms-azuretools.vscode-containers
            ms-azuretools.vscode-docker
            ms-kubernetes-tools.vscode-kubernetes-tools
            ms-vscode-remote.remote-containers

            # Remote
            ms-vscode-remote.remote-ssh
            ms-vscode-remote.remote-ssh-edit
            ms-vscode.remote-explorer
            ms-vscode.remote-server

            # Tools
            docker.docker
            faubulous.mentor
            github.vscode-github-actions
            ms-playwright.playwright
            ms-vscode.cmake-tools
            ms-vscode.cpp-devtools
            ms-vscode.makefile-tools
            ms-vscode.powershell
            ms-vsliveshare.vsliveshare
            tsandall.opa

            # Jupyter
            ms-toolsai.jupyter
            ms-toolsai.jupyter-keymap
            ms-toolsai.jupyter-renderers
            ms-toolsai.vscode-jupyter-cell-tags
            ms-toolsai.vscode-jupyter-slideshow
          ];
          userSettings = {
            # Theme
            "workbench.colorTheme" = "Monokai Pro";
            "workbench.iconTheme" = "Monokai Pro Icons";

            # Window
            "window.menuBarVisibility" = "toggle";
            "window.titleBarStyle" = "custom";

            # Editor
            "editor.inlayHints.enabled" = "offUnlessPressed";
            "editor.inlineSuggest.enabled" = true;
            "editor.tokenColorCustomizations" = {
              "textMateRules" = [
                {
                  "scope" = "keyword.other.dotenv";
                  "settings" = {
                    "foreground" = "#FF000000";
                  };
                }
              ];
            };

            # Diff editor
            "diffEditor.ignoreTrimWhitespace" = false;
            "diffEditor.hideUnchangedRegions.enabled" = true;

            # Files
            "files.autoSave" = "afterDelay";

            # Formatters
            "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "[typescriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "[html]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "[css]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "[vue]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "[markdown]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "[mdx]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "[dockercompose]" = {
              "editor.insertSpaces" = true;
              "editor.tabSize" = 2;
              "editor.autoIndent" = "advanced";
              "editor.quickSuggestions" = {
                "other" = true;
                "comments" = false;
                "strings" = true;
              };
              "editor.defaultFormatter" = "redhat.vscode-yaml";
            };
            "[github-actions-workflow]"."editor.defaultFormatter" = "redhat.vscode-yaml";

            # Python
            "[python]"."editor.formatOnType" = true;
            "flake8.args" = [ "--max-line-length=99" ];

            # Extensions
            "svelte.enable-ts-plugin" = true;
            "liveServer.settings.donotShowInfoMsg" = true;
            "playwright.reuseBrowser" = false;
            "docker.extension.enableComposeLanguageServer" = false;
            "github.copilot.nextEditSuggestions.enabled" = true;
            "yaml.disableSchemaDetection" = [
              "**/.github/workflows/*.yml"
              "**/.github/workflows/*.yaml"
              "**/.gitea/workflows/*.yml"
              "**/.gitea/workflows/*.yaml"
              "**/.forgejo/workflows/*.yml"
              "**/.forgejo/workflows/*.yaml"
            ];
          };
        };
      };
    };
}
