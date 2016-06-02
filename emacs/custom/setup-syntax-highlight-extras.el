;; JSON files
(add-to-list 'auto-mode-alist '("\\.json$" . js-mode))

;;JS2-Mode
(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)
(setq js2-highlight-level 3)

;;.ino files use c++-mode
(setq auto-mode-alist
      (append
       '(("\\.ino$" . c++-mode))
       auto-mode-alist))

;;Emacs markdown mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Bracket pairing
(show-paren-mode 1); turn on paren matching
(setq show-paren-delay 0); no delay to show
(setq show-paren-style 'parenthesis); highlight only parenthesis

;; Highlight current line
(global-hl-line-mode 1)

(provide 'setup-syntax-highlight-extras)
