
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

;; Provide code folding for different modes
(add-hook 'c-mode-common-hook   'hs-minor-mode)
(add-hook 'prog-mode-common-hook   'hs-minor-mode)
(add-hook 'python-mode-common-hook   'hs-minor-mode)

;; Code style definition
;; Available C style:
;; “gnu”: The default style for GNU projects
;; “k&r”: What Kernighan and Ritchie, the authors of C used in their book
;; “bsd”: What BSD developers use, aka “Allman style” after Eric Allman.
;; “whitesmith”: Popularized by the examples that came with Whitesmiths C, an early commercial C compiler.
;; “stroustrup”: What Stroustrup, the author of C++ used in his book
;; “ellemtel”: Popular C++ coding standards as defined by “Programming in C++, Rules and Recommendations,” Erik Nyquist and Mats Henricson, Ellemtel
;; “linux”: What the Linux developers use for kernel development
;; “python”: What Python developers use for extension modules
;; “java”: The default style for java-mode (see below)
;; “user”: When you want to define your own style
(setq
 c-default-style "linux" ;; set style to "linux"
 )


;; Indentation
(global-set-key (kbd "RET") 'newline-and-indent)  ; automatically indent when press RET
;; activate whitespace-mode to view all whitespace characters
(global-set-key (kbd "C-c w") 'whitespace-mode)

;; show unncessary whitespace that can mess up your diff
(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1)))

;; use space to indent by default
(setq-default indent-tabs-mode nil)

;; set appearance of a tab that is represented by 4 spaces
(setq-default tab-width 4)


(provide 'setup-misc-config)
