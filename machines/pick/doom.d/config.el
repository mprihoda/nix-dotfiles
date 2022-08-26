;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Michal Příhoda"
      user-mail-address "michal@prihoda.net")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 13)
      doom-unicode-font (font-spec :family "Symbola"))
;;(setq doom-font (font-spec :family "Iosevka" :size 14)
;;      doom-variable-pitch-font (font-spec :family "Iosevka Aile" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-gruvbox-dark-variant "medium")
;;(setq doom-theme 'doom-gruvbox)
(setq doom-theme 'doom-gruvbox-light)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

(setq default-input-method "czech")

(setq enable-local-variables t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;; taken from issue in Doom: https://github.com/hlissner/doom-emacs/issues/1268

;; Call manually in emacs daemon, so that it does not get overriden each time in new emacs
;;(use-package! pinentry
;;  :config (pinentry-start))

;; Set the frame title format to something more useful
(setq frame-title-format
      '(""
        "%b"
        (:eval
         (let ((project-name (projectile-project-name)))
           (unless (string= "-" project-name)
             (format (if (buffer-modified-p)  " ◉  %s" " ●  %s") project-name))))))

;; Display the window title in the terminal
;;(setq my-init-terminal-title '(when (and
;;       (not window-system)
;;       (or
;;        (string= (getenv "TERM") "dumb")
;;        (string-match "^xterm" (getenv "TERM"))))
;;  (require 'xterm-title)
;;      (xterm-title-mode 1)))
;;(add-hook! 'server-after-make-frame-hook 'my-init-terminal-title)

(after! evil-escape
  (setq evil-escape-key-sequence "fd"))

;; gnupg
(after! epa
  (setq epg-pinentry-mode nil)) ;; I don't want Emacs to handle the pinentry, remote agent does that.

;; TODO: remove after update to check if it still causes problems with lsp xref
;; It reports errors (invalid handler) when visiting files in .jar directories
;; I could just remove the .jar from the pattern, but I don't think I'm going to miss it anytime soon
;; TODO: just filter out, instead of setting
(after! tramp
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  (setq tramp-archive-suffixes
      '("7z" "apk" "ar" "cab" "CAB" "cpio" "deb" "depot" "exe" "iso" "lzh" "LZH" "msu" "MSU" "mtree" "odb" "odf" "odg" "odp" "ods" "odt" "pax" "rar" "rpm" "shar" "tar" "tbz" "tgz" "tlz" "txz" "tzst" "warc" "xar" "xpi" "xps" "zip" "ZIP")))
