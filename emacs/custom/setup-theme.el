;;If we want dynamic theme depending on the terminal or GUI interface uncomment the block

(load-theme 'solarized-light t)
;(load-theme 'zenburn t t )
;;(defun mb/pick-color-theme (frame)
;;  (select-frame frame)
;; (if (window-system frame)
;;       (progn
;; 	(enable-theme 'spacegray))
;;     (progn
;;       (enable-theme 'zenburn))))
;;
;;(add-hook 'after-make-frame-functions 'mb/pick-color-theme)

;; ;Defines theme if emacs is not called as client
;;(if window-system
;;    (enable-theme 'spacegray)  
;;  (enable-theme 'zenburn))

;; Personal BG colors
(set-face-attribute 'region nil :weight 'bold)
(set-face-foreground 'highlight nil)

(provide 'setup-theme)
