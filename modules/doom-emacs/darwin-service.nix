{ config, lib, pkgs, ... }:

let daemonScript = import ./daemon-script.nix { inherit config lib pkgs; };
in {
  launchd.user.agents = {
    emacs = {
      path = [ config.environment.systemPath ];
      serviceConfig.ProgramArguments = [ (toString daemonScript) ];
      serviceConfig.RunAtLoad = true;
    };
  };
}
