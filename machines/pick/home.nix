{ nix-doom-emacs, ... }:
{ pkgs, config, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.mph = {
      imports = [ nix-doom-emacs.hmModule ];
      programs.doom-emacs = {
        enable = true;
        emacsPackage = pkgs.emacsGcc;
        doomPrivateDir = ./doom.d;
      };
      services.emacs = { enable = true; };
      programs.fish.enable = true;
    };
  };
}
