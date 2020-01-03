;;;; enemy
;;

#lang racket/base

(require racket/class
         racket/gui/base
         racket/draw)

(provide enemy%)

(define enemy%
  (class entity%
    (inherit-field pos-x pos-y)
    (super-new [on-draw (λ (dc)
                          (send dc set-pen (make-color #xFF #x0 #x0) 1 'solid)
                          (send dc set-brush (make-color #xFF #x0 #x0) 'solid)
                          (send dc draw-ellipse pos-x pos-y 5 5))])))

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
