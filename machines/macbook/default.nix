{ home-manager, nix-doom-emacs, emacs-overlay, doom-emacs }:
let
  overlays = { ... }: {
    nixpkgs.overlays = [
      emacs-overlay.overlay
      # TODO: Remove after https://github.com/NixOS/nixpkgs/issues/137678 is fixed
      (import ./overlays/beautifulsoup4_fix.nix)
      (self: super: { doomEmacsRevision = doom-emacs.rev; })
    ];
  };

  hmConfig = { ... }: {
    home-manager.useGlobalPkgs = true;
    home-manager.users.mph = {
      imports = [
        # (import ./modules/my-nix-doom-emacs { inherit nix-doom-emacs; })
        ./modules/vscode
      ];
    };
  };
in {
  system = "x86_64-darwin";
  modules = [
    home-manager.darwinModules.home-manager
    ./cachix.nix
    ./configuration.nix
    overlays
    hmConfig
    ./modules/my-doom-emacs
  ];
}
