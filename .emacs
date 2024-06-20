; prefer new .el file over .elc
(setq load-prefer-newer t)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Automatically install packages if not present
(when (not package-archive-contents)
  (package-refresh-contents))
(defvar my-packages
  '(material-theme
    auto-complete
    iedit
    yasnippet
    clang-format
    magit
    quelpa
    markdown-mode
    ivy
    swiper
    counsel
    elpy))
(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-refresh-contents)
	    (package-install package)))
      my-packages)

;; fd1a8c5 still has the name "bazel-mode", we should upgrade to Emacs 28
;; Also need to change `quelpa.el`'s `--unshallow` to `--depth=10000` for thing
;; to download normally
(quelpa '(bazel-mode :repo "bazelbuild/emacs-bazel-mode" :fetcher github :commit "fd1a8c5"))

;; ---- ivy config begin ----
;; https://github.com/abo-abo/swiper
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)

(setq ivy-wrap t)
;; (setq ivy-display-style 'fancy)
		     
(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "M-y") 'counsel-yank-pop)
(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "C-c C-r") 'ivy-resume)

(define-key ivy-minibuffer-map (kbd "TAB") 'ivy-next-line-and-call)

;; auto minibuffer height
;; (defun ivy-resize--minibuffer-setup-hook ()
;;   "Minibuffer setup hook."
;;   (add-hook 'post-command-hook #'ivy-resize--post-command-hook nil t))
;; (defun ivy-resize--post-command-hook ()
;;   "Hook run every command in minibuffer."
;;   (when ivy-mode
;;     (shrink-window (1+ ivy-height))))  ; Plus 1 for the input field.
;; (add-hook 'minibuffer-setup-hook 'ivy-resize--minibuffer-setup-hook)

(setq ivy-re-builders-alist
      '((t . ivy--regex-fuzzy)))
;; hack for regex-fuzzy to support space
(defvar noct--original-ivy-regex-function nil)
(defun noct-ivy-space-switch-to-regex ()
  (interactive)
  (unless (eq ivy--regex-function 'ivy--regex-plus)
    (setq ivy--old-re nil)
    (setq noct--original-ivy-regex-function ivy--regex-function)
    (setq ivy--regex-function 'ivy--regex-plus))
  (self-insert-command 1))
(define-key ivy-minibuffer-map (kbd "SPC") #'noct-ivy-space-switch-to-regex)
(defun noct-ivy-maybe-reset-regex-function ()
  (interactive)
  (let ((input (replace-regexp-in-string "\n.*" "" (minibuffer-contents))))
    (when (and noct--original-ivy-regex-function
               (not (string-match " " input)))
      (setq ivy--old-re nil)
      (setq ivy--regex-function noct--original-ivy-regex-function)
      (setq noct--original-ivy-regex-function nil))))
(advice-add 'ivy-backward-delete-char :after #'noct-ivy-maybe-reset-regex-function)
(advice-add 'ivy-delete-char :after #'noct-ivy-maybe-reset-regex-function)
;; ---- ivy config end ----

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

(require 'yasnippet)
(yas-global-mode 1)

; Fix iedit bug in Mac
(define-key global-map (kbd "C-c ;") 'iedit-mode)

;; config magit
(global-set-key (kbd "C-x g") 'magit-status)

;; configure clang-format on save.
(require 'clang-format)
;; somehow (setq clang-format-style "google") does not work, have to
;; pass in that argument through clang-format-buffer
;;
;; Note: `nil 'local` must present, otherwise, clang-format is added
;; to before-save-hook for all buffers without checking major mode.
;; (defun clang-format-on-save ()
;;   (add-hook 'before-save-hook (lambda () (clang-format-buffer "google" ".clang-format")) nil 'local))

;; clang-format -style=llvm -dump-config > .clang-format
(defun clang-format-on-save ()
  (add-hook 'before-save-hook (lambda () (clang-format-buffer)) nil 'local))
(add-hook 'c++-mode-hook 'clang-format-on-save)
(add-hook 'c-mode-hook 'clang-format-on-save)

;; bazel BUILD file auto format
(add-to-list 'auto-mode-alist '("BUILD\\'" . bazel-mode))
(add-hook 'bazel-mode-hook (lambda () (add-hook 'before-save-hook #'bazel-format nil t)))

;; Python development settings.
(elpy-enable)
;; Use python3 for elpy
(setq elpy-rpc-python-command "python3")
(setq python-shell-interpreter "python3")

;; Configure Company
(require 'company)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)

;; Common settings.
(load-theme 'material t)
(show-paren-mode 1)

;; Put backup and auto-save files in a central place. It puts everything in $TMPDIR.
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(material-theme magit iedit elpy clang-format auto-complete)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
