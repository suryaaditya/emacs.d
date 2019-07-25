(use-package clojure-mode
  :mode (("\\.edn$" . clojure-mode)
         ("\\.boot$" . clojure-mode)
         ("\\.clj$" . clojure-mode)
         ("\\.cljs$" . clojurescript-mode)
         ("\\.cljx$" . clojurex-mode))
  :hook ((clojure-mode . cider-mode)
         (clojure-mode . subword-mode))
  :config
  (progn
    ;;(add-to-list 'auto-mode-alist '("\\.boot\\" . clojure-mode))
    ;;(add-to-list 'magic-mode-alist '(".* boot" . clojure-mode))
    ;;(add-to-list 'auto-mode-alist '("\\.cljc\\" . clojurec-mode))
    ;;(add-to-list 'auto-mode-alist '("\\.cljx\\" . clojurex-mode))
    ;;(add-to-list 'auto-mode-alist '("\\.cljs\\" . clojurescript-mode))
    ;;(add-to-list 'auto-mode-alist '("\\.clj\\" . clojure-mode))

    (setq clojure-align-forms-automatically t)
    (setq clojure-align-reader-conditionals t)

    (use-package clj-refactor
      :ensure t
      :init
      (add-hook 'clojure-mode-hook (lambda () (clj-refactor-mode 1))))

    (define-clojure-indent
      (defroutes 'defun)
      (GET 2)
      (POST 2)
      (PUT 2)
      (DELETE 2)
      (HEAD 2)
      (ANY 2)
      (context 2)
      (let-routes 1))

    (define-clojure-indent
      (form-to 1))

    (define-clojure-indent
      (match 1)
      (are 2)
      (checking 2)
      (async 1))

    (define-clojure-indent
      (select 1)
      (insert 1)
      (update 1)
      (delete 1))

    (define-clojure-indent
      (run* 1)
      (fresh 1))

    (define-clojure-indent
      (extend-freeze 2)
      (extend-thaw 1))

    (define-clojure-indent
      (go-loop 1))

    (define-clojure-indent
      (this-as 1)
      (specify 1)
      (specify! 1))

    (csetq clojure-indent-style :always-align)
    (csetq clojure-indent-style :always-indent)
    (csetq clojure-indent-style :align-arguments)

    (setq clojure--prettify-symbols-alist
          '(("fn" . ?λ)
            ("not=" . ?≠)
            ("identical?" . ?≡)))

    (defun clojure-fancify-symbols (mode)
      "Pretty symbols for Clojure's anonymous functions and sets,
   like (λ [a] (+ a 5)), ƒ(+ % 5), and ∈{2 4 6}."
      (font-lock-add-keywords mode
                              `(("(\\(fn\\)[\n\[[:space:]]"
                                 (0 (progn (compose-region (match-beginning 1)
                                                           (match-end 1) "λ"))))
                                ("(\\(partial\\)[\[[:space:]]"
                                 (0 (progn (compose-region (match-beginning 1)
                                                           (match-end 1) "Ƥ"))))
                                ("(\\(comp\\)[\n\[[:space:]]"
                                 (0 (progn (compose-region (match-beginning 1)
                                                           (match-end 1) "∘"))))
                                ("\\(#\\)("
                                 (0 (progn (compose-region (match-beginning 1)
                                                           (match-end 1) "ƒ"))))
                                ("\\(#\\){"
                                 (0 (progn (compose-region (match-beginning 1)
                                                           (match-end 1) "∈")))))))

    (dolist (m '(clojure-mode clojurescript-mode clojurec-mode clojurex-mode cider-mode cider-repl-mode))
      (clojure-fancify-symbols m))

    (defun cider-user-ns ()
      (interactive)
      (cider-repl-set-ns "user"))

    (defun toggle-nrepl-buffer ()
      "Toggle the nREPL REPL on and off"
      (interactive)
      (if (string-match "cider-repl" (buffer-name (current-buffer)))
          (delete-window)
        (cider-switch-to-repl-buffer)))

    (defun cider-save-and-refresh ()
      (interactive)
      (save-buffer)
      (call-interactively 'cider-refresh))

    (defun cider-benchmark-defun-at-point ()
      (interactive)
      (cider-interactive-eval
       (format "(require 'criterium.core)
            (criterium.core/quick-benchmark %s)"
               (cider-eval-defun-at-point))))

    (defun cider-send-and-evaluate-sexp ()
      "Sends the s-expression located before the point or the active
       region to the REPL and evaluates it. Then the Clojure buffer is
       activated as if nothing happened."
      (interactive)
      (if (not (region-active-p))
          (cider-insert-last-sexp-in-repl)
        (cider-insert-in-repl
         (buffer-substring (region-beginning) (region-end)) nil))
      (cider-switch-to-repl-buffer)
      (cider-repl-closing-return)
      (cider-switch-to-last-clojure-buffer)
      (message ""))

    (defun cider-eval-defun-or-region ()
      "Eval defun at point or region when it is active"
      (interactive)
      (if (use-region-p)
          (cider-eval-region)
        (cider-eval-defun-at-point)))

    (defun clj-mode-keys-setup ()
      "for 'clojure mode'"
      (setq cider-repl-shortcut-dispatch-char ?\;)
      (bind-keys :map clojure-mode-map
                 ("C-x C-e" . cider-eval-last-sexp)
                 ("C-c C-r" . cider-repl-reset)
                 ("C-c C-v" . cider-send-and-evaluate-sexp)
                 ("C-:" . counsel-clj))
      ;; (define-key clojure-mode-map (kbd "C-:") nil)
      ;; (define-key clojure-mode-map (kbd "β") 'counsel-clj)
      (bind-keys :map cider-browse-ns-mode-map
                 ("j" . next-line)
                 ("k" . previous-line))
      (unbind-key (kbd "/") clj-refactor-map)
      (unbind-key (kbd ",") cider-repl-mode-map)

      ;; (define-key cider-mode-map (kbd "C-:") nil)
      (define-key cider-repl-mode-map (kbd "C-x C-l") 'cider-repl-clear-buffer)
      ;; (define-key cider-repl-mode-map (kbd "C-:") nil)
      )

    (add-hook 'clojure-mode-hook #'clj-mode-keys-setup)))

(use-package cider
  :commands (cider cider-connect cider-jack-in)
  :init
  (progn
    (add-hook 'cider-mode-hook #'eldoc-mode)
    (add-hook 'cider-repl-mode-hook #'eldoc-mode)
    (add-hook 'cider-clojure-interaction-mode-hook 'eldoc-mode)
    (add-hook 'cider-repl-mode-hook 'company-mode)
    (add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode)
    (add-hook 'cider-mode-hook 'company-mode)
    (add-hook 'cider-repl-mode-hook 'subword-mode)
    (add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
    (add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion))
  :config
  (progn
    (setq cider-prompt-for-symbol nil)
    (setq cider-overlays-use-font-lock t)
    ;; (setq cider-pprint-fn 'puget)
    (setq cider-repl-history-file "~/.emacs.d/nrepl-history")
    ;; (setq cider-repl-pop-to-buffer-on-connect nil)
    (setq cider-repl-pop-to-buffer-on-connect 'display-only)
    ;; (setq cider-repl-use-clojure-font-lock nil)
    (setq cider-repl-scroll-on-output nil)
    (setq cider-repl-use-clojure-font-lock t)
    (setq cider-repl-wrap-history t)
    (setq cider-repl-history-size 1000)
    (setq cider-repl-shortcut-dispatch-char ?\;)
    (setq cider-repl-result-prefix ";; => ")
    (setq cider-auto-select-error-buffer t)
    (setq cider-show-error-buffer t)
    (setq nrepl-popup-stacktraces nil)
    (setq nrepl-hide-special-buffers t)
    (setq nrepl-log-messages t)
    (setq nrepl-buffer-name-show-port t)
    (setq nrepl-buffer-name-separator "-")
    (setq cider-prompt-save-file-on-load nil)
    (setq cider-popup-stacktraces-in-repl t)
    (setq cider-prefer-local-resources t)
    (setq cider-interactive-eval-result-prefix ";; => ")
    (setq cider-stacktrace-fill-column 80)
    (setq cider-test-show-report-on-success t)
    (setq cider-repl-use-pretty-printing t)
    (setq cider-default-repl-command "lein")
    (setq cider-ns-refresh-before-fn "user/stop"
          cider-ns-refresh-after-fn "user/start")
    (setq cider-font-lock-dynamically t
          cider-invert-insert-eval-p t
          cider-switch-to-repl-after-insert-p nil))

  (require 'cider-hydra))

(use-package typed-clojure-mode
  :disabled t
  :config
  (add-hook 'clojure-mode-hook 'typed-clojure-mode))

(use-package flycheck-clojure
  :ensure t
  :defer t
  :config
  (eval-after-load 'flycheck '(flycheck-clojure-setup)))

(use-package flycheck-joker
  :ensure t
  :init
  (progn
    (require 'flycheck-joker)
    (defun clj-joker-hook () (flycheck-mode 1))
    (add-hook 'clojure-mode-hook #'clj-joker-hook)))

(use-package 4clojure
  :ensure t
  :defer t)

(use-package cider-eval-sexp-fu
  :ensure t
  :config
  (progn
    (defun config-init-cider-eval-sexp-fu ()
      (require 'cider-eval-sexp-fu))
    (add-hook 'cider-mode-hook 'config-init-cider-eval-sexp-fu)))

;;; clojurescript (build from emacs, and pop up stacktrack when
;;; there's a error):
(use-package cljsbuild-mode
  :ensure t
  :diminish cljsbuild-mode)

(use-package html-to-hiccup
  :ensure t
  :config
  ;; (define-key clojure-mode-map (kbd "H-h") 'html-to-hiccup-convert-region)
  )

(provide 'init-clojure)
