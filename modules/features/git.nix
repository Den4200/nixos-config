{ self, inputs, ... }:
{
  flake.nixosModules.git =
    { pkgs, lib, ... }:
    {
      programs.git = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myGit;
      };
    };

  perSystem =
    { pkgs, lib, ... }:
    {
      packages.myGit = inputs.wrapper-modules.wrappers.git.wrap {
        inherit pkgs;
        settings = {
          commit.gpgsign = true;
          core.editor = lib.getExe pkgs.neovim;
          init.defaultBranch = "main";
          pull.ff = "only";
          push.autoSetupRemote = true;
          user.email = "dennis@dennispham.me";
          user.name = "Dennis Pham";
        };
      };
    };
}
