{ pkgs, ... }:

{
  imports = [ ./modules/vscode ./modules/remote-notmuch ../../modules/neovim ];
  home.packages = with pkgs; [
    # system mgmt
    docker
    docker-compose
    docker-machine
    docker-credential-helpers
    ansible

    # SQL
    mysql-client

    # language support
    adoptopenjdk-bin
    nixfmt
    ammonite

    # security
    pass

    # utitilies
    # TODO: temporary disabled, build failing in tests/test_plugins_cli.py
    httpie
    jq
    git-town
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

    msmtp
    fontconfig
    ledger
    ledger-autosync
  ];
  home.stateVersion = "22.11";
}
