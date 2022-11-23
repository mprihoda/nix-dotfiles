{ config, lib, pkgs, ... }:

with lib;

let
  pkg = if pkgs.stdenv.isDarwin then pkgs.emacs else pkgs.emacs-nox;
  x11 = if pkgs.stdenv.isDarwin then true else false;
  emacsWithPackages = (pkgs.emacsPackagesFor pkg).emacsWithPackages;
  myemacs = emacsWithPackages (epkgs: [ epkgs.melpaPackages.vterm ]);

  editorScript = { name ? "emacseditor", x11 ? false, extraArgs ? [ ] }:
    pkgs.writeScriptBin name ''
      #!${pkgs.runtimeShell}
      # Why export TERM? Mic92 used it in his dotfiles, but it breaks colors in terminal on macbook.
      # export TERM=xterm-direct
      # breaks clipetty in combination with tmux + mosh? https://github.com/spudlyo/clipetty/pull/22
      unset SSH_TTY
      exec -a emacs ${myemacs}/bin/emacsclient \
        --create-frame \
        --alternate-editor ${myemacs}/bin/emacs \
        ${optionalString (!x11) "-nw"} \
        ${toString extraArgs} "$@"
    '';
in {
  programs.emacs = {
    enable = true;
    package = myemacs;
  };

  home.packages = [ (editorScript { inherit x11; }) ];
}
