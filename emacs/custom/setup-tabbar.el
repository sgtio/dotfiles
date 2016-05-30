;; Tabbar Setup script
(require 'tabbar)
(set-face-attribute
 'tabbar-default nil
 :background "#fdf6e3"
 :foreground "#657b83"
 :underline nil
 )
(set-face-attribute
 'tabbar-unselected nil
 :background "#fdf6e3"
 :foreground "657b83"
 :underline nil
 )
(set-face-attribute
 'tabbar-selected nil
 :background "#657b83"
 :foreground "#fdf6e3"
 :underline nil
 )
(set-face-attribute
 'tabbar-highlight nil
 :background "white"
 :foreground "black"
 :underline nil
 )
(set-face-attribute
 'tabbar-button nil
 :underline nil
 )
(set-face-attribute
 'tabbar-separator nil
 :background "#fdf6e3"
 :underline nil
 )

;; Change padding of the tabs
;; we also need to set separator to avoid overlapping tabs by highlighted tabs
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#2D2D2D" "#CC9393" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(custom-safe-themes
   (quote
    ("4ff23437b3166eeb7ca9fa026b2b030bba7c0dfdc1ff94df14dfb1bcaee56c78" "3d5ef3d7ed58c9ad321f05360ad8a6b24585b9c49abcee67bdcbb0fe583a6950" "c537bf460334a1eca099e05a662699415f3971b438972bed499c5efeb821086b" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "cedd3b4295ac0a41ef48376e16b4745c25fa8e7b4f706173083f16d5792bb379" "19ba41b6dc0b5dd34e1b8628ad7ae47deb19f968fe8c31853d64ea8c4df252b8" "9adb05f54675672059c9d7623dd19f050cdb465aecfb1c1189ae79f3a78a7228" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "31a01668c84d03862a970c471edbd377b2430868eccf5e8a9aec6831f1a0908d" "8d6fb24169d94df45422617a1dfabf15ca42a97d594d28b3584dc6db711e0e0b" "1297a022df4228b81bc0436230f211bad168a117282c20ddcba2db8c6a200743" "1db337246ebc9c083be0d728f8d20913a0f46edc0a00277746ba411c149d7fe5" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "08efabe5a8f3827508634a3ceed33fa06b9daeef9c70a24218b70494acdf7855" "7c89d1df5a1dd624983f6d107aced89a4b3d787b20997e5c6cff30cc1ba1b55d" "764e3a6472a3a4821d929cdbd786e759fab6ef6c2081884fca45f1e1e3077d1d" default)))
 '(fci-rule-color "#383838")
 '(inhibit-startup-screen t)
 '(safe-local-variable-values (quote ((hl-sexp-mode) (rainbow-mode . t))))
 '(tabbar-separator (quote (0.5)))
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3"))
;; adding spaces
(defun tabbar-buffer-tab-label (tab)
  "Return a label for TAB.
That is, a string used to represent it on the tab bar."
  (let ((label  (if tabbar--buffer-show-groups
                    (format "[%s]  " (tabbar-tab-tabset tab))
                  (format "%s  " (tabbar-tab-value tab)))))
    ;; Unless the tab bar auto scrolls to keep the selected tab
    ;; visible, shorten the tab label to keep as many tabs as possible
    ;; in the visible area of the tab bar.
    (if tabbar-auto-scroll-flag
        label
      (tabbar-shorten
       label (max 1 (/ (window-width)
                       (length (tabbar-view
                                (tabbar-current-tabset)))))))))


(setq tabbar-use-images nil)

(setq tabbar-buffer-groups-function
      (lambda ()
	(list "All Buffers")))

(setq tabbar-buffer-list-function
      (lambda ()
	(remove-if
	 (lambda(buffer)
	   (find (aref (buffer-name buffer) 0) " *"))
	 (buffer-list))))


(tabbar-mode 1)

(provide 'setup-tabbar)
