{ home-manager, sops-nix, nix-doom-emacs, emacs-overlay }:

{
  system = "x86_64-linux";
  modules = [
    { nixpkgs.overlays = [ emacs-overlay.overlay ]; }
    home-manager.nixosModules.home-manager
    sops-nix.nixosModules.sops
    ./configuration.nix
    ./cachix.nix
    ./modules/mph-mail
    (import ./home.nix { inherit nix-doom-emacs; })
  ];
}
