# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, ... }:

let
  oper2 = ./oper2.pem;
  int_rca = ./internal_rca.pem;
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./cachix.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  boot.kernel.sysctl = { "fs.inotify.max_user_watches" = 524288; };

  networking = {
    enableIPv6 = false;
    hostName = "pick"; # Define your hostname.
    useDHCP = false;
    interfaces = {
      ens3 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "193.86.200.14";
            prefixLength = 24;
          }
          {
            address = "193.86.200.16";
            prefixLength = 24;
          }
        ];
      };
    };
    defaultGateway = "193.86.200.3";
    nameservers = [ "193.86.200.10" "1.1.1.1" "1.0.0.1" ];
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];
  nixpkgs.config.packageOverrides = pkgs: {
    jre = pkgs.adoptopenjdk-openj9-bin-11; # .overrideAttrs (attrs: {
    #      installPhase = ''
    #       ${attrs.installPhase}
    #       $out/bin/keytool -importcert -trustcacerts -noprompt -alias oper2 -cacerts -storepass changeit -file ${oper2}
    #      '';
    #    });
  };

  nixpkgs.config.allowUnfree = true;

  # Install the flakes edition
  nix = {
    package = pkgs.nixFlakes;
    # Enable the nix 2.0 CLI and flakes support feature-flags
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    settings = {
      trusted-users = [ "root" "mph" ];
      allowed-users = [ "mph" ];
    };
  };

  # TODO: move most of the packages to home-manager / project tools
  environment.systemPackages = with pkgs; [
    # system mgmt
    docker
    docker-compose
    docker-machine
    docker-credential-helpers
    ansible

    # SQL
    mysql-client

    # language support
    jre
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
    # git-town
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
    ## for org-roam
    sqlite

    # source support
    vim
    neovim
    git
    # for doom emacs and projector
    (python3.withPackages (p: with p; [ virtualenv ]))

    #mail
    #notmuch
    #afew

    # web
    #epiphany
    #firefox-devedition-bin

    # fonts
    #iosevka-bin
    dmenu
    st
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = false;
    enableSSHSupport = true;
    pinentryFlavor = "emacs";
  };

  services.tailscale = { enable = true; };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };

  services.eternal-terminal = { enable = true; };

  services.vscode-server.enable = true;

  # Code server
  services.code-server = {
    enable = true;
    user = "mph";
    group = "users";
    hashedPassword =
      "$argon2i$v=19$m=4096,t=3,p=1$+CAbWsHaqRmDfMisqV1dTg$TrXOX5uk2u+YTW2pYSu89Jwk/pVSr5lQh2SnHnih2w4";
  };

  services.httpd = {
    enable = true;
    user = "mph";
    group = "users";
    adminAddr = "michal@prihoda.net";
    extraConfig = ''
      DAVLockDB /run/httpd/DAVLock
      DAVMinTimeout 600
    '';
    virtualHosts = {
      "pick" = {
        hostName = "pick.iterative.works";
        enableACME = true;
        forceSSL = true;
        documentRoot = "/home/mph/www";
        locations = {
          "/org" = {
            extraConfig = ''
              DAV On
              AuthType Basic
              AuthName "Org Files"
              AuthUserFile /home/mph/.DAVlogin
              Require valid-user
            '';
          };
        };
      };
    };
  };

  services.syncthing = {
    enable = true;
    user = "mph";
    dataDir = "/home/mph";
  };

  programs.fish.enable = true;
  programs.mosh.enable = true;
  programs.java = {
    enable = true;
    package = pkgs.jre;
  };

  # For tailscale
  networking.firewall.checkReversePath = "loose";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 443 9001 2022 ];
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  services.xserver = {
    enable = false;
    autorun = false;
    libinput.enable = true;
    displayManager.sddm.enable = false;
    windowManager.dwm.enable = true;
    desktopManager.xterm.enable = true;
  };

  services.xrdp = {
    enable = true;
    defaultWindowManager = "dwm";
  };

  environment.etc.openvpn = { source = ./openvpn; };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.secrets."openvpn/oper/mph.key" = { };
  sops.secrets."openvpn/cmi/cmi.key" = { };
  sops.secrets."openvpn/cmi/ta.key" = { };
  sops.secrets."openvpn/ebs/ta.key" = { };
  sops.secrets."openvpn/eid/ta.key" = { };

  services.openvpn.servers = let
    mkServer = name: {
      name = "${name}";
      value = {
        autoStart = true;
        config = "config /etc/openvpn/${name}.conf";
      };
    };
    configs = [ "eid-admin" "cra-admin" "ebs" "cmi-portal" ];
  in builtins.listToAttrs (map mkServer configs);

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };
  users.users.mph = {
    isNormalUser = true;
    home = "/home/mph";
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    description = "Michal Prihoda";
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [''
      ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDO6sYzQBt+7Z7oRDMJRQGvbsctYCoBXH4KU9S6f3jp6lSbE7KhtaTJkf3GF2/4nV5qbD5ugqcx5ydJUOnLwxrJ0c+rRDXm+px0CgRsinYsqNVfa/VuOZq7aDKK1iujYk24bDkYVL7qg4zyUdAHsNQuwVgyAcOWqFy93FuRQb5Aakxleb1Z3NEJOxQj/D/ArXpX//3SY3Na2qH41+TyU0j3BTJWXTmiILPVtN4us6QxNH0NY/NmuAlcfVnivcW051IH9iPIBnV39I9ScRTQwx6SyPvxr/W48OUMVc3E5hkwaUWmUgTcoUMhqfU8VZ/coKesyFALM9GeDtbOj4+b2lsV mph@Michals-iMac.local
    ''];
  };

  security.sudo.wheelNeedsPassword = false;

  security.pki.certificateFiles = [ ./oper2.pem ./internal_rca.pem ];

  security.acme.defaults.email = "michal@prihoda.net";
  security.acme.acceptTerms = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}
