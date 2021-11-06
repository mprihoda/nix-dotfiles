{ nix-doom-emacs, nixpkgs-master, ... }:
{ pkgs, config, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.mph = {
      home.packages =
        [ nixpkgs-master.legacyPackages."${pkgs.system}".scala-cli ];
      programs.fish.enable = true;
    };
  };
}
