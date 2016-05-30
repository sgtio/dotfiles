
;; Saving temp files directory
(defconst emacs-tmp-dir (format "%s%s%s/" temporary-file-directory "emacs" (user-uid)))
(setq backup-directory-alist
      `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
      emacs-tmp-dir)


;; Menu Scroll Bar and Tool Bar customization
(tool-bar-mode -1)
(scroll-bar-mode -1)

(defun tb/tb-enabler (frame)
  (select-frame frame)
 (if (window-system frame)
       (progn
 	(menu-bar-mode 1))
    (progn
       (menu-bar-mode -1))))

(add-hook 'after-make-frame-functions 'tb/tb-enabler)

;; Add line numbering
(global-linum-mode t)
(setq linum-format "%d "); Add some space to between line number and text

;; Cursor
(blink-cursor-mode 1)
(setq-default cursor-type 'bar)

;; Hide welcome screen
(setq inhibit-startup-message t)

(provide 'setup-misc-config)
