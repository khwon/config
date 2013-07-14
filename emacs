;; .emacs
(add-to-list 'load-path "~/.emacs.d/")

;; emacs 24 workaround
(setq stack-trace-on-error t)

;; close scratch buffer
(kill-buffer "*scratch*")

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
(setq require-final-newline 'query)

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)

;; do not make backup files
(setq make-backup-files nil)
;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

(require 'xcscope)

;; Auto font lock mode
(defvar font-lock-auto-mode-list
  (list 'c-mode 'c++-mode 'c++-c-mode 'emacs-lisp-mode 'whizbang-mode 'lisp-mode 'perl-mode 'scheme-mode)
  "List of modes to always start in font-lock-mode")

;; color theme like vim
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(background dark)
 '(cscope-file-face ((((class color) (background light)) (:foreground "#ff55ff"))))
 '(cscope-function-face ((((class color) (background light)) (:foreground "SkyBlue"))))
 '(cscope-line-face ((((class color) (background light)) (:foreground "white" :weight bold))))
 '(cscope-line-number-face ((((class color) (background light)) (:foreground "#ffff00"))))
 '(ecb-analyse-bucket-element-face ((((class color) (background light)) (:inherit ecb-analyse-general-face :foreground "#87ff87"))))
 '(font-lock-builtin-face ((((class color) (background dark)) (:foreground "Turquoise"))))
 '(font-lock-comment-delimiter-face ((t (:bold t :foreground "#55ffff"))))
 '(font-lock-comment-face ((t (:bold t :foreground "#55ffff"))))
 '(font-lock-constant-face ((t (:foreground "color-2"))))
 '(font-lock-doc-string-face ((t (:foreground "green2"))))
 '(font-lock-function-name-face ((t (:foreground "SkyBlue"))))
 '(font-lock-keyword-face ((t (:bold t :foreground "Yellow"))))
 '(font-lock-negation-char-face ((t (:bold t :foreground "#ff55ff"))))
 '(font-lock-preprocessor-face ((t (:bold t :italic nil :foreground "#5555ff"))))
 '(font-lock-reference-face ((t (:foreground "DodgerBlue"))))
 '(font-lock-string-face ((t (:bold t :foreground "#ff55ff"))))
 '(font-lock-type-face ((t (:foreground "#55ff55"))))
 '(font-lock-variable-name-face ((t (:bold t :foreground "color-172"))))
 '(header-line ((t (:background "#303030"))))
 '(hl-line ((t (:background "#303030"))))
 '(linum ((t (:foreground "#ffff00"))))
 '(minibuffer-prompt ((t (:foreground "color-209"))))
 '(semantic-decoration-on-private-members-face ((((class color) (background light)) (:background "#202020"))))
 '(semantic-highlight-func-current-tag-face ((t (:background "#303030"))))
 '(which-func ((t (:background "#303030" :foreground "SkyBlue")))))

;; color for numbers
(add-hook 'after-change-major-mode-hook
		  '(lambda () 
			 (unless (string-match "*" (buffer-name) )
			   (font-lock-add-keywords 
						nil 
						'(("\\([0-9]+\\)" 1 font-lock-string-face))
						))
			 (unless (string-match "*" (buffer-name) )
				(hl-line-mode 1))
))

;; highlight FIXME and TODO
(require 'fic-mode)
(defun add-something-to-mode-hooks (mode-list something)
  "helper function to add a callback to multiple hooks"
  (dolist (mode mode-list)
	(add-hook (intern (concat (symbol-name mode) "-mode-hook")) something)))

(add-something-to-mode-hooks '(c++ tcl emacs-lisp) 'turn-on-fic-mode)

;; kill completion buffer after completion

(add-hook 'minibuffer-exit-hook 
	  '(lambda ()
	     (let ((buffer "*Completions*"))
	       (and (get-buffer buffer)
		    (kill-buffer buffer)))))

;; ========== Place Backup Files in Specific Directory ==========

;; Enable backup files.
(setq make-backup-files t)

;; Enable versioning with default values (keep five last versions, I think!)
(setq version-control t)

;; Save all backup file in this directory.
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))

;; better buffer switch
(iswitchb-mode 1)

;; disable menubar
(menu-bar-mode -1)

;; load line number
;;; linum-off.el --- Provides an interface for turning line-numbering off
;;; ;; 
;;; ;; Filename: linum-off.el
;;; ;; Description: 
;;; ;; Author: Matthew L. Fidler, Florian Adamsky (see wiki)
;;; ;; Maintainer: Matthew L. Fidler
;;; ;; Created: Mon Sep 20 08:50:07 2010 (-0500)
;;; ;; Version: 0.1
;;; ;; Last-Updated: Wed Jul 27 01:45:27 2011 (+0900)
;;; ;;           By: Nos
;;; ;;     Update #: 43
;;; ;; URL:  http://www.emacswiki.org/emacs/auto-indent-mode.el 
;;; ;; Keywords: Line Numbering
;;; ;; Compatibility: Unknown.
;;; ;; 
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'linum+)
(global-linum-mode 1)
(defcustom linum-disabled-modes-list '(eshell-mode wl-summary-mode compilation-mode org-mode text-mode dired-mode)
		   "* List of modes disabled when global linum mode is on"
		   :type '(repeat (sexp :tag "Major mode"))
		   :tag " Major modes where linum is disabled: "
		   :group 'linum
		   )
(defcustom linum-disable-starred-buffers 't
		   "* Disable buffers that have stars in them like *Gnu Emacs*"
		   :type 'boolean
		   :group 'linum)

(defun linum-on ()
  "* When linum is running globally, disable line number in modes defined in inum-disabled-modes-list'. Changed by linum-off. Also turns off numbering in starred modes like *scratch*"

  (unless (or (minibufferp) (member major-mode linum-disabled-modes-list)
			  (and linum-disable-starred-buffers (string-match "*" (buffer-name)))
			  )
	(linum-mode 1)))


; cedet

(load-file "~/.emacs.d/cedet-1.1/common/cedet.el")
(global-ede-mode 1)
(semantic-load-enable-excessive-code-helpers)
(require 'semantic-ia)
(require 'semantic-gcc)
;(defun my-c-mode-cedet-hook ()
;   (local-set-key "." 'semantic-complete-self-insert)
;    (local-set-key ">" 'semantic-complete-self-insert))
;(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)

(require 'speedbar)
(speedbar 1)

;ecb

(add-to-list 'load-path "~/.emacs.d/ecb-snap/")
(require 'ecb)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40"))
(setq ecb-windows-width 30)
(ecb-layout-define "my-own-layout" left nil
				   ;; The frame is already splitted side-by-side and point stays in the
				   ;; left window (= the ECB-tree-window-column)

				   ;; Here is the creation code for the new layout

				   ;; 1. Defining the current window/buffer as ECB-analyse buffer
				   (ecb-set-analyse-buffer)
				   ;; 2. Splitting the ECB-tree-windows-column in two windows
				   (ecb-split-ver 0.5 t)
				   ;; 3. Go to the second window
				   (other-window 1)
				   ;; 4. Defining the current window/buffer as ECB-methods buffer
				   (ecb-set-methods-buffer)
				   ;; 5. Make the ECB-edit-window current (see Postcondition above)
				   (select-window (next-window)))

(setq ecb-layout-name "my-own-layout")
(ecb-activate)

(add-to-list 'load-path "~/.emacs.d/evil")
(setq evil-want-C-u-scroll t)
(require 'evil)  
(evil-define-keymap evil-esc-map :intercept nil) ; do not interpret ESC as meta
(evil-ex-define-cmd "A" 'ff-find-other-file) ; :A to switch between header and source
(define-key evil-insert-state-map (kbd "ESC") 'evil-normal-state)
(define-key evil-visual-state-map (kbd "ESC") 'evil-normal-state)
(define-key evil-replace-state-map (kbd "ESC") 'evil-normal-state)
(define-key evil-operator-state-map (kbd "ESC") 'evil-normal-state)
(define-key evil-motion-state-map (kbd "ESC") 'evil-normal-state)
(evil-mode 1)

(add-to-list 'load-path "~/.emacs.d/auto-complete-1.3.1/")
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete-1.3.1/dict/")
(setq ac-auto-start 2)
;; dirty fix for having AC everywhere
(define-globalized-minor-mode real-global-auto-complete-mode
							  auto-complete-mode (lambda ()
												   (if (not (minibufferp (current-buffer)))
													 (auto-complete-mode 1))
												   ))
(real-global-auto-complete-mode t)



(defun my-cancel-and-esc ()
  (interactive)
  (ac-stop)
  (evil-normal-state)
  )
(define-key ac-completing-map (kbd "ESC") 'my-cancel-and-esc)


(defun my-ac-c-mode ()
  (setq ac-sources '(ac-source-semantic ac-source-words-in-same-mode-buffers)))

(add-hook 'c-mode-common-hook 'my-ac-c-mode)

(defun build-tags (dir-name)
    "Build TAGS file."
	(interactive "DDirectory: ")
	(shell-command
	  (format "ctags -f %s/TAGS -e -R %s" dir-name (directory-file-name dir-name))))

(setq default-tab-width 2)

(require 'ido)

(require 'find-file-in-project)
(setl ffip-regexp ".*")

(require 'ruby-end)
;(require 'prelude-programming)
;(require 'prelude-ruby)
(add-hook 'ruby-mode-hook (lambda () (ruby-end-mode t)))
;(require 'ruby-electric)
;(add-hook 'ruby-mode-hook (lambda () (ruby-electric-mode t)))
