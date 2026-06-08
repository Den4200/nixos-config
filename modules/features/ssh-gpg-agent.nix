{ self, inputs, ... }:
{
  flake.nixosModules.ssh-gpg-agent =
    { pkgs, lib, ... }:
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
    };
}
