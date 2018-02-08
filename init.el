(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(menu-bar-mode -1)
(defun meetup ()
  (interactive)
  (message "Hello, Austin Emacs Meetup!!!!!"))

