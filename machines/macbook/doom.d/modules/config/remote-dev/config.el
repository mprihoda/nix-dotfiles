;;; config/remote-dev/config.el -*- lexical-binding: t; -*-

;; Attempts at remote development using emacs over TRAMP

(defun lsp-tramp-connection-over-ssh-port-forwarding (command)
  "Like lsp-tcp-connection, but uses SSH portforwarding."
  (list
   :connect (lambda (filter sentinel name environment-fn)
              (let* ((host "localhost")
                     (lsp-port (lsp--find-available-port host (cl-incf lsp--tcp-port)))
                     (command (with-parsed-tramp-file-name buffer-file-name nil
                                (message "[tcp/ssh hack] running LSP %s on %s / %s" command host localname)
                                (let* ((unix-socket (format "/tmp/lsp-ssh-portforward-%s.sock" lsp-port))
                                       (command (list
                                                 "ssh"
                                                 ;; "-vvv"
                                                 "-L" (format "%s:%s" lsp-port unix-socket)
                                                 host
                                                 "socat"
                                                 (format "unix-listen:%s" unix-socket)
                                                 (format "system:'\"cd %s && %s\"'" (file-name-directory localname) command)
                                                 )))
                                  (message "using local command %s" command)
                                  command)))
                     (final-command (if (consp command) command (list command)))
                     (_ (unless (executable-find (cl-first final-command))
                          (user-error (format "Couldn't find executable %s" (cl-first final-command)))))
                     (process-environment
                      (lsp--compute-process-environment environment-fn))
                     (proc (make-process :name name :connection-type 'pipe :coding 'no-conversion
                                         :command final-command :sentinel sentinel :stderr (format "*%s::stderr*" name) :noquery t))
                     (tcp-proc (progn
                                 (sleep-for 1) ; prevent a connection before SSH has run socat. Ugh.
                                 (lsp--open-network-stream host lsp-port (concat name "::tcp")))))

                ;; TODO: Same :noquery issue (see above)
                (set-process-query-on-exit-flag proc nil)
                (set-process-query-on-exit-flag tcp-proc nil)
                (set-process-filter tcp-proc filter)
                (cons tcp-proc proc)))
   :test? (lambda () t)))

(defun my/lsp-tramp-connection (local-command &optional generate-error-file-fn)
  "Create LSP stdio connection named name.
LOCAL-COMMAND is either list of strings, string or function which
returns the command to execute."
  ;; 2.5.0-pre (as built from native-comp branch before M Albinus released tramp-2.5)
  ;; worked fine
  (defvar tramp-version)
  (defvar tramp-connection-properties)
  (when (version< tramp-version "2.5.0-pre")
    (lsp-warn
     "Your tramp version - %s - might fail to work with remote LSP. Update to version 2.5 or greater (available on elpa)"
     tramp-version))
  ;; Force a direct asynchronous process.
  (add-to-list 'tramp-connection-properties
               (list (regexp-quote (file-remote-p default-directory))
                     "direct-async-process" t))
  (list :connect (lambda (filter sentinel name environment-fn)
                   (let* ((final-command (lsp-resolve-final-function
                                          local-command))
                          (process-name (generate-new-buffer-name name))
                          (process-environment
                           (lsp--compute-process-environment environment-fn))
                          (proc (make-process
                                 :name process-name
                                 :buffer (format "*%s*" process-name)
                                 :command final-command
                                 :connection-type 'pipe
                                 :coding 'no-conversion
                                 :noquery t
                                 :filter filter
                                 :sentinel sentinel
                                 :stderr (get-buffer-create (format "*%s::stderr*" process-name))
                                 :file-handler t)))
                     (cons proc proc)))
        :test? (lambda () (-> local-command lsp-resolve-final-function
                              lsp-server-present?))))

(after! lsp-mode
  ;;(lsp-register-client (make-lsp-client :new-connection (lsp-tramp-connection-over-ssh-port-forwarding "metals-emacs")
  ;;(lsp-register-client (make-lsp-client :new-connection (my/lsp-tramp-connection "metals-emacs")
  (lsp-register-client (make-lsp-client :new-connection (lsp-tramp-connection "metals-emacs")
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
                                        :remote? t)))
