;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; === Personal Date ===

(setq user-full-name "Jolyon Patten"
      user-mail-address "jolyonpatten@gmail.com")

(setq calendar-latitude 51.521646)
(setq calendar-longitude -0.132776)
(setq calendar-location-name "Home")


;; === Fonts ===
;; 13 July 2021: https://zzamboni.org/post/my-doom-emacs-configuration-with-commentary/
;; Set base and variable-pitch fonts.
;; I currently like Fira Code and Alegreya (another favorite and my previous choice: ET Book).

(setq doom-font (font-spec :family "Fira Code" :size 12)
;;      doom-variable-pitch-font (font-spec :family "ETBembo" :size 12)
      doom-variable-pitch-font (font-spec :family "Alegreya" :size 12))

;; Allow mixed fonts in a buffer.
;; This is particularly useful for Org mode, so I can mix source and prose blocks in the same document.

(add-hook! 'org-mode-hook #'mixed-pitch-mode)
(setq mixed-pitch-variable-pitch-cursor nil)



;;=== Themes ===

(setq doom-theme 'doom-acario-light)
(setq org-hide-emphasis-markers t)



;;=== General Hacks ===

;; --- Line numbers
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)


;; --- Windmove
;; http://pragmaticemacs.com/emacs/whizz-between-windows-with-windmove/
;; This is a brilliant package and allows you to move point between windows intuitively and quickly.

(use-package! windmove
  ;; :defer 4
  :ensure t
  :config
  ;; use command key on Mac
  (windmove-default-keybindings 'super)
   ;; wrap around at edges
  (setq windmove-wrap-around t))

;; --- M-RET
;; Make M-Return insert new list/heading item without breaking the line
;; see https://irreal.org/blog/?p=6297
(setq org-M-RET-may-split-line '((item . nil)))


;; ----- Keybindings -------
(global-set-key (kbd "<f9>") 'helm-for-files)
(global-set-key (kbd "<f8>") 'org-emphasize)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)



;; === ORG-MODE ===
;;
;; 1. File Locations
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(after! org
(setq org-directory "~/Dropbox/org/")
(setq org-default-notes-file "~/Dropbox/org/notes/notes.org")
(setq org-agenda-files
      '("~/Dropbox/org"
        "~/.emacs.d"
        "~/Documents"))
(setq org-archive-location "~/Dropbox/org/archives/%s_archive::"))

;; easily open main org file
(map! :leader
    (:prefix ("f" . "file")
     :desc "Open todo.org" "t" '(lambda () (interactive) (find-file "~/Dropbox/org/todo.org"))))


;; 2. Refiling
;;
;; (setq org-refile-targets
;;   '((nil :maxlevel . 2)
;;     (org-agenda-files :maxlevel . 2)
;;     ("~/Dropbox/org/todo.org" :maxlevel . 2)
;;     ("~/Dropbox/org/finanza.org" :maxlevel . 3)
;;     ("~/Dropbox/org/girls.org" :maxlevel . 2)
;;     ("~/Dropbox/org/travel.org" :maxlevel . 2)
;;     ("~/Dropbox/org/greece.org" :maxlevel . 3)
;;     ("~/Dropbox/org/ticklers.org" :maxlevel . 2)
;;     ("~/Dropbox/org/inbox.org" :maxlevel . 2)
;;     ("~/Dropbox/org/projects.org" :maxlevel . 2)))

;; org-refile, a few bits to sort out
   (setq org-refile-targets
         '((org-agenda-files . (:maxlevel . 2))
           (nil . (:maxlevel . 2))))
(setq org-refile-use-outline-path t)
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-refile-use-cache t)
(setq org-reverse-note-order nil)


;; 3. Using with an ICS calendar
;;
(setq org-combined-agenda-icalendar-file
    "~/Dropbox/org/org-agenda.ics")

;; 4. Set Shift-Select on
;;
(setq org-support-shift-select t)


;; --- ORG-CAPTURE ---
;; Simple version
;;
(after! org-capture
 (setq org-capture-templates
       '(("t" "Tasks" entry
          (file+headline "todo.org" "Inbox")
      "* TODO %?\n %U")

     ("a" "Appointment" entry
      (file+headline "todo.org" "Inbox")
      "* TODO Call %?\n %U")

     ("b" "Book to read" entry (file+headline "~/Dropbox/org/notes/culture.org" "Books")
         "** TODO %^{Title}\nby %^{Author}
             \n%^{Brief Description}
             \nEntered: %^U\n\n%i%?")

     ("j" "Journal Entry" entry
      (file+datetree "journal.org")
      "* %U\n%?")))
)

;;
;; Adapted from Prot's version on 14 August, 2021
;;
;; (setq org-capture-templates
;;    `(("t" "Task with a due date" entry
;;         (file+headline "todo.org" "Task list with a date")
;;         ,(concat "* %^{Scope of task||TODO|STUDY|MEET} %^{Title} %^g\n"
;;               "DEADLINE: %^t\n"
;;              ":PROPERTIES:\n:CAPTURED: %U\n:END:\n\n"
;;               "%i%?"))

;;      ("b" "Book to read" entry (file+headline "~/Dropbox/org/notes/culture.org" "Books")
;;             "** TODO %^{Title}\nby %^{Author}
;;             \n%^{Brief Description}
;;             \nEntered: %^U\n\n%i%?")

;;      ("i" "Idea" entry
;;             (file+headline "~/Dropbox/org/notes/broad_thinking.org" "Ideas")
;;             "** TODO %^{Title} :ideas:\n%^U\n\n%i%?")

;;      ("m" "Make email note" entry
;;            (file+headline "todo.org" "Mail correspondence")
;;            ,(concat "* TODO [#A] %:subject :mail:\n"
;;                     "SCHEDULED: %t\n:"
;;                     "PROPERTIES:\n:CONTEXT: %a\n:END:\n\n"
;;                     "%i%?"))))



;; --- Org-Agenda ---
;;
;; Again, adapted from Protesilaos
;;
(use-package! org-agenda
  :after org
  :config
  ;; Basic setup
  (setq org-agenda-span 14)
  (setq org-agenda-start-on-weekday 1)  ; Monday
  (setq org-agenda-confirm-kill t)
  (setq org-agenda-show-all-dates t)
  (setq org-agenda-show-outline-path nil)
  (setq org-agenda-window-setup 'current-window)
  (setq org-agenda-skip-comment-trees t)
  (setq org-agenda-menu-show-matcher t)
  (setq org-agenda-menu-two-columns nil)
  (setq org-agenda-sticky nil)
  (setq org-agenda-custom-commands-contexts nil)
  (setq org-agenda-max-entries nil)
  (setq org-agenda-max-todos nil)
  (setq org-agenda-max-tags nil)
  (setq org-agenda-max-effort nil)

  ;; General view options
  (setq org-agenda-prefix-format
        '((agenda . " %i %-12:c%?-12t% s")
          (todo . " %i %-12:c")
          (tags . " %i %-12:c")
          (search . " %i %-12:c")))
  (setq org-agenda-sorting-strategy
        '(((agenda habit-down time-up priority-down category-keep)
           (todo priority-down category-keep)
           (tags priority-down category-keep)
           (search category-keep))))
  (setq org-agenda-breadcrumbs-separator "->")
  (setq org-agenda-todo-keyword-format "%-1s")
  (setq org-agenda-diary-sexp-prefix nil)
  (setq org-agenda-fontify-priorities 'cookies)
  (setq org-agenda-category-icon-alist nil)
  (setq org-agenda-remove-times-when-in-prefix nil)
  (setq org-agenda-remove-timeranges-from-blocks nil)
  (setq org-agenda-compact-blocks nil)
  (setq org-agenda-block-separator ?—)

  ;; Marks
  (setq org-agenda-bulk-mark-char "#")
  (setq org-agenda-persistent-marks nil)

  ;; Diary entries
  (setq org-agenda-insert-diary-strategy 'date-tree)
  (setq org-agenda-insert-diary-extract-time nil)
  (setq org-agenda-include-diary t)

  ;; Follow mode
  (setq org-agenda-start-with-follow-mode nil)
  (setq org-agenda-follow-indirect t)

  ;; Multi-item tasks
  (setq org-agenda-dim-blocked-tasks t)
  (setq org-agenda-todo-list-sublevels t)

  ;; Filters and restricted views
  (setq org-agenda-persistent-filter nil)
  (setq org-agenda-restriction-lock-highlight-subtree t)

  ;; Items with deadline and scheduled timestamps
  (setq org-agenda-include-deadlines t)
  (setq org-deadline-warning-days 5)
  (setq org-agenda-skip-scheduled-if-done nil)
  (setq org-agenda-skip-scheduled-if-deadline-is-shown t)
  (setq org-agenda-skip-timestamp-if-deadline-is-shown t)
  (setq org-agenda-skip-deadline-if-done nil)
  (setq org-agenda-skip-deadline-prewarning-if-scheduled 1)
  (setq org-agenda-skip-scheduled-delay-if-deadline nil)
  (setq org-agenda-skip-additional-timestamps-same-entry nil)
  (setq org-agenda-skip-timestamp-if-done nil)
  (setq org-agenda-search-headline-for-time t)
  (setq org-scheduled-past-days 365)
  (setq org-deadline-past-days 365)
  (setq org-agenda-move-date-from-past-immediately-to-today t)
  (setq org-agenda-show-future-repeats t)
  (setq org-agenda-prefer-last-repeat nil)
  (setq org-agenda-timerange-leaders
        '("" "(%d/%d): "))
  (setq org-agenda-scheduled-leaders
        '("Scheduled: " "Sched.%2dx: "))
  (setq org-agenda-inactive-leader "[")
  (setq org-agenda-deadline-leaders
        '("Deadline:  " "In %3d d.: " "%2d d. ago: "))
  ;; Time grid
  (setq org-agenda-time-leading-zero t)
  (setq org-agenda-timegrid-use-ampm nil)
  (setq org-agenda-use-time-grid t)
  (setq org-agenda-show-current-time-in-grid t)
  (setq org-agenda-current-time-string
        "-·-·-·-·-·-·-·-·-")
  (setq org-agenda-time-grid
        '((daily today require-timed)
          (0700 0800 0900 1000 1100
                1200 1300 1400 1500 1600
                1700 1800 1900 2000 2100)
          " ....." "-----------------"))
  (setq org-agenda-default-appointment-duration nil)

  ;; Global to-do list
  (setq org-agenda-todo-ignore-with-date t)
  (setq org-agenda-todo-ignore-timestamp t)
  (setq org-agenda-todo-ignore-scheduled t)
  (setq org-agenda-todo-ignore-deadlines t)
  (setq org-agenda-todo-ignore-time-comparison-use-seconds t)
  (setq org-agenda-tags-todo-honor-ignore-options nil)

  ;; Tagged items
  (setq org-agenda-show-inherited-tags t)
  (setq org-agenda-use-tag-inheritance
        '(todo search agenda))
  (setq org-agenda-hide-tags-regexp nil)
  (setq org-agenda-remove-tags nil)
  (setq org-agenda-tags-column -120))


;; --- Org-Super-Agenda
;;
;; Adapted from bsag: https://www.rousette.org.uk/archives/doom-emacs-tweaks-org-journal-and-org-super-agenda/

(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-compact-blocks t
      org-agenda-start-day nil ;; i.e. today
      org-agenda-span 1
      org-agenda-start-on-weekday nil)
  (setq org-agenda-custom-commands
        '(("c" "Super view"
           ((agenda "" ((org-agenda-overriding-header "")
                        (org-super-agenda-groups
                         '((:name "Today"
                                  :time-grid t
                                  :date today
                                  :order 1)))))
            (alltodo "" ((org-agenda-overriding-header "")
                         (org-super-agenda-groups
                          '((:log t)
                            (:name "To refile"
                                   :file-path "refile\\.org")
                            (:name "Next to do"
                                   :todo "NEXT"
                                   :order 1)
                            (:name "Important"
                                   :priority "A"
                                   :order 6)
                            (:name "Today's tasks"
                                   :file-path "journal/")
                            (:name "Due Today"
                                   :deadline today
                                   :order 2)
                            (:name "Scheduled Soon"
                                   :scheduled future
                                   :order 8)
                            (:name "Overdue"
                                   :deadline past
                                   :order 7)
                            (:name "Meetings"
                                   :and (:todo "MEET" :scheduled future)
                                   :order 10)
                            (:discard (:not (:todo "TODO")))))))))))
  :config
  (org-super-agenda-mode))



;; --- Org-superstar
;;
;; Use i-ching trigrams: https://www.gtrun.org/post/config/#org-superstar

(use-package! org-superstar
  :config
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))
        (setq org-superstar-headline-bullets-list '("☰" "☷" "☵" "☲"  "☳" "☴"  "☶"  "☱" ))
  (setq org-ellipsis "⤵")
)


;; --- Org-journal
;;
;; org-journal the DOOM way
;; https://github.com/sunnyhasija/Academic-Doom-Emacs-Config
;;
(use-package! org-journal
  :ensure t
  :defer t
  :init
  (setq org-journal-dir "/Users/pjp/Dropbox/org/journal/")
  (setq org-journal-date-prefix "#+TITLE: ")
  (setq org-journal-file-format "%Y-%m-%d.org")
  (setq org-journal-date-format "%A, %d %B %Y")
  :config
  (setq org-journal-find-file #'find-file-other-window )
  (map! :map org-journal-mode-map
        "C-c n s" #'evil-save-modified-and-close )
  )

(setq org-journal-enable-agenda-integration t)

;; via BSAG some helpful mappings in Doom for org-journal
;; https://www.rousette.org.uk/archives/doom-emacs-tweaks-org-journal-and-org-super-agenda/
;; in ~/.doom.d/+bindings.el
(map! :leader
     (:prefix ("j" . "journal") ;; org-journal bindings
       :desc "Create new journal entry" "j" #'org-journal-new-entry
       :desc "Open previous entry" "p" #'org-journal-open-previous-entry
       :desc "Open next entry" "n" #'org-journal-open-next-entry
       :desc "Search journal" "s" #'org-journal-search-forever))


;; === Deft ===
;; https://jblevins.org/projects/deft/
;; Deft is an Emacs mode for quickly browsing, filtering, and editing directories of plain text notes, inspired by Notational Velocity.
;;
(use-package! deft)
(setq deft-directory "~/Dropbox/notesy")
;;(setq deft-extension "org")
;;(setq deft-text-mode 'org-mode)
(setq deft-use-filename-as-title t)
(setq deft-auto-save-interval 0)







;; Here are some additional functions/macros that could help you configure Doom:
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

;; (provide 'config)

;;; config.el ends here
