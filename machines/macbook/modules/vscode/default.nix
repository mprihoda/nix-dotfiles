{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions;
      [
        bbenoist.nix
        brettm12345.nixfmt-vscode
        ms-vscode-remote.remote-ssh
        vscodevim.vim
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "gruvbox-material";
          publisher = "sainnhe";
          version = "6.4.6";
          sha256 =
            "ae6fd2e12019ff3f12bddd3067269839953171448c981134c5493ed7a76bad9f";
        }
        {
          name = "intellij-idea-keybindings";
          publisher = "k--kato";
          version = "1.5.0";
          sha256 =
            "bbcc210d79bc58c622f72262aecb255953170cde4b35fbe5172328ab3eb02ad6";
        }
      ];
    keybindings = [
      {
        key = "cmd+k";
        command = "-git.commitAll";
        when = "!inDebugMode && !terminalFocus";
      }
      {
        key = "cmd+t";
        command = "-git.sync";
      }
      {
        key = "ctrl+r";
        command = "-workbench.action.tasks.reRunTask";
      }
      {
        key = "shift shift";
        command = "-workbench.action.showCommands";
      }
      {
        key = "shift shift";
        command = "-workbench.action.quickOpen";
      }
      {
        key = "ctrl+[IntlBackslash]";
        command = "workbench.action.switchWindow";
      }
      {
        key = "ctrl+w";
        command = "-workbench.action.switchWindow";
      }
    ];
    userSettings = {
      "update.mode" = "none";
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      "remote.SSH.remotePlatform" = { "pick" = "linux"; };
      "files.watcherExclude" = {
        "**/.bloop" = true;
        "**/.metals" = true;
        "**/.ammonite" = true;
      };
      "vim.easymotion" = true;
      "metals.showInferredType" = true;
      "metals.superMethodLensesEnabled" = true;
      "metals.showImplicitConversionsAndClasses" = true;
      "metals.showImplicitArguments" = true;
      "editor.lineNumbers" = "relative";
      "tabnine.experimentalAutoImports" = true;
      "gitlens.currentLine.enabled" = false;
      "gitlens.hovers.currentLine.over" = "line";
      "gitlens.codeLens.enabled" = false;
      "diffEditor.renderSideBySide" = true;
      "gitlens.hovers.enabled" = false;
      "editor.fontFamily" = "Iosevka, Menlo, Monaco, 'Courier New', monospace";
      "editor.fontSize" = 14;
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.formatOnType" = true;
      "editor.formatOnPaste" = true;
      "editor.quickSuggestions" = {
        "other" = true;
        "comments" = false;
        "strings" = false;
      };
      "workbench.colorTheme" = "Gruvbox Material Light";
      "editor.multiCursorModifier" = "alt";
      "editor.suggestSelection" = "first";
      "vsintellicode.modify.editor.suggestSelection" =
        "automaticallyOverrodeDefaultValue";
      "files.exclude" = {
        "**/.classpath" = true;
        "**/.project" = true;
        "**/.settings" = true;
        "**/.factorypath" = true;
      };
      "docker.containers.label" = "Compose Project Name";
    };
  };
}
