{
  inputs = {
    home-manager.url = "github:rycee/home-manager";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs/develop";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.pick = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.home-manager.nixosModule
        inputs.sops-nix.nixosModule
        ./configuration.nix
        {
          config = {
            nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.mph =
                import ./home.nix { inherit (inputs) nix-doom-emacs; };
            };
          };
        }
      ];
    };
  };
}
