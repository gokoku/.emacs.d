;;; init.el --- My init.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; My init.el.

;;; Code:

;; this enables this running method
;;   emacs -q -l ~/.debug.emacs.d/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("org"   . "https://orgmode.org/elpa/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

;;--------------------------------------------------------------
;; フレーム設定


(leaf cus-start
  :setq ((default-frame-alist quote
           ((width . 100)
            (height . 50)))
         (inhibit-startup-screen . t))
  :config
  (when window-system
    (progn
      (tool-bar-mode 0)
      (scroll-bar-mode 0)
      (menu-bar-mode t)))
  (setq frame-title-format (format "%%f - Emacx@%s"
                                   (system-name)))
  (add-to-list 'default-frame-alist (cons 'alpha 90))
  ;; カラーテーマ
  (load-theme 'wombat t)
  ;; フォント関係
  (setq-default line-spaceing 10) ;; lineheight point
  (set-face-attribute 'default nil
                      :height 110)

  ;; Tab ではなくスペースを使う
  (setq-default tab-width 2 indent-tabs-mode nil)
  ;;バッファの再読み込み バインド
  (global-set-key (kbd "C-x C-r") 'revert-buffer)
  ;;バッファリストをibufferに置き換える.
  (global-set-key (kbd "C-x C-b") 'ibuffer)
  ;; 折り返しトグル
  (define-key global-map (kbd "C-c l") 'toggle-truncate-lines)
  ;; h をバックスペースにする
  (global-set-key (kbd "C-h") 'delete-backward-char)

  :custom
  ;; 行番号
  '((global-linum-mode . t)
    ;; file名補完で大文字小文字を区別しない
    (completion-ignore-case . t)))




(leaf leaf
  :config
  
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size . 30)
	           (imenu-list-position . 'left))))

(leaf macrostep
  :ensure t
  :bind (("C-c e" . macroste-expand)))

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

;; インデントのガイド線の表示

(leaf indent-guide
  :doc "show vertical lines to guide indentation"
  :url "http://hins11.yu-yake.com/"
  :added "2021-09-07"
  :ensure t
  :require t)

(leaf paredit
  :doc "minor mode for editing parentheses"
  :tag "lisp"
  :added "2021-09-07"
  :ensure t)

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom ((auto-revert-interval . 1))
  :global-minor-mode global-auto-revert-mode)

(leaf cc-mode
  :doc "major mode for editing C and similar languages"
  :tag "builtin"
  :defvar (c-basic-offset)
  :bind (c-mode-base-map
         ("C-c c" . compile))
  :mode-hook
  (c-mode-hook . ((cset-style "bsd")
                  (setq c-basic-offset 4)))
  (c++-mode-hook . ((c-set-style "bsd")
                    (setq c-basic-offset 4))))

(leaf delsel
  :doc "delete selection if you insert"
  :tag "builtin"
  :global-minor-mode delete-selection-mode)

(leaf paren
  :doc "hightlight matching paren"
  :tag "builtin"
  :custom ((show-paren-delay . 0.1))
  :global-minor-mode show-paren-mode)

(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :blackout t
  :leaf-defer nil
  :custom ((ivy-initial-inputs-alist . nil)
           (ivy-use-selectable-prompt . t))
  :global-minor-mode t
  :config
  (leaf swiper
    :doc "Isearch with an overview. Oh, man!"
    :req "emacs-24.5" "ivy-0.13.0"
    :tag "matching" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :bind (("C-s" . swiper)))

  (leaf counsel
    :doc "Various completion functions using Ivy"
    :req "emacs-24.5" "swiper-0.13.0"
    :tag "tools" "matching" "convenience" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :blackout t
    :bind (("C-S-s" . counsel-imenu)
           ("C-x C-r" . counsel-recentf))
    :custom `((counsel-yank-pop-separator . "\n----------\n")
              (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
    :global-minor-mode t))

(leaf prescient
  :doc "Better sorting and filtering"
  :req "emacs-25.1"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :custom ((prescient-aggressive-file-save . t))
  :global-minor-mode prescient-persist-mode)

(leaf ivy-prescient
  :doc "prescient.el + Ivy"
  :req "emacs-25.1" "prescient-4.0" "ivy-0.11.0"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :after prescient ivy
  :custom ((ivy-prescient-retain-classic-highlighting . t))
  :global-minor-mode t)

(leaf flycheck
  :doc "On-the-fly syntax checking"
  :req "dash-2.12.1" "pkg-info-0.4" "let-alist-1.0.4" "seq-1.11" "emacs-24.3"
  :tag "minor-mode" "tools" "languages" "convenience" "emacs>=24.3"
  :url "http://www.flycheck.org"
  :emacs>= 24.3
  :ensure t
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error))
  :global-minor-mode global-flycheck-mode)

(leaf company
  :doc "Modular text completion framework"
  :req "emacs-24.3"
  :tag "matching" "convenience" "abbrev" "emacs>=24.3"
  :url "http://company-mode.github.io/"
  :emacs>= 24.3
  :ensure t
  :blackout t
  :leaf-defer nil
  :bind ((company-active-map
          ("M-n" . nil)
          ("M-p" . nil)
          ("C-s" . company-filter-candidates)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("<tab>" . company-complete-selection))
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)))
  :custom ((company-idle-delay . 0)
           (company-minimum-prefix-length . 1)
           (company-transformers . '(company-sort-by-occurrence)))
  :global-minor-mode global-company-mode)

(leaf company-c-headers
  :doc "Company mode backend for C/C++ header files"
  :req "emacs-24.1" "company-0.8"
  :tag "company" "development" "emacs>=24.1"
  :added "2020-03-25"
  :emacs>= 24.1
  :ensure t
  :after company
  :defvar company-backends
  :config
  (add-to-list 'company-backends 'company-c-headers))

;; (leaf hl-line
;;   :hook
;;   (emacs-startup-hook . global-hl-line-mode))


(leaf whitespace
  :doc "minor mode to visualize TAB, (HARD) SPACE, NEWLINE"
  :tag "builtin"
  :added "2021-09-07")


(leaf auto-async-byte-compile
  :hook ((emacs-lisp-mode-hook . enable-auto-async-byte-compile-mode))
  :require t)

(leaf recentf
  :doc "setup a menu of recently opened files"
  :tag "builtin"
  :added "2021-09-07"
  :custom ((recentf-save-file . "~/.emacs.d/.recentf")
           (recentf-max-saved-items . 1000)            ;; recentf に保存するファイルの数
           (recentf-exclude . '(".recentf")))           ;; .recentf自体は含まない
  :bind ("C-c C-f" . recentf-open-files)
  :require t
  )

(leaf recentf-ext
  :doc "Recentf extensions"
  :tag "files" "convenience"
  :url "http://www.emacswiki.org/cgi-bin/wiki/download/recentf-ext.el"
  :added "2021-09-07"
  :ensure t
  :require t)

;; Org mode
(leaf org-babel
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((R . t)
     (emacs-lisp . t)
     (haskell . t)
     (python . t)
     (ruby . t)
     (shell . t)
     (js . t)
     (java . t)
     (clojure . t)
     (awk . t)))
  :custom
  ((org-babel-js-cmd . "/Users/george/.asdf/shims/node")
   (org-babel-js-function-wrapper .
      "console.log(require('util').inspect(function(){\n%s\n}(), { depth: 100 }))")))

(leaf exec-path-from-shell
  :doc "Get environment variables such as $PATH from the shell"
  :req "emacs-24.1"
  :tag "environment" "unix" "emacs>=24.1"
  :added "2020-08-27"
  :url "https://github.com/purcell/exec-path-from-shell"
  :emacs>= 24.1
  :ensure t)

(provide 'init)


(exec-path-from-shell-initialize)
(server-start)
