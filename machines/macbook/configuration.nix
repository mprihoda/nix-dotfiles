{ config, pkgs, lib, ... }:

{
  # environment.systemPackages = with pkgs; [];

  environment.shells = [ pkgs.bashInteractive pkgs.zsh pkgs.fish ];

  # environment.variables.EDITOR = "hx";
  # environment.variables.GIT_EDITOR = "hx";

  # nix.nixPath = [
  #   { darwin-config = "${config.environment.darwinConfig}"; }
  #   "$HOME/.nix-defexpr/channels"
  # ];

  nix.settings.trusted-users = [ "mph" "@admin" ];

  system.primaryUser = "mph";

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # environment.etc."msmtprc".text = ''
  #   account default
  #   host smtp.fastmail.com

  #   auth on
  #   user michal@prihoda.net
  #   password 6yuwvdbakzt77qx6

  #   tls on
  #   tls_starttls off
  # '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;
  # environment.variables.SHELL = "${pkgs.fish}/bin/fish";

  programs.vim.enable = true;
  programs.vim.enableSensible = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

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
