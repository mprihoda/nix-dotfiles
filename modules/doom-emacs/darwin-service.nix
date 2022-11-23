{ config, lib, pkgs, ... }:

let daemonScript = import ./daemon-script.nix {
  myemacs = config.home-manager.users.mph.programs.emacs.package;
  inherit config lib pkgs;
};
in {
  launchd.user.agents = {
    emacs = {
      path = [ config.environment.systemPath ];
      serviceConfig.ProgramArguments = [ (toString daemonScript) ];
      serviceConfig.RunAtLoad = true;
    };
  };
}
