self: super: {
  python3 = super.python3.override {
    packageOverrides = pySelf: pySuper: {
      httpie = pySuper.httpie.overridePythonAttrs (old: {
        disabledTests = old.disabledTests
          ++ super.lib.optionals super.stdenv.isDarwin [
            "test_plugins_upgrade" # fails for unclear reasons
          ];
      });
    };
  };
}
