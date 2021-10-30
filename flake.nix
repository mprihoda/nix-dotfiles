{
  inputs = {
    home-manager.url = "github:rycee/home-manager";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs/develop";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {
        pick = nixpkgs.lib.nixosSystem (import ./machines/pick {
          inherit (inputs) home-manager sops-nix nix-doom-emacs emacs-overlay;
        });
      };

    };
}
