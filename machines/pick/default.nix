{ home-manager, sops-nix, nix-doom-emacs, emacs-overlay }:

{
  system = "x86_64-linux";
  modules = [
    { nixpkgs.overlays = [ emacs-overlay.overlay ]; }
    home-manager.nixosModule
    sops-nix.nixosModule
    ./configuration.nix
    ./cachix.nix
    ./modules/mph-mail
    (import ./home.nix { inherit nix-doom-emacs; })
  ];
}
