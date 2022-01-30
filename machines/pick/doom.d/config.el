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

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory (expand-file-name "~/org/"))
(setq org-roam-directory (expand-file-name "roam" org-directory)
;;      org-roam-dailies-directory "journal/"
      org-roam-link-auto-replace t
      org-roam-completion-everywhere nil)
;;(setq org-journal-dir (expand-file-name "journal" org-roam-directory)
;;      org-journal-file-format "%Y-%m-%d.org"
;;      org-journal-file-header "#+title: %Y-%m-%d"
;;      org-journal-date-format "%d.%m.%Y")
(setq deft-directory org-roam-directory)

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
;; (use-package! company-tabnine)
;; taken from issue in Doom: https://github.com/hlissner/doom-emacs/issues/1268
(use-package! company-tabnine
  :after company
  :config
  (cl-pushnew 'company-tabnine (default-value 'company-backends)))

(after! company
  (set-company-backend! '(scala-mode) '(company-capf company-yasnippet :separate company-tabnine))
  (setq +lsp-company-backends '(company-capf company-yasnippet :separate company-tabnine))
  (setq company-idle-delay 0.5
        company-show-quick-access t))

(use-package! lsp-mode
  ;; Optional - enable lsp-mode automatically in scala files
  ;; mph: scala-mode's lsp is hooked in scala's config.el
  ;; TODO: investigate lsp-lens-mode
  :hook  (scala-mode . lsp)
  (lsp-mode . lsp-lens-mode)
  :config (setq lsp-prefer-flymake nil))

;;(use-package! lsp-ui
;;  :config (setq lsp-ui-doc-enable t
;;                lsp-ui-sideline-show-hover t))

(use-package! lsp-metals
  :config (setq lsp-metals-treeview-show-when-views-received nil
                lsp-metals-show-implicit-arguments nil
                lsp-metals-show-inferred-type nil))

;; Enable sbt mode for executing sbt commands
(use-package! sbt-mode
  :commands sbt-start sbt-command
  :config
                                        ; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
  ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
  (setq sbt:program-options '("-Dsbt.supershell=false" "-Dsbt.semanticdb=true")))

(setq lsp-enable-file-watchers t
      lsp-file-watch-threshold 4000)

(setq projectile-project-search-path
      '("~/Devel/commercial/e-bs"
        "~/Devel/commercial/eidentity"
        "~/Devel/commercial/fiftyforms"
        "~/Devel/commercial/iw"
        "~/Devel/personal"))

(after! plantuml-mode
  (setq plantuml-default-exec-mode 'server
        plantuml-server-url "http://localhost:8080/"))

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

;; Try to set this after notmuch loads, otherwise it stays nil
(after! notmuch
  (setq
   notmuch-fcc-dirs "fastmail/Sent +sent"))

(after! evil-escape
  (setq evil-escape-key-sequence "fd"))

(after! org-capture
  (setq org-capture-templates
        '(("t" "Personal todo" entry
           (file+headline +org-capture-todo-file "Inbox")
           "* TODO %?\n%i\n%a" :prepend t)
          ("n" "Personal notes" entry
           (file+headline +org-capture-notes-file "Inbox")
           "* %u %?\n%i\n%a" :prepend t)
          ("j" "Journal" entry
           (file+olp+datetree +org-capture-journal-file)
           "* %U %?\n%i\n%a" :prepend t)

          ;; Will use {project-root}/{todo,notes,changelog}.org, unless a
          ;; {todo,notes,changelog}.org file is found in a parent directory.
          ;; Uses the basename from `+org-capture-todo-file',
          ;; `+org-capture-changelog-file' and `+org-capture-notes-file'.
          ("p" "Templates for projects")
          ("pt" "Project-local todo" entry  ; {project-root}/todo.org
           (file+headline +org-capture-project-todo-file "Inbox")
           "* TODO %?\n%i\n%a" :prepend t)
          ("pn" "Project-local notes" entry  ; {project-root}/notes.org
           (file+headline +org-capture-project-notes-file "Inbox")
           "* %U %?\n%i\n%a" :prepend t)
          ("pc" "Project-local changelog" entry  ; {project-root}/changelog.org
           (file+headline +org-capture-project-changelog-file "Unreleased")
           "* %U %?\n%i\n%a" :prepend t)

          ;; Will use {org-directory}/{+org-capture-projects-file} and store
          ;; these under {ProjectName}/{Tasks,Notes,Changelog} headings. They
          ;; support `:parents' to specify what headings to put them under, e.g.
          ;; :parents ("Projects")
          ("o" "Centralized templates for projects")
          ("ot" "Project todo" entry
           (function +org-capture-central-project-todo-file)
           "* TODO %?\n %i\n %a"
           :heading "Tasks"
           :prepend nil)
          ("on" "Project notes" entry
           (function +org-capture-central-project-notes-file)
           "* %U %?\n %i\n %a"
           :heading "Notes"
           :prepend t)
          ("oc" "Project changelog" entry
           (function +org-capture-central-project-changelog-file)
           "* %U %?\n %i\n %a"
           :heading "Changelog"
           :prepend t))))

(after! org-roam
  (setq org-roam-capture-templates '(
                                     ("d" "default" plain #'org-roam-capture--get-point
                                      "%?"
                                      :file-name "%<%Y%m%d%H%M%S>-${slug}"
                                      :head "#+title: ${title}\n"
                                      :unnarrowed t)
                                     ("c" "call" entry #'org-roam--capture-get-point
                                      "* ${title}\n\n|Projekt|%?|\n|Účastníci||\n|Issue||\n|Datum||\n** Agenda\n*** Cíl schůzky\n** Poznámky a úkoly"
                                      :file-name "%<%Y%m%d%H%M%S>-${slug}"
                                      :head "#+title: ${title}\n"
                                      :unnarrowed t
                                      )
                                     ("i" "issue" entry #'org-roam--capture-get-point
                                      "* ${title}\n\n|Projekt||\n|Start||\n|Deadline||\n|Done||\n"
                                      :file-name "%<%Y%m%d%H%M%S>-${slug}"
                                      :head "#+title: ${title}\n"
                                      :unnarrowed t
                                      )
                                     )))

;; Metals
(after! lsp-metals
  (setq lsp-ui-sideline-diagnostic-max-lines 5)
  (defvar lsp-metals-map (make-sparse-keymap) "A map for metals keybindings")
  (map! :map lsp-metals-map
        :mode scala-mode
        :localleader
        :desc "Toggle inferred types" "t" #'lsp-metals-toggle-show-inferred-type
        :desc "Toggle implicit params" "p" #'lsp-metals-toggle-show-implicit-arguments
        :desc "Toggle implicit conversions" "c" #'lsp-metals-toggle-show-implicit-conversions
        :desc "Toggle show super" "s" #'lsp-metals-toggle-show-super-method-lenses
        :desc "Build" "l" #'(lambda () "Build using sbt" (interactive) (sbt-command (if (boundp 'my/sbt-build-command) my/sbt-build-command "compile")))
        :desc "SBT" "b" #'sbt-start)
  )

;; gnupg
(after! epa
  (setq epg-pinentry-mode nil)) ;; I don't want Emacs to handle the pinentry, remote agent does that.

;;SQL
(after! sql
  (sql-set-product-feature 'mysql :prompt-regexp "[mM]y[sS][qQ][lL]\\( \\[.*?]\\)?>")
  (load-file (expand-file-name "sql-connections.el.gpg" doom-private-dir)))

(after! lsp
  ;; The java workspace path is not expanded in +lsp.el, should fix
  (setq lsp-java-workspace-dir (expand-file-name lsp-java-workspace-dir)))

(after! tramp
      (add-to-list 'tramp-remote-path 'tramp-own-remote-path))
