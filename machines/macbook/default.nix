{ home-manager, nix-doom-emacs, emacs-overlay, doom-emacs, emacs29-src }:
let
  overlays = { ... }: {
    nixpkgs.overlays = [
      emacs-overlay.overlays.default
      (final: prev: {
        emacs29 = prev.emacsGit.overrideAttrs (old: {
          name = "emacs29";
          version = "29.0-${emacs29-src.shortRev}";
          src = emacs29-src;
          withPgtk = true;
        });
      })
      # TODO: Remove after https://github.com/NixOS/nixpkgs/issues/137678 is fixed
      # (import ./overlays/beautifulsoup4_fix.nix)
      # TODO: Remove after https://github.com/NixOS/nixpkgs/pull/161216 is in
      # (import ./overlays/ipython_darwin_fix.nix)
      # TODO: httpie test_plugins_upgrade is failing for some reason
      # (import ./overlays/httpie_darwin_fix.nix)
      (self: super: { doomEmacsRevision = doom-emacs.rev; })
    ];
  };

in {
  system = "x86_64-darwin";
  modules = [
    home-manager.darwinModules.home-manager
    ./cachix.nix
    ./configuration.nix
    overlays
    {
      home-manager.useGlobalPkgs = true;
      home-manager.users.mph = import ./home.nix;
    }
    ../../modules/doom-emacs/darwin-service.nix
  ];
}
