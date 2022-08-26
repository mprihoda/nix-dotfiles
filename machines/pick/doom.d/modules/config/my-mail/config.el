;;; config/my-mail/config.el -*- lexical-binding: t; -*-

;; Try to set this after notmuch loads, otherwise it stays nil
(after! notmuch
  (setq
   notmuch-fcc-dirs "fastmail/Sent +sent"))
