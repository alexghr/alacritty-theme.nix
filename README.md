# alacritty-theme.nix

This repo packages all of the themes available at [alacritty/alacritty-theme](https://github.com/alacritty/alacritty-theme)
as individual flake outputs for easy use in your nix-managed Alacritty config.

## Outputs

Each YAML file in the [alacritty-theme/themes](https://github.com/alacritty/alacritty-theme/tree/0fb8868d6389014fd551851df7153e4ca2590790/themes) folder is exported as a package.

Furthermore an overlay is provided that groups all of these themes under a single attribute set: `pkgs.alacritty-theme`.

## Using a theme

Add this repo to your inputs:

```nix
# flake.nix
{
  inputs.alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
}
```

Install the default overlay. This will make `pkgs.alacritty-theme` available:

```nix
{
  nixpkgs.overlays = [ alacritty-theme.overlays.default ];
}
```

Finally, import a theme in your alacritty config:

```nix
# using home-manager
{
  home-manager.users.you = hm: {
    programs.alacritty = {
      enable = true;
      settings = {
        import = [
          pkgs.alacritty-theme.cyber_punk_neon
        ];
      };
    };
  };
}
```

That's it :smile:
