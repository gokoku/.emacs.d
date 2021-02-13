;;; package --- Summary
;;; Commentary:
;;;
;;; Code:

;;;-----------------------------------------------------------------------

;; フレームの設定

(package-initialize)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

(require 'use-package)

(setq default-frame-alist '((width . 100) (height . 50)))
(add-to-list 'default-frame-alist (cons 'alpha 90))
(setq inhibit-startup-screen t)
(if window-system
    (progn (tool-bar-mode 0)  ;; tool-bar ツールバー非表示
           (scroll-bar-mode 0)  ;; scroll-bar スクロールバー非表示
           (menu-bar-mode t)))  ;; menu-bar メニューバー表示
(setq frame-title-format
      (format "%%f - Emacx@%s" (system-name)))

;; 日本語の設定
(set-language-environment 'Japanese)
(setq default-input-method "MacOSX")
(set-keyboard-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; フォント関係
(setq-default line-spaceing 10) ;; lineheight point
(set-face-attribute 'default nil
                    :height 110)

;; MacのUnicodeno正規化 濁点問題を統一して同じ文字として扱う
(use-package ucs-normalize
  :if (eq system-type 'darwin)
  :config
  (set-file-name-coding-system 'utf-8-hfs)
  (defvar local-coding-system 'utf-8-hfs))

;; ダイアログボックスが出るとそれ以上動かなくなるので切る
(setq use-dialog-box nil)
;; file名補完で大文字小文字を区別しない
(setq completion-ignore-case t)
;; Tab ではなくスペースを使う
(setq-default tab-width 2 indent-tabs-mode nil)
;;行番号
(global-linum-mode t)
;; カラーテーマ
(load-theme 'wombat t)
;;バッファの再読み込み バインド
(global-set-key (kbd "C-x C-r") 'revert-buffer)
;;バッファリストをibufferに置き換える.
(global-set-key (kbd "C-x C-b") 'ibuffer)
;; 折り返しトグル
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)
;; h をバックスペースにする
(global-set-key (kbd "C-h") 'delete-backward-char)

;;;-----------------------------------------------------------------------
;; 最近使ったファイルを表示する

(use-package recentf-ext
  :bind ("C-c C-f" . recentf-open-files)
  :config
  (setq recentf-max-saved-items 50
      recent-exclude '(".recentf")
      recentf-auto-cleanup 10)
  (recentf-mode 1))

;; インデントのガイド線の表示
(use-package indent-guide
  :config
  (indent-guide-global-mode))

;; カッコの中身をハイライトする
(show-paren-mode t)

;; セーブ時にバイトコンパイルする
(use-package auto-async-byte-compile
  :config
  (add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode))

;; カッコの対応を保持する
(use-package paredit
  :config
  (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
  (add-hook 'lisp-mode-hook 'enable-paredit-mode)
  (add-hook 'ielm-mode-hook 'enable-paredit-mode))


;; サーバとして起動する
(server-start)

;;;-----------------------------------------------------------------------
;; Lisp mode
(use-package slime
         :if (file-exists-p "~/.roswell/helper.el")
         :init (load (expand-file-name "~/.roswell/helper.el"))
         :config (setq inferior-lisp-program "ros -Q run"))
         

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (recentf-ext use-package slime paredit indent-guide auto-async-byte-compile))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
