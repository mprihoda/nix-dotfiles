{ ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.mph = { programs.fish.enable = true; };
  };
}
