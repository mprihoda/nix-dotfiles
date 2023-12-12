{ pkgs, ... }:

{
  imports =
    [ ./modules/remote-notmuch ../../modules/neovim ../../modules/doom-emacs ];

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
    # adoptopenjdk-bin
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
    kitty
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
    helix

    # fonts
    iosevka-bin
    (iosevka-bin.override { variant = "sgr-iosevka-aile"; })
    (iosevka-bin.override { variant = "sgr-iosevka-fixed"; })
    (iosevka-bin.override { variant = "sgr-iosevka-term"; })
  ];

  fonts.fontconfig.enable = true;

  home.stateVersion = "22.11";
}
