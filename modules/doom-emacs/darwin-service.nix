{ daemonScript, config }:

{
  launchd.user.agents = {
    emacs = {
      path = [ config.environment.systemPath ];
      serviceConfig.ProgramArguments = [ (toString daemonScript) ];
      serviceConfig.RunAtLoad = true;
    };
  };
}
