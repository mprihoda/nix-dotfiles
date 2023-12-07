;;; config/my-system/config.el -*- lexical-binding: t; -*-
;;;
(defun org-agenda-focus-active() "Focus on todos for active projects."
       (interactive)
       (setq org-agenda-files '("inbox.org" "todo.org" "projects_active.org" "tech_support.org")))

(defun org-agenda-focus-all() "Focus on todos for all projects."
       (interactive)
       (setq org-agenda-files '("inbox.org" "todo.org" "projects_active.org" "tech_support.org" "projects_backlog.org")))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory (expand-file-name "~/org/")
      ;; org-agenda-files '("inbox.org" "todo.org" "projects_active.org" "tech_support.org")
      org-agenda-files '("todo.org")
      org-roam-directory (expand-file-name "roam" org-directory)
      org-roam-dailies-directory "daily/"
      org-roam-v2-ack t)
(setq deft-directory org-roam-directory)
(setq org-logseq-dir (expand-file-name "~/notes/"))

(defun my/org-roam-visit-index ()
  (interactive)
  (let* ((index-name "Home")
         (index-node (org-roam-node-from-title-or-alias index-name)))
    (org-roam-node-visit index-node)))

(after! org
  (add-to-list 'org-latex-packages-alist
               '("AUTO" "babel" t ("pdflatex")))
  (map! (:map org-mode-map
         :leader
         :prefix "n"
         (:prefix "r"
          :desc "Open index" "RET" #'my/org-roam-visit-index)))
  (setq org-capture-templates
        '(("t" "Personal todo" entry
           (file "inbox.org")
           "* TODO %?\n%i\n%a" :prepend t)
          )))
(defun my/org-roam-daily-template  () "Template for dailies"
       "#+title: %<%Y-%m-%d>
* Tasks
** Must
** Should
** Could
** Other
*** Planning
*** Mail, phone, meetings
*** Workout
*** Support
*** Review
*** Tools
* Journal
* Notes")

(after! org-roam
  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry "* %?" :target
           (file+head "%<%Y-%m-%d>.org" my/org-roam-daily-template))
          ("j" "journal" entry "* %<%H:%M> %?" :target
           (file+head+olp "%<%Y-%m-%d>.org" my/org-roam-daily-template ("Journal")))
          ("t" "todo" entry "* [ ] %?\n%a" :target
           (file+olp "%<%Y-%m-%d>.org" ("Tasks" "Must"))))))

;; Automatically manage focus mode in pomodoro
;; Needs to have 2 shortcuts in the Shortcuts app that will start and stop the focus mode
(defun my/run-shortcut (name)
  (start-process "shortcuts" nil "shortcuts" "run" name))

(defun my/start-working ()
  (my/run-shortcut "Start working"))

(defun my/stop-working ()
  (my/run-shortcut "Stop working"))

(after! org-pomodoro
  (setq org-pomodoro-manual-break 't ; I like to keep running a little longer, if needed
        org-pomodoro-started-hook '(my/start-working)
        org-pomodoro-killed-hook '(my/stop-working)
        org-pomodoro-finished-hook '(my/stop-working)
                                        ; Let's do 45 minutes of focus
        org-pomodoro-length 45
                                        ; and 15 minutes of break
        org-pomodoro-short-break-length 15
        org-pomodoro-long-break-length 30))

;;(use-package! websocket
;;    :after org-roam)

;;(use-package! org-roam-ui
;;    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
;;    :config
;;    (setq org-roam-ui-sync-theme t
;;          org-roam-ui-follow t
;;          org-roam-ui-update-on-save t
;;          org-roam-ui-open-on-start t))

;;(when (modulep! :ui doom-dashboard)
;;  (add-to-list '+doom-dashboard-menu-sections
;;               '("Open org-roam"
;;                 :icon (all-the-icons-octicon "mortar-board" :face 'doom-dashboard-menu-title)
;;                 :action my/org-roam-visit-index)))

;;(use-package! obsidian
;;  :ensure t
;;  :demand t
;;  :config
;;  (obsidian-specify-path "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/main")
;;  (global-obsidian-mode t))

;;(defun my-org-open-obsidian (path)
;;  "Open Obsidian link using obsidian-find-file"
;;  (-> path
;;      obsidian-prepare-file-path
;;      obsidian-wiki->normal
;;      (obsidian-tap #'message)
;;      (obsidian-find-file path)))

;;(defun org-obsidian-insert-wikilink (&optional arg)
;;  "Insert a link to file in wikiling format."
;;  (interactive "P")
;;  (let* ((file (obsidian--request-link arg))
;;         (filename (plist-get file :file))
;;         (description (plist-get file :description))
;;         (no-ext (file-name-sans-extension filename))
;;         (link (if (and description (not (s-ends-with-p description no-ext)))
;;                   (s-concat "[[obsidian:" no-ext "][" description"]]")
;;                 (s-concat "[[obsidian:" no-ext "][" no-ext "]]"))))
;;    (insert link)))

;;(after! org
;;  (org-link-set-parameters "obsidian"
;;                           :follow #'my-org-open-obsidian
;;                           :export #'org-org-link-export))
