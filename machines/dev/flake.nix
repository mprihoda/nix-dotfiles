{
  description = "Home Manager configuration of Michal Prihoda";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    doom-emacs = {
      url = "github:hlissner/doom-emacs";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, emacs-overlay, doom-emacs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          emacs-overlay.overlay
          (self: super: { doomEmacsRevision = doom-emacs.rev; })
        ];
      };
    in {
      homeConfigurations.mph = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
