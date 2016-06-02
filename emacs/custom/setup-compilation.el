;; Compile with F5
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))


;; RealGUD
(require 'realgud)

(provide 'setup-compilation)
