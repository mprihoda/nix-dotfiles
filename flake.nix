{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-21.05-darwin";
    home-manager.url = "github:rycee/home-manager";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs/develop";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    sops-nix.url = "github:Mic92/sops-nix";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
  };

  outputs = { self, nixpkgs, darwin, ... }@inputs: {
    # Build with: nixos-rebuild build --flake '.#' (uses hostname to pick machine)
    # Switch with: nixos-rebuild switch --flake '.#'
    nixosConfigurations = {
      pick = nixpkgs.lib.nixosSystem (import ./machines/pick {
        inherit (inputs) home-manager sops-nix nix-doom-emacs emacs-overlay;
      });
    };

    # Build with: nix build .#darwinConfigurations.Macbook-Pro.system
    # Switch with: ./result/sw/bin/darwin-rebuild switch --flake .#Macbook-Pro
    darwinConfigurations = {
      "Macbook-Pro" = darwin.lib.darwinSystem (import ./machines/darwin {
        inherit (inputs) home-manager nix-doom-emacs emacs-overlay;
      });
    };
  };
}
