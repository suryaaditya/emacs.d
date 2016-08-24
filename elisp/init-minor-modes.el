(use-package yaml-mode
  :mode ("\\.yml$" . yaml-mode))

(use-package markdown-mode
  :mode (("\\.markdown$" . markdown-mode)
         ("\\.md$" . markdown-mode)))
(use-package json-mode
  :defer t)

(use-package scratch
  :ensure t)

;;;; Modes ;;;;
(add-hook 'emacs-lisp-mode-hook 'prettify-symbols-mode)
(add-hook 'clojure-mode-hook 'prettify-symbols-mode)
(add-to-list 'auto-mode-alist '("\\.zsh\\'" . sh-mode))


(use-package with-editor
  :ensure t
  :init
  (progn
    (add-hook 'shell-mode-hook  'with-editor-export-editor)
    (add-hook 'eshell-mode-hook 'with-editor-export-editor)))

(use-package smartscan
  :ensure t
  :init
  (add-hook #'prog-mode-hook #'smartscan-mode)
  :config
  (define-key smartscan-map (kbd "M-n") nil)
  (define-key smartscan-map (kbd "M-p") nil)
  (define-key smartscan-map (kbd "M-'") nil))

;;; Visible mark
(use-package visible-mark
  :ensure t
  :init
  (defface face2
    '((((type tty) (class mono)))
      (t (:foreground "#FF1D00" :background "#E593C3")))
    "Face for flycheck error feedback in the modeline."
    :group 'visible-mark)
  :config
  (setq visible-mark-max 1)
  (setq visible-mark-faces `(face2 visible-mark-face2))
  (global-visible-mark-mode 1))

(use-package bug-hunter                            ; Search init file for bugs
  :ensure t)

(use-package shrink-whitespace
  :ensure t
  :bind (("M-SPC" . shrink-whitespace)
         ("M-S-SPC" . shrink-whitespace)))

(use-package paren-face
  :ensure t
  :init (global-paren-face-mode))

(use-package find-file-in-project
  :ensure t
  ;; :config (setq ffip-prefer-ido-mode t)
  )

(use-package outshine
  :diminish outline-minor-mode
  :commands outshine-hook-function
  :init
  (add-hook 'outline-minor-mode-hook 'outshine-hook-function)
  (add-hook 'emacs-lisp-mode-hook 'outline-minor-mode)
  )

(use-package paradox
  :ensure t
  :init
  (setq paradox-github-token t
        paradox-column-width-package 30))


(provide 'init-minor-modes)
