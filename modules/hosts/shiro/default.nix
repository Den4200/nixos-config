{ self, inputs, ... }:
{
  flake.nixosConfigurations.shiro = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.shiroConfiguration
    ];
  };
}
