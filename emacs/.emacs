;;Author: s0ysauc3
;; Emacs config file
;;;;;;;;;;;;Loading paths;;;;;;;;;;;;;;;;;

;;load themes from the directory and extensions
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(add-to-list 'load-path "~/.emacs.d/extensions/")
;; load module configs and other scripts
(add-to-list 'load-path' "~/.emacs.d/custom")

;;;;;;;;;;;;; MELPA package admin ;;;;;;;;;;;;;;;;
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(package-initialize) ;; You might already have this line

;;;;;; List of packages that need to be installed ;;;;;;;;;;;;;;;;

(setq package-list '(
		     auto-complete
		     popup
		     color-theme
		     lua-mode magit
		     multi-term popup
		     smex
		     solarized-theme
		     sr-speedbar
		     sublimity
		     tabbar
		     theme-changer
		     yasnippet
		     helm
		     helm-gtags
		     helm-projectile
		     helm-swoop
		     ))

; Refresh package list
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;;;;;; Plugin activation ;;;;;;;;;;;;;;;
;; Tabs
(require 'setup-tabbar)
;; Expression matching
;;(require 'setup-ido)
(require 'setup-helm)
(require 'setup-helm-gtags)

;;(require 'setup-smex)
;; File tree explorer
(require 'sr-speedbar)
;; Snippets
(require 'setup-yasnippet)
;; Sublimity
;;(require 'sublimity)
;;(require 'sublimity-scroll)
;; Autocomplete
;;(require 'setup-autocomplete)
;; Multiterm
(require 'setup-multiterm)

;;;;;;;;;;; Theme setup ;;;;;;;;;;;;;;;;;;;;
(require 'setup-theme)

;;;;;;;;;;; Font and aspect tweaking ;;;;;;;;;;;;;;;;;;;;
(require 'setup-syntax-highlight-extras)

;;;;;;;;;;;; Key bindings ;;;;;;;;;
(require 'setup-keybindings)

;; Temporary directory for backup files
(require 'setup-misc-config)

