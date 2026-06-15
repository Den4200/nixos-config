{ inputs, ... }:
{
  den.aspects.dennis.homeManager =
    { pkgs, lib, ... }:
    {
      imports = [ inputs.walker.homeManagerModules.default ];

      home.packages = [
        (pkgs.writeShellScriptBin "bw-unlock" ''
          rbw unlock && systemctl --user restart elephant
        '')
      ];

      programs.walker = {
        enable = true;
        runAsService = true;
      };

      programs.elephant.provider.menus.toml."power" = {
        name = "power";
        name_pretty = "Power";
        icon = "system-shutdown";
        action = "sh -c '%VALUE%'";
        entries = [
          {
            text = "Shutdown";
            value = "systemctl poweroff";
          }
          {
            text = "Reboot";
            value = "systemctl reboot";
          }
          {
            text = "Suspend";
            value = "systemctl suspend";
          }
          {
            text = "Lock";
            value = "${lib.getExe pkgs.swaylock}";
          }
          {
            text = "Log Out";
            value = "niri msg action quit";
          }
        ];
      };

      # Ensure elephant can find bitwarden/clipboard/typing tools + system binaries
      systemd.user.services.elephant.Service.Environment = [
        "PATH=${
          lib.makeBinPath [
            pkgs.rbw
            pkgs.wl-clipboard
            pkgs.wtype
          ]
        }:/run/current-system/sw/bin:/home/%u/.nix-profile/bin"
      ];

      # Run rbw-agent independently so it survives elephant restarts
      systemd.user.services.rbw-agent = {
        Unit.Description = "Bitwarden CLI agent (rbw)";
        Install.WantedBy = [ "default.target" ];
        Service = {
          ExecStart = "${pkgs.rbw}/bin/rbw-agent --no-daemonize";
          Restart = "on-failure";
        };
      };

      # Make elephant start after rbw-agent (but don't hard-depend)
      systemd.user.services.elephant.Unit.After = [ "rbw-agent.service" ];
    };
}
