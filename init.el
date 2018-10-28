(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/"))

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

;; removing the --x509cafile
(set-variable 'tls-program
              '("gnutls-cli -p %p %h"
                "gnutls-cli  -p %p %h --protocols ssl3"
                "openssl s_client -connect %h:%p -no_ssl2 -ign_eof"))

;; or maybe this ?
;; (set-variable 'tls-program '("gnutls-cli --x509cafile %t -p %p %h" "gnutls-cli --x509cafile %t -p %p %h --protocols ssl3" "openssl s_client -connect %h:%p -servername %h -no_ssl2 -ign_eof"))


;; ----------------------------------------
;; keys

(define-key input-decode-map "\e[1;10A" [M-S-up])
(define-key input-decode-map "\e[1;10B" [M-S-down])
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
  ;;:load-path "~/dev/cider"
  ;;:load-path "/tmp/cider-20180207.2103/"
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
         ("C-c v" . pprint)))

(use-package clojure-mode-extra-font-locking)

(use-package clj-refactor
  ;;:load-path "~/dev/clj-refactor.el"
  :init (progn
	  (add-hook 'clojure-mode-hook (lambda ()
                                         (clj-refactor-mode 1)
                                         (cljr-add-keybindings-with-prefix "C-c r")))))
;; (use-package cider-decompile)

(use-package yasnippet
  :init
  (yas-global-mode 1))

;; (use-package projectile
;;   :init (projectile-mode))

(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))

(use-package company
  :init (global-company-mode))

;; (use-package company-web)

;;(push "~/.emacs.d/lisp" load-path)
  ;;:load-path "lisp/org"

  ;; :config (progn
  ;;           (org-babel-do-load-languages 'org-babel-load-languages
  ;;                                        '((clojure . t)
  ;;                                          (sh . t)
  ;;                                          (emacs-lisp . t)))
  ;;           (setq org-confirm-babel-evaluate nil)
  ;;           (setq org-babel-clojure-backend 'cider))

(use-package org
  :config
  (progn
    (require 'org-crypt)
    (org-crypt-use-before-save-magic)
    (setq org-tags-exclude-from-inheritance (quote ("crypt")))))

(use-package ox-reveal)
(use-package htmlize)

(use-package jq-mode
  :bind (("C-c C-j" . jq-interactively)))
(use-package dockerfile-mode)
(use-package markdown-mode)

(use-package groovy-mode
  :config
  (setq groovy-indent-offset 2))

(use-package json-mode
  :config (progn
            (setq js-indent-level 2)))

(use-package js2-mode)
(use-package rjsx-mode
  :config
  (progn
    (add-to-list 'auto-mode-alist '("\\.jsx?\\'" . rjsx-mode))))

(use-package js2-refactor
  :init
  (add-hook 'js2-mode-hook #'js2-refactor-mode)
  :config
  (js2r-add-keybindings-with-prefix "C-c C-m"))

(use-package yaml-mode)

(use-package restclient)

(use-package web-mode
  :init
  (progn
    (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))
  :config
  (progn
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-css-indent-offset 2)

    (setq web-mode-engine-detection t)
    (setq web-mode-enable-auto-pairing t)
    (setq web-mode-enable-auto-indenting nil)
    (setq web-mode-enable-css-colorization t)))

(use-package hideshow
  :bind (("C-c h" . hs-toggle-hiding)
         ("C-c C-h" . hs-show-all)))

(use-package css-mode
  :config
  (progn
    (setq css-indent-offset 2)))

(use-package es-mode)

(use-package magit
  ;;:bind
  ;; (("C-x g"   . magit-status) ("C-x C-g" . magit-status))
  )

(use-package speed-type)

(use-package copy-as-format)

(use-package docker)


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
    (docker copy-as-format speed-type org-crypt js2-refactor rjsx-mode yaml-mode ## htmlize with-editor magit es-mode jq-mode json-mode smart-mode-line-powerline-theme restclient paredit-everywhere js2-mode markdown-mode nodejs-repl dockerfile-mode company-web company projectile clojure-mode-extra-font-locking cider rainbow-delimiters paredit smart-mode-line alert use-package))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



(defun reload ()
  (interactive)
  (find-alternate-file buffer-file-name))

