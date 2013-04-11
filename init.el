; Backspace wasn't working
;(global-set-key (kbd "C-h") 'delete-backward-char)

; TABS UGH!
;(global-set-key "\t" 'self-insert-command)
;(setq tab-width 2) 
(setq inferior-lisp-program "/usr/bin/sbcl") ; your Lisp system
(add-to-list 'load-path "/home/zero/code/LISP/slime-2013-04-02")  ; your SLIME directory
(require 'slime)
(slime-setup)


;;; IBuffer -- add any file to a filter group. still needs work

; Can add any file to Current filter group
; however, I don't like the (or ... (or ... (or ... ))) thing. 
; There should be a better way to do this.
(defun test-add-to-current-filter-group ()
  (interactive)
  (if (string= "Current" (caar ibuffer-filter-groups))
	  (setf (nth 1 (car ibuffer-filter-groups)) `(or (name . ,(buffer-name (ibuffer-current-buffer))) 
													 ,(cadr (assoc "Current" ibuffer-filter-groups))))
	  (push `("Current" (name . ,(buffer-name (ibuffer-current-buffer)))) ibuffer-filter-groups))
  (ibuffer-update nil t))

(global-set-key (kbd "C-c A") `test-add-to-current-filter-group)

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
