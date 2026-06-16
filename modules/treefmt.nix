{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";

        programs.mdformat = {
          enable = true;
          settings = {
            wrap = "no";
          };
        };

        programs.nixfmt.enable = true;

        programs.yamlfmt = {
          enable = true;
          settings.formatter = {
            force_quote_style = "double";
            retain_line_breaks_single = true;
          };
        };
      };
    };
}
