{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs/develop";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs29-src.url = "github:emacs-mirror/emacs/emacs-29";
    emacs29-src.flake = false;
    sops-nix.url = "github:Mic92/sops-nix";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    doom-emacs.url = "github:hlissner/doom-emacs";
    doom-emacs.flake = false;

    vscode-server.url = "github:msteen/nixos-vscode-server";
    eid-pki.url = "git+https://gitlab.e-bs.cz/mph/eid-nix-pki.git?ref=main";
  };

  outputs = { self, nixpkgs, darwin, ... }@inputs: {
    # Build with: nixos-rebuild build --flake '.#' (uses hostname to pick machine)
    # Switch with: nixos-rebuild switch --flake '.#'
    nixosConfigurations = {
      pick = nixpkgs.lib.nixosSystem (import ./machines/pick {
        inherit (inputs)
          home-manager sops-nix nix-doom-emacs emacs-overlay doom-emacs
          vscode-server eid-pki;
      });
    };

    # Build with: nix build .#darwinConfigurations.Macbook-Pro.system
    # Switch with: ./result/sw/bin/darwin-rebuild switch --flake .#Macbook-Pro
    darwinConfigurations = {
      "MacBook-Pro" = darwin.lib.darwinSystem (import ./machines/macbook {
        inherit (inputs)
          home-manager doom-emacs;
      });
    };
  };
}
