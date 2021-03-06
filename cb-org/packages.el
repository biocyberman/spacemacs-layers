;;; packages.el --- cb-org Layer packages File for Spacemacs
;;; Commentary:
;;; Code:

(eval-when-compile
  (require 's)
  (require 'f)
  (require 'cb-use-package-extensions)
  (require 'use-package))

(defconst org-directory "~/org/")

(defconst org-agenda-directory (f-join (file-name-as-directory org-directory) "agenda")
  "Give agenda files a dedicated location undr org-directory")
(defconst cb-org-work-file (concat (file-name-as-directory org-agenda-directory) "work.org")
  "Defines the path to file for work-related todos, etc.")

(defconst cb-org-packages
  '(org
    gnuplot
    org-present
    (cb-org-latex-preview-retina :location local)
    (org-autoinsert :location local)
    (cb-org-clock-cascade :location local)
    (cb-org-export-koma-letter :location local)
    (cb-org-subtree :location local)
    (cb-org-pgp-decrpyt :location local)
    (cb-org-recalculate-whole-table :location local)
    (cb-org-capture-url :location local)
    (cb-org-gdrive :location local)
    (cb-org-goto :location local)
    (cb-org-work :location local)
    (cb-org-directory :location local)
    (cb-org-ctrl-c-ret :location local)
    (cb-org-ctrl-c-ctrl-k :location local)))


(defun cb-org/init-cb-org-directory ()
  (use-package cb-org-directory
    :config
    (setq org-directory (cb-org-directory))))

(defun cb-org/init-cb-org-work ()
  (use-package cb-org-work
    :after cb-org-directory))

(defun cb-org/post-init-org ()
  (use-package org
    :demand 5
    :after cb-org-directory
    :init
    (spacemacs/declare-prefix "o" "org")

    :leader-bind
    (("ob" . org-iswitchb)
     ("oc" . org-clock-goto)
     ("ok" . org-capture)
     ("ol" . org-store-link)
     ("oL" . org-insert-link)
     ("os" . org-search-view))

    :bind
    (:map org-mode-map
          ("C-c C-." . org-time-stamp-inactive)
          ("M-p" . org-metaup)
          ("M-n" . org-metadown)
          ("C-c c" . org-columns))

    :evil-bind
    (:map org-mode-map
          :state normal
          ("zm" . cb-org/fold-all)
          ("RET" . org-return))

    :config
    (progn
      (add-hook 'org-mode-hook #'auto-revert-mode)
      (add-hook 'org-mode-hook #'abbrev-mode)
      (setq my-org-todo-file "~/org/agenda/todo.org")
      (setq my-org-refile-file "~/org/agenda/refile.org")
      (setq my-org-habit-file (f-join org-agenda-directory "enjoy.org"))

      (setq org-default-notes-file (f-join org-agenda-directory "refile.org"))
      (setq org-M-RET-may-split-line nil)
      (setq org-attach-directory (f-join org-directory "data"))
      (setq org-catch-invisible-edits 'smart)
      (setq org-clock-persist-file (f-join org-directory ".org-clock-save"))
      (setq org-completion-use-ido t)
      (setq org-cycle-separator-lines 1)
      (setq org-enforce-todo-dependencies t)
      (setq org-footnote-auto-adjust t)
      (setq org-id-locations-file (f-join spacemacs-cache-directory "org-id-locations"))
      (setq org-indirect-buffer-display 'current-window)
      (setq org-insert-heading-respect-content t)
      (setq org-link-abbrev-alist '(("att" . org-attach-expand-link)))
      (setq org-log-done 'time)
      (setq org-log-into-drawer t)
      (setq org-hide-emphasis-markers t)
      (setq org-outline-path-complete-in-steps nil)
      (setq org-pretty-entities t)
      (setq org-refile-allow-creating-parent-nodes 'confirm)
      (setq org-refile-target-verify-function (lambda () (not (member (nth 2 (org-heading-components)) org-done-keywords))))
      (setq org-refile-targets '((nil :maxlevel . 5) (org-agenda-files :maxlevel . 5)))
      (setq org-refile-use-outline-path t)
      (setq org-return-follows-link t)
      (setq org-reverse-note-order nil)
      (setq org-confirm-elisp-link-function nil)
      (setq org-startup-indented t)
      (setq org-startup-with-inline-images t)

      ;; Match projects that do not have a scheduled action or NEXT action.
      (setq org-stuck-projects '("+project-ignore-maybe-done"
                                 ("NEXT") nil
                                 "SCHEDULED:"))

      (setq org-hierarchical-todo-statistics nil)
      (setq org-checkbox-hierarchical-statistics t)
      (setq org-log-repeat nil)

      ;; (setq org-todo-keywords '((type "MAYBE(m)" "TODO(t)" "NEXT(n)" "WAITING(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)")
      ;;                           (type "PROJECT(p)" "|")
      ;;                           (type "SOMEDAY(S)" "|")))

      ;; Faces


      (custom-set-faces
       '(org-hide ((t :background unspecified)))
       '(org-meta-line ((t :italic nil :inherit font-lock-comment-face)))
       '(org-document-info-keyword ((t :foreground unspecified :inherit org-meta-line)))

       `(org-block-begin-line
         ((((background light)) :italic t :foreground "cyan" :background nil)
          (((background dark))  :italic t :foreground "cyan" :background nil)))
       `(org-block-end-line
         ((((background light)) :italic t :foreground "cyan" :background nil)
          (((background dark))  :italic t :foreground "cyan" :background nil)))
       '(org-block
         ((((background light)) :background nil)
          (((background dark))  :background nil)))
       '(org-block-background
         ((((background light)) :background nil)
          (((background dark))  :background nil))))

      ;; (setq org-todo-keyword-faces
      ;;       `(("NEXT" . ,solarized-hl-orange)
      ;;         ("ORGANISE_IN" . ,solarized-hl-orange)
      ;;         ("ORGANISE_OUT" . ,solarized-hl-orange)
      ;;         ("TODO_OUT" . ,solarized-hl-orange)
      ;;         ("READY" . ,solarized-hl-blue)
      ;;         ("ON-HOL" . ,solarized-hl-magenta)
      ;;         ("OPEN" . font-lock-comment-face)
      ;;         ("WAITING" . ,solarized-hl-magenta)))

      ;; Config file name for diary
      ;; (setq diary-file "~/org/agenda/diary.org")

      (setq org-tag-alist '(
                            (:startgroup . nil)
                            ("@work" . ?w) ("@home" . ?h)
                            ("@break" . ?b)
                            (:endgroup . nil)
                            ("GAP" . ?g)
                            ("QUANTRONG" . ?t)
                            ("goals" . ?a)
                            ("HOME" . ?e)
                            ("WORK" . ?r)
                            )
            )
      (setq org-tag-faces
            (quote (("GAP" :foreground "red" :weight bold)
                    ("QUANTRONG" :foreground "blue" :weight bold)
                    ("HOME" :foreground "forest green" :weight bold)
                    ("WORK" :foreground "orange" :weight bold)
                    ("CHOI" :foreground "magenta" :weight bold)
                    ("CANCELLED" :foreground "forest green" :weight bold)
                    ("MEETING" :foreground "forest green" :weight bold)
                    ("PHONE" :foreground "forest green" :weight bold))))

      (setq org-todo-keywords
            (quote ((sequence "TODO(t)" "NEXT(n)" "SOMEDAY(s)" "|" "PROJECT(r)" "DONE(d)")
                    (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE(p)" "MEETING(m)"))))

      (setq org-todo-keyword-faces
            (quote (("TODO" :foreground "red" :weight bold)
                    ("NEXT" :foreground "light green" :weight bold)
                    ("SOMEDAY" :foreground "gold" :weight bold)
                    ("PROJECT" :foreground "purple" :weight bold)
                    ("DONE" :foreground "forest green" :weight bold)
                    ("WAITING" :foreground "orange" :weight bold)
                    ("HOLD" :foreground "magenta" :weight bold)
                    ("CANCELLED" :foreground "forest green" :weight bold)
                    ("MEETING" :foreground "forest green" :weight bold)
                    ("PHONE" :foreground "forest green" :weight bold))))


      ;; Override themes which set weird headline properties.

      (let ((class '((class color) (min-colors 89))))
        (custom-set-faces
         `(org-level-1 ((,class (:background nil :overline nil :height 1.0))))
         `(org-level-2 ((,class (:background nil :height 1.0))))
         `(org-level-3 ((,class (:background nil :height 1.0))))
         `(org-level-4 ((,class (:background nil :height 1.0))))
         `(org-level-5 ((,class (:background nil :height 1.0))))
         `(org-level-6 ((,class (:background nil :height 1.0))))
         `(org-level-7 ((,class (:background nil :height 1.0))))
         `(org-level-8 ((,class (:background nil :height 1.0))))


         `(org-agenda-done ((,class (:background nil :height 1.0))))
         `(org-scheduled-today ((,class (:background nil :height 1.0))))
         `(org-scheduled-previously ((,class (:background nil :height 1.0))))
         ))

      (defun cb-org/fold-all ()
        (interactive)
        (org-cycle '(16)))

      (add-hook 'org-mode-hook #'auto-revert-mode)
      (add-hook 'org-mode-hook #'abbrev-mode)

      (add-to-list 'org-refile-targets '(nil :maxlevel . 3))
      (add-to-list 'org-refile-targets '(org-default-notes-file :maxlevel . 3))
      (add-to-list 'org-refile-targets '(cb-org-work-file :maxlevel . 3))
      (add-to-list 'org-tags-exclude-from-inheritance "project")

      (setq org-M-RET-may-split-line nil)
      (setq org-attach-directory (f-join (cb-org-directory) "data"))
      (setq org-catch-invisible-edits 'smart)
      (setq org-clock-persist-file (f-join (cb-org-directory) ".org-clock-save"))
      (setq org-completion-use-ido t)
      (setq org-cycle-separator-lines 1)
      (setq org-enforce-todo-dependencies t)
      (setq org-footnote-auto-adjust t)
      (setq org-id-locations-file (f-join spacemacs-cache-directory "org-id-locations"))
      (setq org-indirect-buffer-display 'current-window)
      (setq org-insert-heading-respect-content t)
      (setq org-link-abbrev-alist '(("att" . org-attach-expand-link)))
      (setq org-log-done 'time)
      (setq org-log-into-drawer t)
      (setq org-hide-emphasis-markers t)
      (setq org-outline-path-complete-in-steps nil)
      (setq org-pretty-entities t)
      (setq org-refile-allow-creating-parent-nodes 'confirm)
      (setq org-refile-target-verify-function (lambda () (not (member (nth 2 (org-heading-components)) org-done-keywords))))

      (setq org-refile-use-outline-path t)
      (setq org-return-follows-link t)
      (setq org-reverse-note-order nil)
      (setq org-confirm-elisp-link-function nil)
      (setq org-startup-indented t)
      (setq org-startup-with-inline-images t)

      ;; Match projects that do not have a scheduled action or NEXT action.
      (setq org-stuck-projects '("+project-ignore-maybe-done"
                                 ("NEXT") nil
                                 "SCHEDULED:"))


      (setq org-hierarchical-todo-statistics nil)
      (setq org-checkbox-hierarchical-statistics t)
      (setq org-log-repeat nil)
      (setq org-blank-before-new-entry '((heading . always) (plain-list-item . nil)))

      (setq org-todo-keywords '((type "MAYBE(m)" "TODO(t)" "NEXT(n)" "WAITING(w!)" "|" "DONE(d!)" "CANCELLED(c!)")
                                (type "SOMEDAY(s)" "|")))

      ;; Faces

      (setq org-todo-keyword-faces
            `(("NEXT" . ,cb-vars-solarized-hl-yellow)
              ("WAITING" . ,cb-vars-solarized-hl-magenta)))

      (custom-set-faces
       '(org-hide ((t :background unspecified)))
       '(org-meta-line ((t :italic nil :inherit font-lock-comment-face)))
       '(org-document-info-keyword ((t :foreground unspecified :inherit org-meta-line)))

       `(org-block-begin-line
         ((((background light)) :italic t :foreground ,cb-vars-solarized-hl-cyan :background nil)
          (((background dark))  :italic t :foreground ,cb-vars-solarized-hl-cyan :background nil)))
       `(org-block-end-line
         ((((background light)) :italic t :foreground ,cb-vars-solarized-hl-cyan :background nil)
          (((background dark))  :italic t :foreground ,cb-vars-solarized-hl-cyan :background nil)))
       '(org-block
         ((((background light)) :background nil)
          (((background dark))  :background nil)))
       '(org-block-background
         ((((background light)) :background nil)
          (((background dark))  :background nil))))

      ;; Override themes which set weird headline properties.

      (let ((class '((class color) (min-colors 89))))
        (custom-set-faces
         `(org-level-1 ((,class (:background nil :overline nil :height 1.0))))
         `(org-level-2 ((,class (:background nil :height 1.0))))
         `(org-level-3 ((,class (:background nil :height 1.0))))
         `(org-level-4 ((,class (:background nil :height 1.0))))
         `(org-level-5 ((,class (:background nil :height 1.0))))
         `(org-level-6 ((,class (:background nil :height 1.0))))
         `(org-level-7 ((,class (:background nil :height 1.0))))
         `(org-level-8 ((,class (:background nil :height 1.0))))

         `(org-agenda-done ((,class (:background nil :height 1.0))))
         `(org-scheduled-today ((,class (:background nil :height 1.0))))
         `(org-scheduled-previously ((,class (:background nil :height 1.0))))))))

  ;; Exit minibuffer before adding notes.

  (defun cb-org/ad-exit-minibuffer (&rest _)
    (when (minibufferp (window-buffer (selected-window)))
      (other-window 1)))

  (advice-add 'org-add-log-note :before #'cb-org/ad-exit-minibuffer)

  ;; Prevent point from moving to BOL when toggling headings.

  (defun cb-org/ad-toggle-heading-goto-eol (&rest _)
    (when (s-matches? (rx bol (+ "*") (* space) eol)
                      (buffer-substring (line-beginning-position) (line-end-position)))
      (goto-char (line-end-position))))

  (advice-add 'org-toggle-heading :after #'cb-org/ad-toggle-heading-goto-eol)

  ;; Hooks

  (defun cb-org/tidy-org-buffer ()
    "Perform cosmetic fixes to the current org buffer."
    (interactive)
    (save-restriction
      (org-table-map-tables 'org-table-align 'quiet)
      ;; Realign tags.
      (org-set-tags 4 t)
      ;; Remove empty properties drawers.
      (save-excursion
        (goto-char (point-min))
        (while (search-forward-regexp ":PROPERTIES:" nil t)
          (save-excursion
            (org-remove-empty-drawer-at (match-beginning 0)))))))

  (defun cb-org/mark-next-parent-tasks-todo ()
    "Visit each parent task and change state to TODO."
    (let ((mystate (or (and (fboundp 'org-state)
                            state)
                       (nth 2 (org-heading-components)))))
      (when mystate
        (save-excursion
          (while (org-up-heading-safe)
            (when (-contains? '("NEXT" "WAITING" "MAYBE")
                              (nth 2 (org-heading-components)))
              (org-todo "TODO")))))))

  (defun cb-org/add-local-hooks ()
    "Set buffer-local hooks for orgmode."
    (add-hook 'org-after-todo-state-change-hook #'cb-org/mark-next-parent-tasks-todo nil t)
    (add-hook 'org-clock-in-hook #'cb-org/mark-next-parent-tasks-todo nil t))

  (add-hook 'org-mode-hook #'cb-org/add-local-hooks)


  (defun cb-org/set-next-todo-state ()
    "When marking a todo to DONE, set the next TODO as NEXT.
Do not scheduled items or repeating todos."
    (when (equal org-state "DONE")
      (save-excursion
        (when (and (ignore-errors (outline-forward-same-level 1) t)
                   (equal (org-get-todo-state) "TODO"))
          (unless (or (org-entry-get (point) "STYLE")
                      (org-entry-get (point) "LAST_REPEAT")
                      (org-get-scheduled-time (point)))
            (org-todo "NEXT"))))))

  (add-hook 'org-after-todo-state-change-hook #'cb-org/set-next-todo-state)


  (defun cb-org/children-done-parent-done (n-done n-todo)
    "Mark the parent task as done when all children are completed."
    (let (org-log-done org-log-states) ; turn off logging
      (org-todo (if (zerop n-todo) "DONE" "TODO"))))

  (add-hook 'org-after-todo-statistics-hook #'cb-org/children-done-parent-done)

  ;; LaTeX preview on C-c C-c

  (defun cb-org/latex-preview-fragment-at-pt ()
    (when (memq (org-element-type (org-element-context))
                '(latex-environment latex-fragment))
      (org-toggle-latex-fragment)
      t))

  (add-hook 'org-ctrl-c-ctrl-c-hook #'cb-org/latex-preview-fragment-at-pt t))

(use-package flyspell
  :defer t
  :config
  ;; HACK: Override clashing keybinding
  (define-key flyspell-mode-map (kbd "C-c $") nil))

(use-package auto-highlight-symbol
  :defer t
  :config
  (progn
    ;; Remove ahs keys that override org keybindings
    (define-key auto-highlight-symbol-mode-map (kbd "M-<left>") nil)
    (define-key auto-highlight-symbol-mode-map (kbd "M-<right>") nil)
    (define-key auto-highlight-symbol-mode-map (kbd "M-S-<left>") nil)
    (define-key auto-highlight-symbol-mode-map (kbd "M-S-<right>") nil)))


(use-package evil
  :config
  (progn
    ;; Enter evil insert state when creating new headings.

    (defun cb-org/ad-evil-insert-state (&rest _)
      (when (called-interactively-p nil)
        (evil-insert-state)))

    (advice-add 'org-insert-heading :after #'cb-org/ad-evil-insert-state)
    (advice-add 'org-insert-heading-respect-content :after #'cb-org/ad-evil-insert-state)
    (advice-add 'org-insert-todo-heading-respect-content :after #'cb-org/ad-evil-insert-state)
    (advice-add 'org-insert-todo-heading :after #'cb-org/ad-evil-insert-state)

    ;; Add a blank line of padding below new headings.

    (defun cb-org/ad-blank-line-after-heading (&rest _)
      (when (and (called-interactively-p nil)
                 (org-at-heading-p))
        (let ((next-line-blank?
               (save-excursion
                 (forward-line)
                 (s-blank? (buffer-substring (line-beginning-position) (line-end-position))))))
          (unless next-line-blank?
            (save-excursion
              (goto-char (line-end-position))
              (open-line 1))))))

    (advice-add 'org-insert-heading :after #'cb-org/ad-blank-line-after-heading)
    (advice-add 'org-insert-heading-respect-content :after #'cb-org/ad-blank-line-after-heading)
    (advice-add 'org-insert-todo-heading-respect-content :after #'cb-org/ad-blank-line-after-heading)
    (advice-add 'org-insert-todo-heading :after #'cb-org/ad-blank-line-after-heading)))

(defun cb-org/post-init-org-present ()
  (use-package org-present
    :after org
    :config
    (progn
      (setq org-present-text-scale 4)

      ;; Disable flyspell during presentations.
      (defvar-local cb-org/use-flyspell? nil)
      (defun cb-org/set-use-flyspell () (setq cb-org/use-flyspell? t))
      (defun cb-org/maybe-reenable-flyspell () (when cb-org/use-flyspell? (flyspell-mode +1)))

      (add-hook 'flyspell-mode-hook #'cb-org/set-use-flyspell)
      (add-hook 'org-present-mode-hook #'turn-off-flyspell)
      (add-hook 'org-present-mode-quit-hook #'cb-org/maybe-reenable-flyspell)

      (add-hook 'org-present-mode-hook #'spacemacs/toggle-mode-line-on)
      (add-hook 'org-present-mode-quit-hook #'spacemacs/toggle-mode-line-off))))

(defun cb-org/post-init-gnuplot ()
  (use-package gnuplot
    :after org
    :config
    (progn
      (setq gnuplot-image-format "png")
      (setq gnuplot-inline-image-mode 'dedicated)
      (add-hook 'gnuplot-mode-hook #'page-break-lines-mode)

      ;; Show the gnuplot buffer after rendering.

      (defun cb-org/ad-gnuplot-display-buffer (fn &rest _)
        (ignore-errors
          (funcall fn))
        (-when-let (buf (get-buffer gnuplot-image-buffer-name))
          (display-buffer buf)))

      (advice-add 'org-plot/gnuplot :around #'cb-org/ad-gnuplot-display-buffer))))

(defun cb-org/init-cb-org-latex-preview-retina ()
  (use-package cb-org-latex-preview-retina
    :after org))

(use-package org-agenda
  :after org
  :bind (:map org-agenda-mode-map ("J" . org-agenda-goto-date))
  :config
  (progn
    (define-key org-agenda-mode-map (kbd "C-f" ) #'evil-scroll-page-down)
    (define-key org-agenda-mode-map (kbd "C-b") #'evil-scroll-page-up)

    (defun cb-org/exclude-tasks-on-hold (tag)
      (and (equal tag "hold") (concat "-" tag)))

    (setq org-agenda-include-diary nil)
    (setq org-agenda-start-on-weekday nil)
    (setq org-agenda-auto-exclude-function #'cb-org/exclude-tasks-on-hold)
    (setq org-agenda-files (f-files (cb-org-directory) (lambda (f) (f-ext? f "org"))))
    (setq org-agenda-diary-file (f-join (cb-org-directory) "diary.org"))
    (setq org-agenda-hide-tags-regexp (rx (or "noexport" "someday" "project")))
    (setq org-agenda-insert-diary-extract-time t)
(setq org-agenda-span 'week)
(setq org-agenda-search-view-always-boolean t)
(setq org-agenda-show-all-dates nil)
(setq org-agenda-show-inherited-tags nil)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-deadline-prewarning-if-scheduled t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-sorting-strategy
      '((agenda time-up priority-down category-keep)
        (todo priority-down category-keep scheduled-up)
        (tags priority-down category-keep)
        (search category-keep)))
(setq org-agenda-text-search-extra-files '(agenda-archives))
(setq org-agenda-use-time-grid nil)
(setq org-agenda-inhibit-startup t)
(setq org-agenda-tags-column -100)

(setq org-agenda-clockreport-parameter-plist
      (list
       :compact t
       :maxlevel 5
       :fileskip0 t
       :step 'week))

(setq org-time-clocksum-format
      (list :hours "%d" :require-hours t
            :minutes ":%02d" :require-minutes t))

(setq appt-message-warning-time 60)
(setq appt-display-interval 5)

(add-hook 'org-finalize-agenda-hook #'org-agenda-to-appt)

(setq org-agenda-custom-commands
      ;; Useful reading: http://orgmode.org/manual/Matching-tags-and-properties.html
      '(("A" "Agenda and next actions"
         ((tags-todo "-study-someday-media/NEXT"
                     ((org-agenda-overriding-header "Next Actions")))
          (agenda "")
          (todo "WAITING"
                ((org-agenda-overriding-header "Waiting")))
          (stuck "")
          (tags-todo "media|study/NEXT"
                     ((org-agenda-overriding-header "MEDIA & Study"))))
         ((org-agenda-tag-filter-preset '("-ignore"))
          (org-agenda-files (list org-default-notes-file org-agenda-diary-file))
          (org-agenda-dim-blocked-tasks nil)
          (org-agenda-archives-mode nil)
          (org-agenda-ignore-drawer-properties '(effort appt))))

        ("n" "Next actions"
         ((tags-todo "-study-someday/NEXT"))
         ((org-agenda-overriding-header "Next Actions")))

        ("r" "Weekly Review"
         ((agenda ""
                  ((org-agenda-overriding-header "Review Previous Week")
                   (org-agenda-ndays 7)
                   (org-agenda-start-day "-7d")))
          (agenda ""
                  ((org-agenda-overriding-header "Review Upcoming Events")
                   (org-agenda-ndays 14)))
          (stuck ""
                 ((org-agenda-overriding-header "Review Stuck Projects")))
          (todo "WAITING"
                ((org-agenda-overriding-header "Review Tasks on Hold")))

          (tags-todo "-someday-media/NEXT"
                     ((org-agenda-overriding-header "Next Actions")))
          (tags-todo "+goals+3_months+project/NEXT"
                     ((org-agenda-overriding-header "Review 3 Month Goals")))
          (tags-todo "+goals+1_year+project/NEXT"
                     ((org-agenda-overriding-header "Review 1 Year Goals")))
          (tags-todo "+goals+3_years+project/MAYBE|SOMEDAY|NEXT"
                     ((org-agenda-overriding-header "Review 3 Year Goals")))
          (tags-todo "someday-skill/MAYBE|NEXT"
                     ((org-agenda-overriding-header "Decide whether to promote any SOMEDAY items to NEXT actions")))
          (tags-todo "someday&skill"
                     ((org-agenda-overriding-header "Decide whether to promote any learning tasks to NEXT actions"))))
         ((org-agenda-tag-filter-preset
           '("-drill" "-gtd" "-ignore"))
          (org-agenda-include-inactive-timestamps t)
          (org-agenda-files (list org-default-notes-file cb-org-work-file org-agenda-diary-file))
          (org-agenda-archives-mode nil)
          (org-agenda-dim-blocked-tasks nil)))

        ("w" "Work actions"
         ((tags-todo "-study-someday-media/NEXT"
                     ((org-agenda-overriding-header "Next Actions")))
          (todo "WAITING"
                ((org-agenda-overriding-header "Waiting")))
          (stuck "")
          (agenda "")
          (tags "+standup"
                ((org-agenda-overriding-header "Standup"))))
         ((org-agenda-tag-filter-preset '("-ignore"))
          (org-agenda-use-tag-inheritance nil)
          (org-agenda-files (list cb-org-work-file org-agenda-diary-file))
          (org-agenda-dim-blocked-tasks nil)
          (org-agenda-archives-mode nil)
          (org-agenda-ignore-drawer-properties '(effort appt))))))))

(use-package org-indent
  :after org
  :diminish org-indent-mode)

(use-package org-archive
  :after org
  :config
  (progn

    (defun cb-org/archive-done-tasks ()
      (interactive)
      (atomic-change-group
        (org-map-entries (lambda ()
                           ;; HACK: Ensure point does not move past the next
                           ;; item to archive.
                           (let ((org-map-continue-from (point)))
                             (org-archive-subtree)))
                         "/DONE|PAID|VOID|CANCELLED" 'tree)))

    (setq org-archive-default-command 'cb-org/archive-done-tasks)

    ;; Apply inherited tags when archiving.

    (defun cb-org/ad-apply-inherited-tags (&rest _)
      (org-set-tags-to (org-get-tags-at)))

    (advice-add 'org-archive-subtree :before #'cb-org/ad-apply-inherited-tags)))

(use-package org-src
  :after org
  :config
  (progn
    (setq org-src-fontify-natively t)

    ;; Remove trailing newline in src blocks.

    (defun cb-org/suppress-final-newline ()
      (setq-local require-final-newline nil))

    (add-hook 'org-src-mode-hook #'cb-org/suppress-final-newline)

    ;; Delete trailing whitespace when exiting src blocks.

    (defun cb-org/ad-org-src-delete-trailing-space (&rest _)
      (delete-trailing-whitespace))

    (advice-add 'org-edit-src-exit :before #'cb-org/ad-org-src-delete-trailing-space)))

(use-package org-clock
  :after org
  :config
  (progn
    (setq org-clock-persist t)
    (setq org-clock-persist-query-resume nil)
    (setq org-clock-history-length 20)
    (setq org-clock-in-resume t)
    (setq org-clock-report-include-clocking-task t)
    (setq org-clock-out-remove-zero-time-clocks t)

    (org-clock-persistence-insinuate)

    (defun cb-org/remove-empty-clock-drawers ()
      "Remove empty clock drawers at point."
      (save-excursion
        (beginning-of-line 0)
        (org-remove-empty-drawer-at (point))))

    (add-hook 'org-clock-out-hook #'cb-org/remove-empty-clock-drawers t)))

(use-package org-crypt
  :after org
  :config
  (progn
    (setq org-crypt-disable-auto-save 'encypt)
    (org-crypt-use-before-save-magic)
    (add-to-list 'org-tags-exclude-from-inheritance "crypt")))

(use-package org-drill
  :after (org cb-org-directory)
  :commands (org-drill
             org-drill-strip-all-data
             org-drill-cram
             org-drill-tree
             org-drill-resume
             org-drill-merge-buffers
             org-drill-entry
             org-drill-directory
             org-drill-again)
  :config
  (progn
    (defconst cb-org-drill-file (f-join (cb-org-directory) "drill" "drill.org"))

    (defun cb-org/org-drill-files ()
      (f-files (f-join (cb-org-directory) "drill")))

    (setq org-drill-scope (cb-org/org-drill-files))

    (add-to-list 'org-refile-targets '(cb-org/org-drill-files :maxlevel . 3))

    (setq org-drill-learn-fraction 0.25)
    (setq org-drill-adjust-intervals-for-early-and-late-repetitions-p t)
    (setq org-drill-add-random-noise-to-intervals-p t)
    (setq org-drill-save-buffers-after-drill-sessions-p nil)))

(use-package ox
  :after org
  :config
  (progn
    (setq org-export-backends '(ascii html latex gfm koma-letter odt))
    (setq org-export-exclude-tags '("noexport" "crypt"))
    (setq org-export-coding-system 'utf-8)
    (setq org-html-html5-fancy t)
    (setq org-html-postamble nil)
    (setq org-html-table-row-tags
          (cons
           '(cond
             (top-row-p "<tr class=\"tr-top\">")
             (bottom-row-p "<tr class=\"tr-bottom\">")
             (t
              (if
                  (=
                   (mod row-number 2)
                   1)
                  "<tr class=\"tr-odd\">" "<tr class=\"tr-even\">")))
           "</tr>"))
    (setq org-html-head-extra
          "
<style type=\"text/css\">
table tr.tr-odd td {
      background-color: #FCF6CF;
}
table tr.tr-even td {
      background-color: #FEFEF2;
}
</style>
")))

(use-package org-capture
  :after org
  :config
  (progn
    (defun cb-org/capture-template-entry (key label form template &rest kws)
      (-concat
       (list key label 'entry form template
             :clock-keep t
             :empty-lines 1
             :prepend t)
       kws))

    ;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
    ;; Useful reading http://orgmode.org/manual/Template-expansion.html#Template-expansion
    (setq org-capture-templates
          `(
            ("e" "respond" entry (file 'my-org-todo-file)
             "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n"
             :clock-in t
             :clock-resume t
             :immediate-finish t)

            ("t" "Todo" entry
             (file+olp org-default-notes-file "Tasks")
             "* TODO %?"
             :clock-in t
             :clock-resume t)

            ("T" "Todo (work)" entry
             (file+olp cb-org-work-file "Tasks")
             "* TODO %?"
             :clock-in t
             :clock-resume t)


            ("n" "Next Action" entry
             (file+olp org-default-notes-file "Tasks")
             "* NEXT %?"
             :clock-in t
             :clock-resume t)

            ("N" "Next Action (work)" entry
             (file+olp cb-org-work-file "Tasks")
             "* NEXT %?"
             :clock-in t
             :clock-resume t)


            ("d" "Diary" entry
             (file+datetree org-agenda-diary-file)
             "* %?\n%^t"
             :clock-in t
             :clock-resume t)

            ("D" "Diary (work)" entry
             (file+datetree cb-org-work-file)
             "* %?\n%^t"
             :clock-in t
             :clock-resume t)

            ("g" "Meeting" entry (file 'my-org-todo-file)
             "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)

            ("h" "Habit activities, leizure" entry (file 'my-org-habit-file)
             "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")

            ("l" "Link" entry
             (file+olp org-default-notes-file "Links")
             (function cb-org/read-url-for-capture)
             :immediate-finish t
             :clock-in t
             :clock-resume t)

            ("L" "Link (work)" entry
             (file+olp cb-org-work-file "Links")
             (function cb-org/read-url-for-capture)
             :immediate-finish t
             :clock-in t
             :clock-resume t)

            ("o" "note" entry
             (file+olp "~/org/agenda/refile.org" "Notes")
             "* %? :NOTE:\n%U\n%a\n"
             :clock-in t
             :clock-resume t)

            ("s" "Someday" entry
             (file+olp org-default-notes-file "Someday")
             "* SOMEDAY %?"
             :clock-in t
             :clock-resume t)

            ("m" "Listening" entry
             (file+olp org-default-notes-file "MEDIA" "Listening")
             "* MAYBE Listen to %i%?"
             :clock-in t
             :clock-resume t)

            ("p" "Phone call" entry
             (file 'my-org-todo-file "Phone")
             "* PHONE %? :PHONE:\n%U"
             :clock-in t
             :clock-resume t)

            ("v" "Viewing" entry
             (file+olp org-default-notes-file "MEDIA" "Viewing")
             "* MAYBE Watch %i%? :Viewing:\n%U"
             :clock-in t
             :clock-resume t)

            ("r" "Reading" entry
             (file+olp org-default-notes-file "MEDIA" "Reading")
             "* MAYBE Read %i%? :Reading:\n%U"
             :clock-in t
             :clock-resume t)

            ("w" "bionformatics" entry
             (file+olp "~/org/bioinformatics.org" "Notes")
             "* TODO Review %c\n%U\n"
             :clock-in t
             :clock-resume t)
            ))
    ))

(use-package org-download
  :after org
  :config
  (setq org-download-method 'attach))

(defun cb-org/init-org-autoinsert ()
  (use-package org-autoinsert
    :functions (org-autoinsert-init)
    :config (org-autoinsert-init)))

(defun cb-org/init-cb-org-clock-cascade ()
  (use-package cb-org-clock-cascade
    :after org
    :config
    (add-hook 'org-mode-hook #'cb-org-clock-cascade-init)))

(defun cb-org/init-cb-org-export-koma-letter ()
  (use-package cb-org-export-koma-letter
    :after org
    :config
    (add-hook 'org-mode-hook #'cb-org-export-koma-letter-init)))

(defun cb-org/init-cb-org-subtree ()
  (use-package cb-org-subtree
    :commands (cb-org-subtree-narrow-to-content
               cb-org-subtree-write-content
               cb-org-subtree-copy)))

(defun cb-org/init-cb-org-pgp-decrpyt ()
  (use-package cb-org-pgp-decrpyt
    :after org
    :config
    (add-hook 'org-mode-hook #'cb-org-pgp-decrpyt-init)))

(defun cb-org/init-cb-org-recalculate-whole-table ()
  (use-package cb-org-recalculate-whole-table
    :after org
    :config
    (add-hook 'org-mode-hook #'cb-org-recalculate-whole-table-init)))

(defun cb-org/init-cb-org-capture-url ()
  (use-package cb-org-capture-url
    :after org))

(defun cb-org/init-cb-org-gdrive ()
  (use-package cb-org-gdrive
    :after org
    :config
    (add-hook 'org-mode-hook #'cb-org-gdrive-init)))

(defun cb-org/init-cb-org-goto ()
  (use-package cb-org-goto
    :after org
    :leader-bind
    (("oa" . cb-org-goto-agenda)
     ("od" . cb-org-goto-diary)
     ("on" . cb-org-goto-notes)
     ("ow" . cb-org-goto-work)
     ("ot" . cb-org-goto-todo-list)
     ("ov" . cb-org-goto-tags-list))))

(defun cb-org/init-cb-org-ctrl-c-ret ()
  (use-package cb-org-ctrl-c-ret
    :after org
    :bind (:map org-mode-map ("C-c RET" . cb-org-ctrl-c-ret))))

(defun cb-org/init-cb-org-ctrl-c-ctrl-k ()
  (use-package cb-org-ctrl-c-ctrl-k
    :after org
    :bind (:map org-mode-map ("C-c C-k" . cb-org-ctrl-c-ctrl-k))))

;;; packages.el ends here
