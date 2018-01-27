(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(package-initialize)


;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; ----------------------------------------
;; global config

(menu-bar-mode -1)
(setq tramp-default-method "ssh")

(setq-default indent-tabs-mode nil)
(setq whitespace-style (quote
			(face trailing tabs xlines)))

(add-hook 'before-save-hook 'whitespace-cleanup)


;; ----------------------------------------
;; keys

;;(define-key input-decode-map "\e[1;10A" [M-S-up])
;;(define-key input-decode-map "\e[1;10B" [M-S-down])
;;(define-key input-decode-map "\e[1;10C" [M-S-right])
;;(define-key input-decode-map "\e[1;10D" [M-S-left])

(define-key input-decode-map "\e[1;8A" [C-M-up])
(define-key input-decode-map "\e[1;8B" [C-M-down])
(define-key input-decode-map "\e[1;8C" [C-M-right])
(define-key input-decode-map "\e[1;8D" [C-M-left])

(define-key input-decode-map "\e[1;9A" [M-up])
(define-key input-decode-map "\e[1;9B" [M-down])
(define-key input-decode-map "\e[1;9C" [M-right])
(define-key input-decode-map "\e[1;9D" [M-left])

;(define-key input-decode-map "\e[40;1" ["C-="])
;(define-key input-decode-map "\e[40;2" ["C-("])
;(define-key input-decode-map "\e[40;3" ["C-)"])

;; ----------------------------------------
;; packages

(require 'use-package)
(setq use-package-always-ensure t)

(use-package smart-mode-line
  :init
  (setq sml/no-confirm-load-theme t)
  (setq sml/theme "dark")
  (sml/setup))

(use-package paredit
  :init
  ;;(add-hook 'clojure-mode-hook 'paredit-mode)
  ;;(add-hook 'cider-repl-mode-hook 'paredit-mode)
  (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode))

(use-package paredit-everywhere)
;(add-hook 'prog-mode-hook 'paredit-everywhere-mode)

(use-package rainbow-delimiters
  :init (progn
          (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)))

(defun pprint ()
       (interactive)
       (cider-interactive-eval
        "(do (require 'clojure.pprint)
             (clojure.pprint/pp))"))

(use-package cider
  :init (progn
          (add-hook 'clojure-mode-hook 'paredit-mode)
          ;;(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
          (add-hook 'clojure-mode-hook 'whitespace-mode)
          (add-hook 'clojure-mode-hook 'eldoc-mode)

          (add-hook 'clojurescript-mode-hook 'whitespace-mode)
          (add-hook 'cider-repl-mode-hook 'eldoc-mode)
          ;;(add-hook 'clojurescript-mode-hook 'eldoc-mode)

          (add-hook 'cider-repl-mode-hook 'paredit-mode)
          (add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)
          (add-hook 'cider-repl-mode-hook 'eldoc-mode)

          (setq nrepl-buffer-name-show-port t)
          (setq nrepl-log-messages t))
  :bind (("C-c i" . cider-inspect-last-result)
         ("C-c C-v" . pprint)))

(use-package clojure-mode-extra-font-locking)
(use-package clj-refactor
  :init (progn
          (add-hook 'clojure-mode-hook (lambda ()
                                        (clj-refactor-mode 1)
                                        (cljr-add-keybindings-with-prefix "C-c r")))))
;; (use-package cider-decompile)


(use-package yasnippet
  :init
  (yas-global-mode 1))

(use-package projectile
  :init (projectile-global-mode))


(use-package company
  :init (global-company-mode))

;; (use-package company-web)

;;(push "~/.emacs.d/lisp" load-path)
(use-package org
  :load-path "lisp/org"
  :config (progn
            (org-babel-do-load-languages 'org-babel-load-languages
                                         '((clojure . t)
                                           (sh . t)
                                           (emacs-lisp . t)))
            (setq org-confirm-babel-evaluate nil)
            (setq org-babel-clojure-backend 'cider)))

(use-package dockerfile-mode)
(use-package markdown-mode)
(use-package groovy-mode
  :config
  (setq groovy-indent-offset 2))

;; (use-package js2-mode
;;   :config
;;   (progn
;;     (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;;     (add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js2-jsx-mode))
;;     (add-to-list 'interpreter-mode-alist '("node" . js2-jsx-mode))))

;; (use-package nodejs-repl
;;   :config (progn
;;             (add-hook 'js-mode-hook
;;                       (lambda ()
;;                         (define-key js-mode-map (kbd "C-x C-e") 'nodejs-repl-send-last-sexp)
;;                         (define-key js-mode-map (kbd "C-c C-r") 'nodejs-repl-send-region)
;;                         (define-key js-mode-map (kbd "C-c C-l") 'nodejs-repl-load-file)
;;                         (define-key js-mode-map (kbd "C-c C-z") 'nodejs-repl-switch-to-repl)))))

(use-package json-mode
  :config (progn
            (setq js-indent-level 2)))

(use-package restclient)

(use-package web-mode
  :init
  (progn
    (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.js*\\'" . web-mode))
    ;;(web-mode-set-content-type "jsx")
    )
  :config
  (progn
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-css-indent-offset 2)

    (setq web-mode-engine-detection t)
    (setq web-mode-enable-auto-pairing t)
    (setq web-mode-enable-auto-indenting nil)
    (setq web-mode-enable-css-colorization t)

    ;;(setq web-mode-enable-current-element-highlight nil)

    ;;(setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
    ;;(setq web-mode-engines-alist       '(("reactjs"  . "\\.js[x]?\\'")))
    ))

(use-package hideshow
  :bind (("C-c h" . hs-toggle-hiding)
         ("C-c C-h" . hs-show-all)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (smart-mode-line-dark)))
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(package-selected-packages
   (quote
    (json-mode smart-mode-line-powerline-theme restclient paredit-everywhere js2-mode markdown-mode nodejs-repl cider-decompile clj-refactor dockerfile-mode company-web company projectile clojure-mode-extra-font-locking cider rainbow-delimiters paredit smart-mode-line alert use-package))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



(defun reload ()
  (interactive)
  (find-alternate-file buffer-file-name))
