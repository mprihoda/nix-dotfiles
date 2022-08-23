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
    (remove-hook 'lsp-completion-mode-hook '+lsp-init-company-backends-h)
    (setq gc-cons-threshold 100000000) ;; 100mb
    (setq read-process-output-max (* 1024 1024)) ;; 1mb
    (setq lsp-enable-file-watchers t
          lsp-file-watch-threshold 4000)
    ;; The java workspace path is not expanded in +lsp.el, should fix
    (setq lsp-java-workspace-dir (expand-file-name lsp-java-workspace-dir)))

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

; Fails with Text is read-only for some reason
;(after! plantuml-mode
;  (setq plantuml-default-exec-mode 'server
;        plantuml-server-url "http://pick.iterative.works:18888/plantuml"))

(after! plantuml-mode
  (setq plantuml-default-exec-mode 'jar
        plantuml-jar-args '("-charset" "UTF-8")
        plantuml-java-args '("-Djava.awt.headless=true" "-jar" "--illegal-access=deny" "-Dapple.awt.UIElement=true")))

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

(after! forge
  (add-to-list 'forge-alist '("gitlab.e-bs.cz" "gitlab.e-bs.cz/api/v4" "gitlab.e-bs.cz" forge-gitlab-repository)))

(use-package! ob-ammonite :after org)

(after! scala-mode
  (add-to-list 'auto-mode-alist '("\\.sc\\'" . scala-mode)))

;; Github Copilot
;; accept completion from copilot and fallback to company
(defun my-tab ()
  (interactive)
  (or (copilot-accept-completion)
      (company-indent-or-complete-common nil)))

;; (use-package! copilot
;;   :hook (scala-mode . copilot-mode)
;;   :bind (("C-TAB" . 'copilot-accept-completion-by-word)
;;          ("C-<tab>" . 'copilot-accept-completion-by-word)
;;          :map company-active-map
;;          ("<tab>" . 'my-tab)
;;          ("TAB" . 'my-tab)
;;          :map company-mode-map
;;          ("<tab>" . 'my-tab)
;;          ("TAB" . 'my-tab)))
;; Github Copilot
