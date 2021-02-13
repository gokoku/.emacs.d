;;; フレームの大きさをインタラクティブに変更する関数
;;;   [C-;] move other frame (if one frame then make frame)
;;;   [C-,] frame width -> narrow
;;;   [C-.] frame width -> wide
;;;   [C-<] frame height -> decrease
;;;   [C->] frame height -> increase

;; Move frame if one frame then make frame
(defun current-frame-left ()                 ; get current left value
  (cdr (assoc 'left (car (cdr (car (cdr (current-frame-configuration))))))))

(defun other-frame-or-make ()
  (interactive)
  (let ((my-frame (selected-frame)))
    (if (eq 1 (length (frame-list)))
  (make-frame
   (list (cons 'left (+ (current-frame-left) (* 5 (frame-width))))))
      (other-frame 1))))

(global-set-key (kbd "C-;") 'other-frame-or-make)

;; Delete current frame
(global-set-key (kbd "C-M-;") 'delete-frame)

;; Frame width height controll by key
(defun frame-width-wide ()
  (interactive)
  (let ((width (frame-width)))
    (modify-frame-parameters
     nil (list (cons 'width (+ 5 width))))
    (message "frame-width: %d" (frame-width))))

(defun frame-width-narrow ()
  (interactive)
  (let ((width (frame-width)))
    (modify-frame-parameters
     nil (list (cons 'width (- width 5))))
    (message "frame-width: %d" (frame-width))))

(defun frame-height-wide ()
  (interactive)
  (let ((height (frame-height)))
    (modify-frame-parameters
     nil (list (cons 'height (+ 5 height))))
    (message "frame-height: %d" (frame-height))))

(defun frame-height-narrow ()
  (interactive)
  (let ((height (frame-height)))
    (modify-frame-parameters
     nil (list (cons 'height (- height 5))))
    (message "frame-height: %d" (frame-height))))

(global-set-key (kbd "C-.") 'frame-width-wide)
(global-set-key (kbd "C-,") 'frame-width-narrow)
(global-set-key (kbd "C->") 'frame-height-wide)
(global-set-key (kbd "C-<") 'frame-height-narrow)


(provide 'my-tool-window-resize)
