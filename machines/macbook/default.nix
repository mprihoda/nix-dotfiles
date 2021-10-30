{ home-manager, nix-doom-emacs, emacs-overlay }: {
  system = "x86_64-darwin";
  modules = [
    home-manager.darwinModules.home-manager
    ./configuration.nix
    {
      nixpkgs.overlays = [
        emacs-overlay.overlay
        # TODO: Remove after https://github.com/NixOS/nixpkgs/issues/137678 is fixed
        (self: super:
          let lib = super.lib;
          in rec {
            python39 = super.python39.override {
              packageOverrides = self: super: {
                beautifulsoup4 = super.beautifulsoup4.overrideAttrs (old: {
                  propagatedBuildInputs =
                    lib.remove super.lxml old.propagatedBuildInputs;
                });
              };
            };
            python39Packages = python39.pkgs;
          })
      ];
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
