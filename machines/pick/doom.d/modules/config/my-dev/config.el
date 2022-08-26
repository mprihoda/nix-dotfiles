;;; config/my-dev/config.el -*- lexical-binding: t; -*-

(setq projectile-project-search-path
      '("~/Devel/commercial/e-bs"
        "~/Devel/commercial/eidentity"
        "~/Devel/commercial/fiftyforms"
        "~/Devel/commercial/iw"
        "~/Devel/personal"))

(use-package! company-tabnine
  :after company
  :config
  (cl-pushnew 'company-tabnine (default-value 'company-backends)))

(after! company
  (set-company-backend! 'prog-mode 'company-tabnine 'company-capf 'company-yasnippet)
  ;;  (setq +lsp-company-backends '(company-capf company-yasnippet :separate company-tabnine))
  (setq company-idle-delay 0.5
        company-show-quick-access t))

(use-package! lsp-mode
  ;; Optional - enable lsp-mode automatically in scala files
  ;; mph: scala-mode's lsp is hooked in scala's config.el
  ;; TODO: investigate lsp-lens-mode
  :defer
  :hook
  (scala-mode . lsp)
  (lsp-mode . lsp-lens-mode)
  :config
  (setq lsp-prefer-flymake nil)
  (setq lsp-enable-file-watchers t
        lsp-file-watch-threshold 4000)
  (remove-hook 'lsp-completion-mode-hook '+lsp-init-company-backends-h)
  ;; (setq lsp-java-workspace-dir (expand-file-name lsp-java-workspace-dir))
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]out\\'"))

;;(use-package! lsp-ui
;;  :defer
;;  :config (setq lsp-ui-doc-enable t
;;                lsp-ui-sideline-show-hover t))

(use-package! lsp-metals
  :after lsp-mode
  :config (setq lsp-metals-treeview-show-when-views-received nil
                lsp-metals-show-implicit-arguments nil
                lsp-metals-show-inferred-type nil))

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

;;(add-to-list 'auto-mode-alist '("\\.sc\\'" . scala-mode))

;; Make SBT a popup
(set-popup-rule! "^\\*sbt" :select t :side 'right :width 80 :ttl nil)

(after! plantuml-mode
  (setq plantuml-default-exec-mode 'server
        plantuml-server-url "http://localhost:8080/"))

(after! forge
  (add-to-list 'forge-alist '("gitlab.e-bs.cz" "gitlab.e-bs.cz/api/v4" "gitlab.e-bs.cz" forge-gitlab-repository)))


;; Github Copilot
;; accept completion from copilot and fallback to company
(defun my-tab ()
  (interactive)
  (or (copilot-accept-completion)
      (company-indent-or-complete-common nil)))

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :config
  (map!
   (:when (modulep! :completion company))
   :mode prog-mode
   ;;"C-TAB" 'copilot-accept-completion-by-word
   ;;"C-<tab>" 'copilot-accept-completion-by-word
   :map company-active-map
   "<tab>" 'my-tab
   "TAB" 'my-tab
   :map company-mode-map
   "<tab>" 'my-tab
   "TAB" 'my-tab))
;; Github Copilot

;;SQL
(after! sql
  (sql-set-product-feature 'mysql :prompt-regexp "[mM]y[sS][qQ][lL]\\( \\[.*?]\\)?>")
  (load-file (expand-file-name "sql-connections.el.gpg" doom-private-dir)))
