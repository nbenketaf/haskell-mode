;;; haskell-presentation-mode.el --- Presenting Haskell things

;; Copyright (C) 2013  Chris Done

;; Author: Chris Done <chrisdone@gmail.com>

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;;; Code:

(require 'haskell-mode)
(require 'haskell-session)

(define-derived-mode haskell-presentation-mode
  haskell-mode "Presentation"
  "Major mode for viewing Haskell snippets.
          \\{hypertext-mode-map}"
  (setq case-fold-search nil))

(defconst haskell-present-buffer-name
  "*Haskell Presentation*"
  "Haskell Presentation buffer name.")

(defconst haskell-present-hint-message
  "-- Hit `q' to close this window; `c' to clear.\n\n"
  "Hint message appered in Haskell Presentation buffer.")

(define-key haskell-presentation-mode-map (kbd "q") #'quit-window)
(define-key haskell-presentation-mode-map (kbd "c") #'haskell-present-clear)

(defun haskell-present-clear ()
  "Clear Haskell Presentation buffer."
  (interactive)
  (let ((hp-buf (get-buffer haskell-present-buffer-name)))
    (when hp-buf
      (with-current-buffer hp-buf
        (let ((buffer-read-only nil))
          (erase-buffer)
          (insert haskell-present-hint-message))))))

(defun haskell-present (session code &optional clear)
  "Present given code in a popup buffer.
Creates temporal Haskell Presentation buffer and assigns it to
given haskell SESSION; presented CODE will be fontified as
haskell code.  Give an optional non-nil CLEAR arg to clear the
buffer before presenting message."
  (let ((buffer (get-buffer-create haskell-present-buffer-name)))
    (with-current-buffer buffer
      (haskell-presentation-mode)

      (when (boundp 'shm-display-quarantine)
        (set (make-local-variable 'shm-display-quarantine) nil))

      (when clear (haskell-present-clear))
      (haskell-session-assign session)
      (save-excursion
        (let ((buffer-read-only nil))
          (goto-char (point-min))
          (forward-line 2)
          (insert code "\n\n")))

      (if (eq major-mode 'haskell-presentation-mode)
          (switch-to-buffer buffer)
        (pop-to-buffer buffer)))))

(provide 'haskell-presentation-mode)

;;; haskell-presentation-mode.el ends here
