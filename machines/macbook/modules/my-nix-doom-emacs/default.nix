{ nix-doom-emacs }:

{ pkgs, ... }: {
  imports = [ nix-doom-emacs.hmModule ];
  programs.doom-emacs = {
    enable = true;
    emacsPackage = pkgs.emacsNativeComp;
    doomPrivateDir = ../../doom.d;
  };
}
