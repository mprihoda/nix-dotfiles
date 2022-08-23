;;; config/my-mail/config.el -*- lexical-binding: t; -*-

;; Notmuch
(setq message-directory (expand-file-name "~/mail")
      mail-envelope-from 'header
      mail-specify-envelope-from t)
(setq +notmuch-sync-backend 'custom
      +notmuch-sync-command "offlineimap -c /etc/offlineimaprc"
      ;; Disable notmuch crypto, hangs now (used to work though)
      notmuch-crypto-process-mime nil)
;; Try to set this after notmuch loads, otherwise it stays nil
(after! notmuch
  (setq notmuch-fcc-dirs "fastmail/Sent +sent"
        notmuch-command (expand-file-name "~/.nix-profile/bin/remote-notmuch.sh")))
