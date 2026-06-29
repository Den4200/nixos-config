{ ... }:
let
  pythonModule =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      options.python.extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
      };

      config.home.packages = [
        (pkgs.python3.withPackages (_: config.python.extraPackages))
      ];
    };
in
{
  den.aspects.dennis.homeManager.imports = [ pythonModule ];
}
