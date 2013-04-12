; Backspace wasn't working
;(global-set-key (kbd "C-h") 'delete-backward-char)

; TABS UGH!
;(global-set-key "\t" 'self-insert-command)
;(setq tab-width 2) 
(setq inferior-lisp-program "/usr/bin/sbcl") ; your Lisp system
(add-to-list 'load-path "/home/zero/code/LISP/slime-2013-04-02")  ; your SLIME directory
(require 'slime)
(slime-setup)

(defun open-ibuffer ()
  (interactive)
  (split-window-below)
  (other-window 1)
  (ibuffer)
  (shrink-window-if-larger-than-buffer))
(global-set-key (kbd "C-x C-b") 'open-ibuffer)


;;; IBuffer -- add any file to a filter group. still needs work
(defun ibuffer-buffer-to-filter-group (group-name)
  "Add buffer at point to filter-group"
  (interactive "sName of filter group to move to: ")
  (let ((filter-group (assoc group-name ibuffer-filter-groups)))
    (if filter-group
	(setf (cadr filter-group)
	      `(or (name . ,(buffer-name (ibuffer-current-buffer)))
		   ,(cadr filter-group)))
      (push `(,group-name (name . ,(buffer-name (ibuffer-current-buffer))))
	    ibuffer-filter-groups)))
  (ibuffer-update nil t))

(defun test-add-marked-buffers-to-filter-group (group-name)
  (interactive "sName of filter group to add to: ")
  (push `(,group-name ,(macroexpand `(my-or ,(gen-qualifiers (ibuffer-get-marked-buffers))))) 
		ibuffer-filter-groups)
  (ibuffer-update nil t))

; Have to manually eval-last-sexp this
(defmacro my-or (qualifiers)
		 `(or ,@qualifiers))

; doesn't work:
(defun ibuffer-add-marked-buffers-to-filter-group (group-name)
  (interactive "sName of filter group to move to: ")
  (let ((filter-group (assoc group-name ibuffer-filter-groups)))
    (if filter-group
	(dolist (marked-buffer (ibuffer-get-marked-buffers))
	  (setf (cadr filter-group)
		`(or (name . ,(buffer-name marked-buffer))
		     ,(cadr filter-group))))
      (dolist (marked-buffer (ibuffer-get-marked-buffers))
	(push `(,group-name (name . ,(buffer-name marked-buffer)))
		ibuffer-filter-groups))))
  (ibuffer-update nil t))


(add-hook `ibuffer-mode-hook
	  `(lambda ()
	     (progn
	       (define-key ibuffer-mode-map "a" `ibuffer-buffer-to-filter-group)
	       (setq ibuffer-auto-mode 1))))

(defun clear-shell ()
  (interactive)
  (progn (setq comint-buffer-maximum-size 0)
	 (comint-truncate-buffer)))

(global-set-key (kbd "C-c c") `clear-shell)

(tool-bar-mode -1)
(menu-bar-mode -1)

(ido-mode t)
(global-set-key (kbd "C-x C-b") 'ibuffer-other-window)
; Gtags
(setq load-path (cons "/usr/local/share/gtags/" load-path))
(autoload 'gtags-mode "gtags" "" t)

; If I want to auto load gtags-mode when in c-mode
; ow use M-x gtags-mode
;(add-hook 'c-mode-hook 
;	  '(lambda ()
;	     (gtags-mode t)))


; Speedbar!
(when window-system
  (speedbar t))

;(eval-after-load 'gtags-mode
(global-set-key (kbd "C-c d") 'gtags-find-tag)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
