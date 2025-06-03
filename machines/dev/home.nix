{ config, pkgs, ... }: {

  home.username = "mph";
  home.homeDirectory = "/home/mph";

  home.packages = with pkgs; [
    # system mgmt
    docker
    docker-compose
    docker-credential-helpers
    ansible
    mosh

    # SQL
    mariadb-client

    # language support
    jdk21_headless
    nixfmt
    # nodejs-18_x
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
    helix
  ];

  imports = [
    ../../modules/neovim
    ../../modules/doom-emacs
    ../../modules/doom-emacs/linux-service.nix
  ];

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = ''
        PATH=/home/mph/.npm-global/bin:/home/mph/.local/share/coursier/bin:$PATH
    '';
    # bashrcExtra = ''
    #   BASH_ENV="${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
    # '';
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if string match -q "$TERM_PROGRAM" "vscode"
        set -l code (type -p code-insiders || type -p code)
        . ("$code" --locate-shell-integration-path fish)
      end
    '';
  };

  programs.gh.enable = true;

  programs.gpg.enable = true;
  targets.genericLinux.enable = true;

  services.ssh-agent.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    pinentryPackage = pkgs.pinentry-curses;
    # extraConfig = ''
    #   allow-emacs-pinentry
    #   allow-loopback-pinentry
    # '';
  };

  home.stateVersion = "22.11";
}
