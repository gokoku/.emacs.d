;;;
;;; ウィンドウの中でスプリットしてもしスプリットしてあったらトグルで行き来出来る関数
;;;   [C-t] move other window (if one window then split window)
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p) (split-window-horizontally))
  (other-window 1))
(global-set-key (kbd "C-t") 'other-window-or-split)
;; キーマップ上書き専用マイナーモードを用意して強制的にキーバインドする
(define-minor-mode overriding-minor-mode
  "強制的にC-tを割り当てる"
  t                     ; デフォルトで有効
  ""                    ; モードラインに表示しない
  `((,(kbd "C-t") . other-window-or-split)))



(provide 'my-tool-split-window)
