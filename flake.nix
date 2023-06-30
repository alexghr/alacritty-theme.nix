{
  description = "alacritty/alacritty-theme packaged for Nix consumption";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    alacritty-theme = {
      url = "github:alacritty/alacritty-theme";
      flake = false;
    };
  };

  outputs = inputs@{ self, flake-parts, alacritty-theme, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [];
      flake = {
        overlays.alacritty-theme = final: prev: {
          alacritty-theme = self.packages.${prev.system};
        };
        overlays.default = self.overlays.alacritty-theme;
      };
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      perSystem = {  pkgs, ... }:
        let
          isYaml = file: pkgs.lib.hasSuffix ".yaml" file || pkgs.lib.hasSuffix ".yml" file;
          withoutYamlExtension = file: pkgs.lib.removeSuffix ".yml" (pkgs.lib.removeSuffix ".yaml" file);
          dirEntries = builtins.attrNames (builtins.readDir "${alacritty-theme}/themes");
          themeFiles = builtins.filter isYaml dirEntries;
          themeDerivations = builtins.map (file: rec {
            name = withoutYamlExtension file;
            value = pkgs.stdenv.mkDerivation {
              inherit name;
              phases = [ "installPhase" ];
              installPhase = ''
                runHook preInstall
                cp ${alacritty-theme}/themes/${file} $out
                runHook postInstall
              '';
            };
          }) themeFiles;
        in {
          packages = builtins.listToAttrs themeDerivations;
        };
    };
}
