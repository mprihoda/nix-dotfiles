{ myemacs, config, lib, pkgs, ... }:

let
  daemonFlag = if pkgs.stdenv.isDarwin then "--fg-daemon" else "--daemon";
in pkgs.writeScript "emacs-daemon" ''
  #!${pkgs.zsh}/bin/zsh
  source ~/.zshrc
  export PATH=$PATH:${
    lib.makeBinPath [ pkgs.bash pkgs.git pkgs.sqlite pkgs.unzip ]
  }
  if [ ! -d $HOME/.emacs.d/.git ]; then
    mkdir -p $HOME/.emacs.d
    git -C $HOME/.emacs.d init
  fi
  if [ $(git -C $HOME/.emacs.d rev-parse HEAD) != ${pkgs.doomEmacsRevision} ]; then
    git -C $HOME/.emacs.d fetch https://github.com/hlissner/doom-emacs.git || true
    git -C $HOME/.emacs.d checkout ${pkgs.doomEmacsRevision} || true
    $HOME/.emacs.d/bin/doom sync || true
  fi
  exec ${myemacs}/bin/emacs ${daemonFlag}
''
