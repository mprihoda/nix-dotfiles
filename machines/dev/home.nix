{ config, pkgs, ... }: {

  home.username = "mph";
  home.homeDirectory = "/home/mph";

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
    jdk17_headless
    nixfmt
    scalafmt
    ammonite
    sbt
    bloop
    coursier
    nodejs-16_x
    yarn

    # utitilies
    inotify-tools
    httpie
    jq
    htop
    fzf
    ripgrep
    fd
    tmux
    dtach

    ## for docker
    pass
    gnupg
    pinentry
    tigervnc
    socat

    # source support
    vim
  ];

  imports = [ ../../modules/neovim ];

  programs.home-manager.enable = true;
  programs.fish.enable = true;

  home.stateVersion = "22.11";
}
