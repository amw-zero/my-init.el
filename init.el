; Backspace wasn't working
;(global-set-key (kbd "C-h") 'delete-backward-char)

; TABS UGH!
;(global-set-key "\t" 'self-insert-command)
;(setq tab-width 2) 

;; (setq inferior-lisp-program "/usr/bin/sbcl") ; your Lisp system
;; (add-to-list 'load-path "/home/zero/code/LISP/slime-2013-04-02")  ; your SLIME directory
;; (require 'slime)
;; (slime-setup)

; Multiple cursors
(add-to-list 'load-path "multiple-cursors")
(require 'multiple-cursors)
(global-set-key (kbd "C-c n") 'mc/mark-all-like-this)

;; Expand-region
(add-to-list 'load-path "expand-region.el")
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)


;;;; My Ibuffer extensions
(defun open-ibuffer ()
  (interactive)
  (split-window-below)
  (other-window 1)
  (ibuffer)
  (shrink-window-if-larger-than-buffer))
(global-set-key (kbd "C-x C-b") 'open-ibuffer)

;; Collapse all buffer groups
(defun ibuffer-toggle-all-filter-groups ()
  "Toggle the display status of all filter groups"
  (interactive)
  (setq ibuffer-hidden-filter-groups 
        (loop for group in (ibuffer-current-filter-groups-with-position)
	      collect (car group)))
  (ibuffer-update nil t))

(defun push-to-filter-group (group-name buffer-list)
  (push `(,group-name ,(macroexpand `(multi-or ,buffer-list)))
	ibuffer-filter-groups))

(defun add-to-filter-group (group-name buffer-list)
  (let ((filter-group (assoc group-name ibuffer-filter-groups)))
    (if filter-group
	(if (string= "or" (caadr filter-group))
	    (setf (cadr filter-group)
		  (macroexpand `(multi-or ,(append (cdadr filter-group) buffer-list))))
	    (setf (cadr filter-group)
		  (macroexpand `(multi-or ,(append (list (cadr filter-group)) buffer-list)))))
      (push-to-filter-group group-name buffer-list))))

(defun ibuffer-marked-buffers-to-filter-group (group-name)
  "Add all marked buffers to a filter-group"
  (interactive "sName of filter group to add to: ")
  (add-to-filter-group group-name (gen-qualifiers (ibuffer-get-marked-buffers)))
  (ibuffer-unmark-all ibuffer-marked-char)
  (ibuffer-update nil t))

(defun gen-qualifiers (buffers)
  (loop for buf in buffers
	collect (cons 'name (buffer-name buf))))

; Have to manually eval-last-sexp this
(defmacro multi-or (qualifiers)
		 `(or ,@qualifiers))

(add-hook `ibuffer-mode-hook
	  `(lambda ()
	     (progn
	       (define-key ibuffer-mode-map "a" `ibuffer-buffer-to-filter-group)
	       (define-key ibuffer-mode-map "+" `ibuffer-marked-buffers-to-filter-group)
	       (define-key ibuffer-mode-map "-" `ibuffer-toggle-all-filter-groups)
	       (setq ibuffer-auto-mode 1))))

(defun test-ibuffer ()
  (ibuffer-mode)
  (print "Hi"))

(defun clear-shell ()
  (interactive)
  (progn (setq comint-buffer-maximum-size 0)
	 (comint-truncate-buffer)))

(global-set-key (kbd "C-c c") `clear-shell)

(tool-bar-mode -1)
(menu-bar-mode -1)

; ido mode. So necessary
(ido-mode t)

;(global-set-key (kbd "C-x C-b") 'ibuffer-other-window)
; Gtags
(setq load-path (cons "/usr/local/share/gtags/" load-path))
(autoload 'gtags-mode "gtags" "" t)

; If I want to auto load gtags-mode when in c-mode
; ow use M-x gtags-mode
;(add-hook 'c-mode-hook 
;	  '(lambda ()
;	     (gtags-mode t)))


; Speedbar!
;(when window-system
;  (speedbar t))

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
(put 'narrow-to-region 'disabled nil)
