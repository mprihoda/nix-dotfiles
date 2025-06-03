{ pkgs, ... }:

{
  #imports =
  #  [ ./modules/remote-notmuch ../../modules/neovim ../../modules/doom-emacs ];

  home.packages = with pkgs; [
    # system mgmt
    docker
    docker-compose
    docker-credential-helpers
    # ansible

    # SQL
    mariadb-client

    # language support
    # adoptopenjdk-bin
    nixfmt-classic

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
    zellij
    gnupg
    coreutils
    fish
    lazygit
    #eternal-terminal
    #kitty
    coursier
    sq
    #ipfs

    # document tools
    pandoc
    texlive.combined.scheme-full
    texlab

    # msmtp
    fontconfig
    # ledger
    # ledger-autosync
    helix

    # fonts
    iosevka-bin
    (iosevka-bin.override { variant = "SGr-Iosevka"; })
    (iosevka-bin.override { variant = "SGr-IosevkaFixed"; })
    (iosevka-bin.override { variant = "SGr-IosevkaTerm"; })
    cascadia-code
    fira
    hack-font
    jetbrains-mono
    victor-mono
  ];

  fonts.fontconfig.enable = true;

  home.stateVersion = "22.11";
}
