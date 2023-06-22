{ myemacs, config, lib, pkgs, ... }:

let daemonFlag = if pkgs.stdenv.isDarwin then "--fg-daemon" else "--daemon";
in pkgs.writeScript "emacs-daemon" ''
  #!${pkgs.zsh}/bin/zsh
  test -e "~/.zshrc" && source ~/.zshrc
  export PATH=$PATH:${
    lib.makeBinPath [ pkgs.bash pkgs.git pkgs.sqlite pkgs.unzip pkgs.gcc ]
  }
  if [ ! -d $HOME/.config/emacs/.git ]; then
    mkdir -p $HOME/.config/emacs
    git -C $HOME/.config/emacs init
  fi
  if [ $(git -C $HOME/.config/emacs rev-parse HEAD) != ${pkgs.doomEmacsRevision} ]; then
    git -C $HOME/.config/emacs fetch https://github.com/hlissner/doom-emacs.git || true
    git -C $HOME/.config/emacs checkout ${pkgs.doomEmacsRevision} || true
    $HOME/.config/emacs/bin/doom sync || true
  fi
  exec ${myemacs}/bin/emacs ${daemonFlag}
''
