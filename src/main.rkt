;;;; main
;;

#lang racket/base

(require racket/class "delegate.rkt")

(define delegate (new delegate%))
         
(module+ main
  (send delegate start))

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
