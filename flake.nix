{
  inputs = {
    home-manager.url = "github:rycee/home-manager";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs/develop";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs =
    { self, nixpkgs, home-manager, nix-doom-emacs, emacs-overlay, ... }: {
      nixosConfigurations.pick = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
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
