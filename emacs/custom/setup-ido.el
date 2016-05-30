;; Ido
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-ignore-buffers '("\\` " "^\*"))

; make ido display choices vertically
(setq ido-separator "\n")
(setq ido-create-new-buffer 'always)
(ido-mode 1)

(provide 'setup-ido)
