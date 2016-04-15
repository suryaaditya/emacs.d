(use-package projectile
  :init
  (projectile-global-mode)
  :config
  (progn
    (defun projectile-custom-mode-line ()
      (if (projectile-project-p)
          (let* ((project-name (projectile-project-name))
                 (project-name-mode-line (if (> (length project-name) 12)
                                             (substring project-name 0 8)
                                           project-name)))
            (format " P[%s] " project-name-mode-line))
        ""))
    (setq-default projectile-mode-line '(:eval (projectile-custom-mode-line)))
    (setq projectile-known-projects-file
          (expand-file-name "cache/projectile-bookmarks.eld" user-emacs-directory))
    (setq projectile-cache-file
          (expand-file-name "cache/projectile.cache" user-emacs-directory))


    (def-projectile-commander-method ?s
      "Open a *shell* buffer for the project."
      (shell (get-buffer-create
              (format "*shell %s*"
                      (projectile-project-name)))))

    (def-projectile-commander-method ?c
      "Run `compile' in the project."
      (call-interactively #'compile))

    (def-projectile-commander-method ?\C-?
      "Go back to project selection."
      (projectile-switch-project))

    (def-projectile-commander-method ?d
      "Open project root in dired."
      (projectile-dired))

    (def-projectile-commander-method ?F
      "Git fetch."
      ;; (magit-status)
      (call-interactively #'magit-status)
      ;; (call-interactively #'magit-fetch-popup)
      )

    (def-projectile-commander-method ?j
      "Jack-in."
      (let* ((opts (projectile-current-project-files))
             (file (ido-completing-read
                    "Find file: "
                    opts
                    nil nil nil nil
                    (car (cl-member-if
                          (lambda (f)
                            (string-match "core\\.clj\\'" f))
                          opts)))))
        (find-file (expand-file-name
                    file (projectile-project-root)))
        (run-hooks 'projectile-find-file-hook)
        (cider-jack-in)))

    (evil-leader/set-key "pf" 'projectile-find-file)
    (evil-leader/set-key "pa" 'projectile-ag)
    (evil-leader/set-key "pk" 'projectile-kill-buffers)
    (evil-leader/set-key "pm" 'projectile-command-map)
    (evil-leader/set-key "pp" 'projectile-commander)
    (evil-leader/set-key "pt" 'neotree-find-project-root)

    (add-to-list 'projectile-globally-ignored-files ".DS_Store")
    (add-to-list 'projectile-globally-ignored-files "*.pyc")
    (add-to-list 'projectile-globally-ignored-files "*.python-version")
    (add-to-list 'projectile-globally-ignored-files "*.egg-info")
    (add-to-list 'projectile-globally-ignored-directories "__pycache__")
    (add-to-list 'projectile-globally-ignored-directories ".env")
    (add-to-list 'projectile-globally-ignored-directories ".venv")
    (add-to-list 'projectile-globally-ignored-directories ".cask")
    (add-to-list 'projectile-globally-ignored-directories ".cache")
    (setq projectile-globally-ignored-directories
          '(".idea"
            ".eunit"
            ".git"
            ".hg"
            ".fslckout"
            ".bzr"
            "_darcs"
            ".tox"
            ".svn"
            "build")
          )
    ))

(provide 'init-projectile)
