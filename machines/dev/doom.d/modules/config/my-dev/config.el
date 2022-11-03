;;; config/my-dev/config.el -*- lexical-binding: t; -*-

(setq projectile-project-search-path '("/workspace"))

(use-package! company-tabnine
  :after company
  :config
  (cl-pushnew 'company-tabnine (default-value 'company-backends)))

(after! company
  (set-company-backend! 'prog-mode 'company-tabnine 'company-capf 'company-yasnippet)
  ;; Do not start the company mode automatically, it clashes a bit with copilot
  (setq company-idle-delay nil
        company-show-quick-access t))

(use-package! lsp-mode
  ;; Optional - enable lsp-mode automatically in scala files
  ;; mph: scala-mode's lsp is hooked in scala's config.el
  :defer
  :hook
  (scala-mode . lsp)
  (lsp-mode . lsp-lens-mode)
  :config
  (setq lsp-prefer-flymake nil)
  (setq lsp-enable-file-watchers t
        lsp-file-watch-threshold 4000)
  (remove-hook 'lsp-completion-mode-hook '+lsp-init-company-backends-h)
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]out\\'"))

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

;; Do not use company mode in sbt buffers
(add-to-list 'company-global-modes 'sbt-mode t)

(add-to-list 'auto-mode-alist '("\\.sc\\'" . scala-mode))
(add-to-list 'auto-mode-alist '("\\.Dockerfile\\'" . dockerfile-mode))

;; Make SBT a popup
(set-popup-rule! "^\\*sbt" :select t :side 'right :width 80 :ttl nil)

(after! forge
  (add-to-list 'forge-alist '("gitlab.e-bs.cz" "gitlab.e-bs.cz/api/v4" "gitlab.e-bs.cz" forge-gitlab-repository)))

;; Github Copilot
;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :config
  (map!
   :mode prog-mode
   "M-]" 'copilot-accept-completion-by-word
   "M-n" 'copilot-next-completion
   "M-RET" 'copilot-accept-completion
   ))
;; Github Copilot

;;SQL
(after! sql
  (sql-set-product-feature 'mysql :prompt-regexp "[mM]y[sS][qQ][lL]\\( \\[.*?]\\)?>")
  (load-file (expand-file-name "sql-connections.el.gpg" doom-private-dir)))
