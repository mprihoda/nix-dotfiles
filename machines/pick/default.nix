{ home-manager, sops-nix, nix-doom-emacs, emacs-overlay, doom-emacs }:

{
  system = "x86_64-linux";
  modules = [
    ({ ... }: {
      nixpkgs.overlays = [
        emacs-overlay.overlay
        (self: super: { doomEmacsRevision = doom-emacs.rev; })
      ];
    })
    home-manager.nixosModules.home-manager
    sops-nix.nixosModules.sops
    ./configuration.nix
    ./cachix.nix
    ./modules/mph-mail
    ./home.nix
    (import ../../modules/doom-emacs { })
  ];
}
