# alacritty-theme.nix

This repo packages all of the themes available at [alacritty/alacritty-theme](https://github.com/alacritty/alacritty-theme)
as individual flake outputs for easy use in your nix-managed Alacritty config.

> ❗❗❗
> Since [this PR](https://github.com/alexghr/alacritty-theme.nix/pull/4) the themes are exported as TOML files. They can only be consumed by Alacritty >= 0.13.0 (currently avilable in nixpkgs-unstable but not in nixos-23.11). If you're using Alacritty from a stable NixOS release then pin this commit [2cd654](https://github.com/alexghr/alacritty-theme.nix/commit/2cd654fa494fc8ecb226ca1e7c5f91cf1cebbba9) to consume YAML formatted themes.


## Outputs

Each TOML file in the [alacritty-theme/themes](https://github.com/alacritty/alacritty-theme/tree/0fb8868d6389014fd551851df7153e4ca2590790/themes) folder is exported as a package.

Furthermore an overlay is provided that groups all of these themes under a single attribute set: `pkgs.alacritty-theme`.

## Apply a color scheme using home-manager

This sample config applies the overlay and configures `cyber_punk_neon` as the color scheme for Alacritty using home-manager.

You can read more about installing overlays with Flakes [on NixOS Wiki](https://nixos.wiki/wiki/Flakes#Importing_packages_from_multiple_channels).

```nix
# flake.nix
{
  inputs.alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
  outputs = { nixpkgs, alacritty-theme, ... }: {
    nixosConfigurations.yourComputer =  nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ config, pkgs, ...}: {
          # install the overlay
          nixpkgs.overlays = [ alacritty-theme.overlays.default ];
        })
        ({ config, pkgs, ... }: {
          home-manager.users.you = hm: {
            programs.alacritty = {
              enable = true;
              # use a color scheme from the overlay
              settings.import = [ pkgs.alacritty-theme.cyber_punk_neon ];
            };
          };
        })
      ];
    };
  };
}
```

That's it :smile:

## Binary Cache

I maintain a personal binary cache running [Attic](https://github.com/zhaofengli/attic) and push outputs to it. To use the cache add it and its public key to your `configuration.nix`:

```nix
# configuration.nix
{
  nix.settings = {
    extra-substituters = [
      "https://attic.alexghr.me/public"
    ];
    extra-trusted-public-keys = [
      "public:5MqPjBBGMCWbo8L8voeQl7HXc5oX+MXZ6BSURfMosIo="
    ];
    # only if your user is not trusted already
    extra-trusted-users = [
      "<your username>"
    ];
  };
}
```

Or to your `nix.conf` if you're not running NixOS:

```conf
# nix.conf
extra-substituters = https://attic.alexghr.me/public
extra-trusted-public-keys = public:5MqPjBBGMCWbo8L8voeQl7HXc5oX+MXZ6BSURfMosIo=
extra-trusted-users = <your username>
```
