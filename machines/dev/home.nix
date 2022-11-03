{ config, pkgs, ... }: {

  home.username = "mph";
  home.homeDirectory = "/home/mph";

  imports = [ ../../modules/neovim ];

  programs.home-manager.enable = true;
  programs.fish.enable = true;

  home.stateVersion = "22.11";
}
