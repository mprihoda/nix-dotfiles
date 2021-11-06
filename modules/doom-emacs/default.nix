{ x11 ? false, user ? "mph", serviceInit ? ./linux-service.nix }:

{ config, lib, pkgs, ... }:

with lib;

let
  emacsWithPackages = (pkgs.emacsPackagesFor pkgs.emacsGcc).emacsWithPackages;
  myemacs = emacsWithPackages (epkgs: [ epkgs.melpaPackages.vterm ]);

  editorScript = { name ? "emacseditor", x11 ? false, extraArgs ? [ ] }:
    pkgs.writeScriptBin name ''
      #!${pkgs.runtimeShell}
      export TERM=xterm-direct
      # breaks clipetty in combination with tmux + mosh? https://github.com/spudlyo/clipetty/pull/22
      unset SSH_TTY
      exec -a emacs ${myemacs}/bin/emacsclient \
        --create-frame \
        --alternate-editor ${myemacs}/bin/emacs \
        ${optionalString (!x11) "-nw"} \
        ${toString extraArgs} "$@"
    '';

  daemonScript = pkgs.writeScript "emacs-daemon" ''
    #!${pkgs.zsh}/bin/zsh
    source ~/.zshrc
    export PATH=$PATH:${lib.makeBinPath [ pkgs.git pkgs.sqlite pkgs.unzip ]}
    if [ ! -d $HOME/.emacs.d/.git ]; then
      mkdir -p $HOME/.emacs.d
      git -C $HOME/.emacs.d init
    fi
    if [ $(git -C $HOME/.emacs.d rev-parse HEAD) != ${pkgs.doomEmacsRevision} ]; then
      git -C $HOME/.emacs.d fetch https://github.com/hlissner/doom-emacs.git || true
      git -C $HOME/.emacs.d checkout ${pkgs.doomEmacsRevision} || true
      $HOME/.emacs.d/bin/doom sync || true
    fi
    exec ${myemacs}/bin/emacs --fg-daemon
  '';

in mkMerge [
  {
    home-manager.users.${user} = {
      programs.emacs = {
        enable = true;
        package = myemacs;
      };

      home.packages = [ (editorScript { inherit x11; }) ];

    };
  }

  (import serviceInit { inherit daemonScript user config pkgs lib; })
]
