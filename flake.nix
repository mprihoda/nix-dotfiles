{
  inputs = {
    home-manager.url = "github:rycee/home-manager";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs/develop";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let

      inherit (nixpkgs) lib;
      inherit (inputs) home-manager sops-nix emacs-overlay nix-doom-emacs;

    in {
      nixosConfigurations.pick = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModule
          sops-nix.nixosModule
          ./configuration.nix
          {
            config = {
              nixpkgs.overlays = [ emacs-overlay.overlay ];
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.mph = import ./home.nix { inherit nix-doom-emacs; };
              };
            };
          }
        ];
      };
    };
}
