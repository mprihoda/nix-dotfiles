{ nix-doom-emacs, ... }:
{ pkgs, config, ... }: {
  imports = [ nix-doom-emacs.hmModule ];
  programs.doom-emacs = {
    enable = true;
    emacsPackage = pkgs.emacsGcc;
    doomPrivateDir = ./doom.d;
  };
  services.emacs = {
    enable = true;
  };
}
