{ config, lib, pkgs, ... }:

{
  sops.secrets."mph/mail/fastmail/imap" = { owner = "mph"; };
  sops.secrets."mph/mail/fastmail/smtp" = { owner = "mph"; };

  home-manager.users.mph = {
    programs.afew = {
      enable = true;
      extraConfig = ''
        [HeaderMatchingFilter.1]
        header = X-Spam-score
        pattern = ([5-9]\.\d|\d{2,}\.\d)
        tags = +spam

        [FolderNameFilter]
        folder_explicit_list = fastmail/Trash fastmail/Spam 'Read Later'
        folder_transforms = fastmail/Trash:deleted fastmail/Spam:spam 'Read Later':later

        [KillThreadsFilter]
        [ListMailsFilter]
        [ArchiveSentMailsFilter]
        [InboxFilter]

        [MailMover]
        folders = fastmail/INBOX
        fastmail/INBOX = 'tag:deleted':fastmail/Trash 'tag:spam':fastmail/Spam 'NOT tag:inbox':fastmail/Archive
      '';
    };

    programs.notmuch = {
      enable = true;
      new = { tags = [ "new" ]; };
    };

    programs.msmtp = { enable = true; };

    programs.offlineimap = { enable = true; };

    accounts.email.accounts = {
      fastmail = {
        address = "michal@prihoda.net";
        aliases = [
          "michal.prihoda@iterative.works"
          "michal.prihoda@iterativeworks.com"
          "mph@e-bs.cz"
          "mph@eidentity.cz"
          "mph@spinet.cz"
          "michal.prihoda@e-bs.cz"
          "michal.prihoda@eidentity.cz"
          "michal.prihoda@spinet.cz"
        ];
        imap.host = "imap.fastmail.com";
        smtp.host = "smtp.fastmail.com";
        msmtp = {
          enable = true;
          extraConfig = {
            from = "michal@prihoda.net";
            passwordeval = "cat /run/secrets/mph/mail/fastmail/smtp";
          };
        };
        notmuch.enable = true;

        offlineimap = let
          preSyncHookCommand = ''
            export NOTMUCH_CONFIG="${config.home-manager.users.mph.home.sessionVariables.NOTMUCH_CONFIG}"
            ${pkgs.afew}/bin/afew --move-mail
          '';
          preSyncHook = {
            presynchook =
              pkgs.writeShellScriptBin "presynchook" preSyncHookCommand
              + "/bin/presynchook";
          };
        in {
          enable = true;
          extraConfig.account = { utf8foldernames = "yes"; } // preSyncHook;
          extraConfig.remote = {
            remotepassfile = "/run/secrets/mph/mail/fastmail/imap";
          };
          postSyncHookCommand = ''
            export NOTMUCH_CONFIG="${config.home-manager.users.mph.home.sessionVariables.NOTMUCH_CONFIG}"
            ${pkgs.notmuch}/bin/notmuch new
            ${pkgs.afew}/bin/afew --tag --new
          '';
        };

        primary = true;
        realName = "Michal Příhoda";
        userName = "michal@prihoda.net";
      };
      login = {
        smtp.host = "login.cz";
        msmtp = {
          enable = true;
          extraConfig = {
            from = "mph@eidentity.cz";
            passwordeval = "cat /run/secrets/mph/mail/login/smtp";
          };
        };
        userName = "mph";
      };
    };

    accounts.email.maildirBasePath = "mail";
  };

  services.offlineimap.enable = true;
}
