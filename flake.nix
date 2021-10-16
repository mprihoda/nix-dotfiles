{
  inputs = {
    home-manager.url = "github:rycee/home-manager";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs/develop";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    { self, nixpkgs, home-manager, nix-doom-emacs, emacs-overlay, sops-nix, ... }: {
      nixosConfigurations.pick = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          ./configuration.nix
          {
            nixpkgs.overlays = [ emacs-overlay.overlay ];
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.mph = import ./home.nix { inherit nix-doom-emacs; };
            };
          }
        ];
      };
    };
}
