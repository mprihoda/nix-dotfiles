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
    tigervnc
    socat

    # source support
    vim
  ];

  imports = [ ../../modules/neovim ];

  programs.home-manager.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
    string match -q "$TERM_PROGRAM" "vscode" and . (code-insiders --locate-shell-integration-path fish)
    '';
  };
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "emacs";
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };

  home.stateVersion = "22.11";
}
