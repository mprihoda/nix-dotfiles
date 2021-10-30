{ home-manager, nix-doom-emacs, emacs-overlay }: {
  system = "x86_64-darwin";
  modules = [
    home-manager.darwinModules.home-manager
    ./configuration.nix
    {
      nixpkgs.overlays = [ emacs-overlay.overlay ];
      home-manager.useGlobalPkgs = true;
      home-manager.users.mph = { pkgs, ... }: {
        imports = [ nix-doom-emacs.hmModule ];
        programs.doom-emacs = {
          enable = true;
          emacsPackage = pkgs.emacsGcc;
          doomPrivateDir = ./doom.d;
        };
      };
    }
  ];
}
