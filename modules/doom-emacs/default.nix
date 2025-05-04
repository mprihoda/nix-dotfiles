{ config, lib, pkgs, ... }:

with lib;

let
  basePkg = if pkgs.stdenv.isDarwin then pkgs.emacs30 else pkgs.emacs30-nox;
  x11 = if pkgs.stdenv.isDarwin then true else false;
  emacsWithPackages = (pkgs.emacsPackagesFor basePkg).emacsWithPackages;
  myemacs = emacsWithPackages (epkgs: [
    epkgs.melpaPackages.vterm
    (epkgs.treesit-grammars.with-grammars (grammars:
      with grammars; [
        tree-sitter-bash
        tree-sitter-c
        tree-sitter-c-sharp
        tree-sitter-cmake
        tree-sitter-cpp
        tree-sitter-css
        tree-sitter-dockerfile
        tree-sitter-go
        tree-sitter-gomod
        tree-sitter-java
        tree-sitter-javascript
        tree-sitter-json
        tree-sitter-python
        tree-sitter-ruby
        tree-sitter-rust
        tree-sitter-toml
        tree-sitter-tsx
        tree-sitter-typescript
        tree-sitter-yaml
        tree-sitter-scala
      ]))
  ]);

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
