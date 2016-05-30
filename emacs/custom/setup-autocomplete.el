;; Auto complete
(require 'auto-complete-config)
(global-auto-complete-mode t)
(setq ac-auto-start nil)
;;(setq ac-use-fuzzy t) ; This might need to be disabled if completion is not good or slow
(set-default 'ac-sources
	     '(ac-source-imenu
	       ac-source-dictionary
               ac-source-words-in-buffer
               ac-source-words-in-same-mode-buffers
               ac-source-words-in-all-buffer))

(ac-set-trigger-key "TAB")   ;TAB works as auto complete
(ac-set-trigger-key "<tab>") ;"       "  " " 

(provide 'setup-autocomplete)
