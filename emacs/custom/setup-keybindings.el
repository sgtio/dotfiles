;; Insert key disabled
(global-set-key [insert] (lambda () (interactive)))
(global-set-key [insertchar] (lambda () (interactive)))

;; F12 indentes region
(global-set-key [f12] 'indent-region)

;;Widnow resizing and navigation
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)
(windmove-default-keybindings)

(provide 'setup-keybindings)
