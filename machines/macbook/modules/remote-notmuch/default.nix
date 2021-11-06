{ pkgs, ... }:

let

  remoteNotmuch = pkgs.writeScriptBin "remote-notmuch.sh" ''
    #!${pkgs.runtimeShell}
    printf -v ARGS "%q " "$@"
    exec ssh notmuch notmuch ''${ARGS}
  '';

in {

  home.packages = [ remoteNotmuch ];

}
