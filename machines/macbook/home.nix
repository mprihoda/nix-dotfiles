{ pkgs, ... }:

{
  imports = [ ./modules/remote-notmuch ../../modules/neovim ];
  home.packages = with pkgs; [
    # system mgmt
    docker
    docker-compose
    docker-machine
    docker-credential-helpers
    ansible

    # SQL
    mariadb-client

    # language support
    adoptopenjdk-bin
    nixfmt
    ammonite

    # security
    pass

    # utitilies
    terminal-notifier
    httpie
    jq
    # git-town
    htop
    fzf
    ripgrep
    fd
    mosh
    tmux
    gnupg
    coreutils
    fish
    direnv
    mosh
    #eternal-terminal
    coursier
    #ipfs

    # document tools
    pandoc
    texlive.combined.scheme-full
    texlab

    msmtp
    fontconfig
    ledger
    ledger-autosync
  ];
  home.stateVersion = "22.11";
}
