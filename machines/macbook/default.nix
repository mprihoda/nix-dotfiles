{ home-manager, nix-doom-emacs, emacs-overlay, doom-emacs }:
let
  overlays = { ... }: {
    nixpkgs.overlays = [
      emacs-overlay.overlay
      # TODO: Remove after https://github.com/NixOS/nixpkgs/issues/137678 is fixed
      (import ./overlays/beautifulsoup4_fix.nix)
      (self: super: { doomEmacsRevision = doom-emacs.rev; })
    ];
  };

  hmConfig = { pkgs, ... }: {
    home-manager.useGlobalPkgs = true;
    home-manager.users.mph = {
      imports = [ ./modules/vscode ./modules/remote-notmuch ];
      home.packages = with pkgs; [
        # system mgmt
        docker
        docker-compose
        docker-machine
        docker-credential-helpers
        ansible

        # SQL
        mysql-client

        # language support
        adoptopenjdk-bin
        nixfmt
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
        mosh
        #ipfs

        # document tools
        pandoc
        texlive.combined.scheme-full

        msmtp
        fontconfig
      ];
    };
  };
in {
  system = "x86_64-darwin";
  modules = [
    home-manager.darwinModules.home-manager
    ./cachix.nix
    ./configuration.nix
    overlays
    hmConfig
    (import ../../modules/doom-emacs {
      x11 = true;
      # TODO: find a better way to do separate service config for darwin and linux
      # mkIf config.stdenv.isDarwin does not work, it complains about unset
      # config.environment.systemPath - which is on linux true
      serviceInit = ../../modules/doom-emacs/darwin-service.nix;
    })
  ];
}
