self: super: {
  python3 = super.python3.override {
    packageOverrides = pySelf: pySuper: {
      ipython = pySuper.ipython.overridePythonAttrs (old: {
        disabledTests = super.lib.optionals super.stdenv.isDarwin [
          "test_clipboard_get" # uses pbpaste
        ];
      });
    };
  };
}
