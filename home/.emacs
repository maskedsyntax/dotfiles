;;; ~/.emacs.d/init.el - A minimal starter config for a VSCode user

;; Disable the startup message
(setq inhibit-startup-message t)

;; Disable the menu bar, tool bar, and scroll bar for a cleaner look.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Show line numbers in the margin (like VSCode)
(global-display-line-numbers-mode 1)

;; Enable column numbers in the mode line
(column-number-mode 1)

;; Cursor configuration - Thin bar cursor
(setq-default cursor-type 'bar)
(blink-cursor-mode 1)

;; Font configuration
(set-face-attribute 'default nil :font "SF Mono" :height 120)

;; Make sure we can use `package`
(require 'package)

;; Add the MELPA package repository
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Initialize the package system
(package-initialize)

;; Refresh the package list if we haven't already
(unless package-archive-contents
  (package-refresh-contents))

;; Install `use-package` if it's not installed.
;; This is a macro that simplifies package management.
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Configure `use-package` to always ensure packages are installed.
(require 'use-package)
(setq use-package-always-ensure t)

;; Use `use-package` to install and configure a theme
(use-package doom-themes
  :config
  ;; Load the doom-ir-black theme by default
  (load-theme 'doom-ir-black t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Corrects (and improves) org-mode's native fontification
  (doom-themes-org-config))

;; Easy theme switcher
(use-package counsel
  :config
  (global-set-key (kbd "M-s t") 'counsel-load-theme))

;; Install and configure the "Which Key" package.
;; This is a MUST-HAVE for beginners. It shows you available keybindings as you start a prefix command.
(use-package which-key
  :config
  (which-key-mode))

;; Package for moving lines up/down
(use-package move-text
  :config
  (move-text-default-bindings))

;; Project management (for project-wide search/replace)
(use-package projectile
  :config
  (projectile-mode +1))

;; VSCode-like keybindings
(global-set-key (kbd "C-S-c") 'kill-ring-save)          ; Copy
(global-set-key (kbd "C-S-v") 'yank)                    ; Paste
(global-set-key (kbd "C-S-x") 'kill-region)             ; Cut
(global-set-key (kbd "C-s") 'save-buffer)             ; Save
(global-set-key (kbd "C-a") 'mark-whole-buffer)       ; Select all
(global-set-key (kbd "C-f") 'isearch-forward)         ; Search in file
(global-set-key (kbd "C-r") 'query-replace)           ; Replace
(global-set-key (kbd "C-z") 'undo)                    ; Undo

;; Move lines up/down
(global-set-key (kbd "M-<up>") 'move-text-up)
(global-set-key (kbd "M-<down>") 'move-text-down)

;; Project search (like VSCode's Ctrl+Shift+F)
(global-set-key (kbd "C-S-f") 'projectile-find-file)  ; Search files in project
(global-set-key (kbd "C-S-r") 'projectile-replace)    ; Replace in project

;; File navigation (VSCode's Ctrl+P equivalent)
(global-set-key (kbd "C-p") 'counsel-find-file)       ; Quick file open

;; Search configuration
(setq case-fold-search t)                    ; Case insensitive by default
(setq isearch-case-fold-search t)           ; Smart case for incremental search
(setq isearch-allow-scroll t)               ; Allow scrolling during search

;; Enhanced search with match counter
(use-package anzu
  :config
  (global-anzu-mode +1)
  (global-set-key (kbd "M-%") 'anzu-query-replace)  ; Better replace UI
  (global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(projectile move-text counsel which-key doom-themes)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
