{ home-manager, sops-nix, nix-doom-emacs, emacs-overlay }:

{
  system = "x86_64-linux";
  modules = [
    {
      nixpkgs.overlays = [ emacs-overlay.overlay ];
    }
    home-manager.nixosModule
    sops-nix.nixosModule
    ./configuration.nix
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.mph = import ./home.nix { inherit nix-doom-emacs; };
      };
    }
  ];
}
