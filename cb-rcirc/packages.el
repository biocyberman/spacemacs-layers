;;; packages.el --- cb-rcirc Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst cb-rcirc-packages
  '((rcirc-reconnect :location local)))

(defun cb-rcirc/init-rcirc-reconnect ()
  (use-package rcirc-reconnect
    :diminish rcirc-reconnect-mode
    :commands rcirc-reconnect-mode
    :init
    (add-hook 'rcirc-mode-hook 'rcirc-reconnect-mode)))