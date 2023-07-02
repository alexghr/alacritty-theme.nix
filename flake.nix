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
      imports = [ ];
      flake = {
        overlays.alacritty-theme = final: prev: {
          alacritty-theme = self.packages.${prev.system};
        };
        overlays.default = self.overlays.alacritty-theme;
      };
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      perSystem = { lib, pkgs, ... }:
        let
          isYaml = file: lib.hasSuffix ".yaml" file || lib.hasSuffix ".yml" file;
          withoutYamlExtension = file: lib.removeSuffix ".yml" (lib.removeSuffix ".yaml" file);
          dirEntries = lib.attrNames (builtins.readDir "${alacritty-theme}/themes");
          themeFiles = lib.filter isYaml dirEntries;
          mkThemePackage = themeFile:
            let
              name = withoutYamlExtension themeFile;
            in
            lib.nameValuePair name (pkgs.stdenvNoCC.mkDerivation {
              inherit name;
              dontUnpack = true;
              dontConfigure = true;
              dontBuild = true;
              installPhase = ''
                runHook preInstall
                cp --reflink=auto ${alacritty-theme}/themes/${themeFile} $out
                runHook postInstall
              '';
            });
          themeDerivations = map mkThemePackage themeFiles;
        in
        {
          packages = lib.listToAttrs themeDerivations;
        };
    };
}
