{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      gruvbox
      nvim-lspconfig
      lspkind-nvim
      telescope-nvim
      telescope-file-browser-nvim
      lsp_signature-nvim
      bufferline-nvim
      nvim-web-devicons
      nvim-tree-lua
      nvim-metals
      nvim-cmp
      cmp-nvim-lsp
      cmp-vsnip
      vim-vsnip
      plenary-nvim
      popup-nvim
      vim-fugitive
      nvim-dap
      vim-nix
      nvim-treesitter
      nvim-treesitter-textobjects
      rainbow-delimiters-nvim
      # TODO: add plugins, see https://github.com/shadowninja55/nixos-config/blob/master/flake.nix
      # nest-nvim
      # dracula-nvim
      # nvim-orgmode
      # scaladex
      # tmux integration
      # TODO: replace with feline-nvim
      lualine-nvim
      vim-grepper
      copilot-lua
      copilot-cmp
    ];
    # Point directly to .dotfiles for now. I will move the config into nix after it is a bit more stable.
    extraConfig = ''
      colorscheme gruvbox
      syntax on
      set rtp+=~/.dotfiles/modules/neovim/config
      lua require('my-config')
    '';
  };
}
