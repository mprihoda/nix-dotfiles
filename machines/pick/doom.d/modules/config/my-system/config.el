;;; config/my-system/config.el -*- lexical-binding: t; -*-

(defun org-agenda-focus-active() "Focus on todos for active projects."
  (interactive)
  (setq org-agenda-files '("inbox.org" "todo.org" "projects_active.org" "tech_support.org")))

(defun org-agenda-focus-all() "Focus on todos for all projects."
  (interactive)
  (setq org-agenda-files '("inbox.org" "todo.org" "projects_active.org" "tech_support.org" "projects_backlog.org")))

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
        org-pomodoro-finished-hook '(my/stop-working)))
