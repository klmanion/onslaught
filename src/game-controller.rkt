;;;; game-controller
;;

#lang racket/base

(require racket/class
         racket/gui/base
         racket/function)

(provide game-controller%)

(define game-controller%
  (class object%
    (super-new)))

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
