{ config, lib, pkgs, ... }:

let daemonScript = import ./daemon-script.nix { inherit config lib pkgs; };
in {
  systemd = {
    user.services.emacs-daemon = {
      Install.WantedBy = [ "default.target" ];
      Service = {
        Type = "forking";
        TimeoutStartSec = "10min";
        Restart = "always";
        ExecStart = toString daemonScript;
      };
    };
  };
}
