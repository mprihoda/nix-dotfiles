{ daemonScript, ... }:

{
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
