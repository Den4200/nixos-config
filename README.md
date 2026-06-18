# Nix Config

My current and everchanging dendritic Nix configuration flake.

![Desktop](./desktop.png)

## Helpful Commands

```sh
# Rebuild shiro and switch to new generation
nix run .#shiro -- switch

# Update flake file
nix run .#write-flake

# Pull flake updates
nix flake update [flake]

# Check flake evaluates successfully and is formatted correctly
nix flake check

# Format all files
nix fmt

# Compare current system to pending upgrades
nix run .#shiro -- build
nix store diff-closures /run/current-system ./result
rm result
```
