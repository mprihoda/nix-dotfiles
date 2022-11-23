{ home-manager, sops-nix, nix-doom-emacs, emacs-overlay, doom-emacs
, vscode-server, eid-pki }:

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
    vscode-server.nixosModule
    eid-pki.nixosModules.eid-pki
    ./configuration.nix
    ./cachix.nix
    ./modules/mph-mail
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.mph = import ./home.nix;
      };
    }
  ];
}
