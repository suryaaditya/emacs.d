(use-package anzu
  :ensure t
  :bind (("C-M-%" . anzu-query-replace)
         ("M-%" . anzu-query-replace-regexp))
  :config
  (global-anzu-mode))

(provide 'init-anzu)
