;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Michal Příhoda"
      user-mail-address "michal@prihoda.net")

(setq default-input-method "czech")

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
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "Iosevka" :size 14)
      doom-variable-pitch-font (font-spec :family "Iosevka Aile" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-gruvbox-light-variant "medium")
(setq doom-theme 'doom-gruvbox-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory (expand-file-name "~/org/"))
(setq org-roam-directory (expand-file-name "roam" org-directory)
      org-roam-dailies-directory "daily/"
      org-roam-v2-ack t)
;;(setq org-journal-dir (expand-file-name "journal" org-roam-directory)
;;      org-journal-file-format "%Y-%m-%d.org"
;;      org-journal-file-header "#+title: %Y-%m-%d"
;;      org-journal-date-format "%d.%m.%Y"
(setq deft-directory org-roam-directory)
(setq org-logseq-dir (expand-file-name "~/notes/"))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


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
(use-package! company-tabnine
  :after company
  :config
  (cl-adjoin 'company-tabnine (default-value 'company-backends)))

(after! company
  (setq +lsp-company-backends '(company-tabnine :separate company-capf company-yasnippet)
        company-idle-delay 0.5
        company-show-quick-access t))

;;(use-package! lsp-mode
  ;; Optional - enable lsp-mode automatically in scala files
  ;; mph: scala-mode's lsp is hooked in scala's config.el
  ;; TODO: investigate lsp-lens-mode
  ;;  :hook  (scala-mode . lsp)
  ;;         (lsp-mode . lsp-lens-mode)
;;  :config (setq lsp-prefer-flymake nil))
;;(use-package! eglot
;;  :hook (scala-mode . eglot-ensure))
;;(use-package! lsp-metals
;;  :defer t
;;  :config (setq lsp-metals-treeview-show-when-views-received nil))

;; Enable sbt mode for executing sbt commands
(use-package! sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
  ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
  (setq sbt:program-options '("-Dsbt.supershell=false" "-Dsbt.semanticdb=true")))

(defun my/org-roam-visit-index ()
  (interactive)
  (let* ((index-name "000 Index")
         (index-node (org-roam-node-from-title-or-alias index-name)))
    (org-roam-node-visit index-node)))

(after! org
  (add-to-list 'org-latex-packages-alist
                         '("AUTO" "babel" t ("pdflatex")))
  (map! (:map org-mode-map
         :leader
         :prefix "n"
         (:prefix "r"
          :desc "Open index" "RET" #'my/org-roam-visit-index))))

(after! tramp
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

(use-package! lsp-mode
  :defer t
  :config
  (lsp-register-client (make-lsp-client :new-connection (lsp-tramp-connection "metals")
                                        :major-modes '(scala-mode)
                                        :priority -1
                                        :initialization-options '((decorationProvider . t)
                                                                  (inlineDecorationProvider . t)
                                                                  (didFocusProvider . t)
                                                                  (executeClientCommandProvider . t)
                                                                  (doctorProvider . "html")
                                                                  (statusBarProvider . "on")
                                                                  (debuggingProvider . t)
                                                                  (treeViewProvider . t))
                                        :notification-handlers (ht ("metals/executeClientCommand" #'lsp-metals--execute-client-command)
                                                                   ("metals/publishDecorations" #'lsp-metals--publish-decorations)
                                                                   ("metals/treeViewDidChange" #'lsp-metals-treeview--did-change)
                                                                   ("metals-model-refresh" #'lsp-metals--model-refresh)
                                                                   ("metals/status" #'lsp-metals--status-string))
                                        :action-handlers (ht ("metals-debug-session-start" (-partial #'lsp-metals--debug-start :json-false))
                                                             ("metals-run-session-start" (-partial #'lsp-metals--debug-start t)))
                                        :server-id 'metals-remote
                                        :initialized-fn (lambda (workspace)
                                                          (lsp-metals--add-focus-hooks)
                                                          (with-lsp-workspace workspace
                                                            (lsp--set-configuration
                                                             (lsp-configuration-section "metals"))))
                                        :after-open-fn (lambda ()
                                                         (add-hook 'lsp-on-idle-hook #'lsp-metals--did-focus nil t))
                                        :completion-in-comments? t
                                        :remote? t))
  (setq lsp-enable-file-watchers t
        lsp-file-watch-threshold 4000))

(setq projectile-project-search-path
      '("~/Devel/commercial/e-bs"
        "~/Devel/commercial/eidentity"
        "~/Devel/commercial/fiftyforms"
        "~/Devel/commercial/iw"
        "~/Devel/personal"))

;; Notmuch
(setq message-directory (expand-file-name "~/mail")
      sendmail-program "/run/current-system/sw/bin/sendmail"
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

; Fails with Text is read-only for some reason
;(after! plantuml-mode
;  (setq plantuml-default-exec-mode 'server
;        plantuml-server-url "http://pick.iterative.works:18888/plantuml"))

(after! plantuml-mode
  (setq plantuml-default-exec-mode 'jar
        plantuml-jar-args '("-charset" "UTF-8")
        plantuml-java-args '("-Djava.awt.headless=true" "-jar" "--illegal-access=deny" "-Dapple.awt.UIElement=true")))

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

(after! lsp
  ;; The java workspace path is not expanded in +lsp.el, should fix
  (setq lsp-java-workspace-dir (expand-file-name lsp-java-workspace-dir)))

(use-package! ob-ammonite :after org)
