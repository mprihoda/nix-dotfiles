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

  imports = [ ../../modules/neovim ../../modules/doom-emacs ];

  programs.home-manager.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if string match -q "$TERM_PROGRAM" "vscode"
        set -l code (type -p code-insiders || type -p code)
        . ("$code" --locate-shell-integration-path fish)
      end
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
