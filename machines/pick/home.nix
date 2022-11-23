{ ... }: {
  imports = [
    ../../modules/neovim
    ../../modules/doom-emacs
    ../../modules/doom-emacs/linux-service.nix
  ];
  programs.fish.enable = true;
  home.stateVersion = "22.11";
}
