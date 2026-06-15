{ lib, den, ... }:
{
  den.default.nixos.system.stateVersion = "26.05";
  den.default.homeManager.home.stateVersion = "26.05";
  den.default.homeManager.nixpkgs.config.allowUnfree = true;

  # enable hm by default for all users
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
}
