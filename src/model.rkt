;;;; model
;;

#lang racket/base

(require racket/class
         racket/gui/base
         racket/function)

(provide model% model)

(define model%
  (class object%
    (super-new)
    (field [wave 0])))

(define model (new model%))

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
