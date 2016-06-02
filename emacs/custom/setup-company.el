(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(delete 'company-semantic company-backends)
(define-key c-mode-map  [(tab)] 'company-complete)
(define-key c++-mode-map  [(tab)] 'company-complete)
(eval-after-load 'js-mode '(define-key js-mode-map  [(tab)] 'company-complete))
;; (define-key c-mode-map  [(control tab)] 'company-complete)
;; (define-key c++-mode-map  [(control tab)] 'company-complete)

;; company-c-headers
(add-to-list 'company-backends 'company-c-headers)
(add-to-list 'company-backends 'company-css)
(add-to-list 'company-backends 'company-eclim)
(add-to-list 'company-backends 'company-capf)

(provide 'setup-company)
