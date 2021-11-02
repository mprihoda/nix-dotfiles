{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    # system mgmt
    docker
    docker-compose
    docker-machine
    docker-credential-helpers
    ansible

    # term
    kitty

    # SQL
    mysql-client

    # language support
    adoptopenjdk-bin
    nixfmt
    scalafmt
    ammonite

    # security
    pass

    # utitilies
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
    #ipfs

    # document tools
    pandoc
    texlive.combined.scheme-full

    msmtp
    fontconfig
  ];

  environment.shells = [ pkgs.bashInteractive pkgs.zsh pkgs.fish ];

  environment.variables.EDITOR = "emacsclient -t";
  environment.variables.VISUAL = "emacsclient -c -a emacs";
  environment.variables.GIT_EDITOR = "emacsclient -c -a emacs";

  nix.nixPath = [
    { darwin-config = "${config.environment.darwinConfig}"; }
    "$HOME/.nix-defexpr/channels"
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;
  nix.package = pkgs.nixFlakes; # NOTE: EXPERIMENTAL.
  nix.extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
    "experimental-features = nix-command flakes";

  environment.etc."msmtprc".text = ''
    account default
    host smtp.fastmail.com

    auth on
    user michal@prihoda.net
    password 6yuwvdbakzt77qx6

    tls on
    tls_starttls off
  '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;
  # environment.variables.SHELL = "${pkgs.fish}/bin/fish";

  # programs.vim.enable = true;
  # programs.vim.enableSensible = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # does not exist for darwin
  # users.defaultUserShell = "/run/current-system/sw/bin/fish";
  users.users.mph = {
    home = "/Users/mph";
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;
}
