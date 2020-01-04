;;;; bullet
;;

#lang racket/base

(require racket/class
         racket/gui/base
         racket/draw
         racket/function)
(require "entity.rkt")

(provide bullet%)

(define bullet%
  (class entity% 
    (inherit-field pos-x pos-y)
    (super-new [stride 3] [width 3] [height 3]
               [on-draw (λ (dc)
                          (send this move 'facing)
                          (send dc set-pen (make-color #xFF #xFF #xFF) 1 'solid)
                          (send dc set-brush (make-color #xFF #xFF #xFF) 'solid)
                          (send dc draw-ellipse pos-x pos-y 3 3))])))

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
