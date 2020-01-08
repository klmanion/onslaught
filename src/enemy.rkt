;;;; enemy
;;

#lang racket/base

(require racket/class
         racket/gui/base
         racket/draw
         racket/function)
(require "entity.rkt")

(provide enemy%)

(define enemy%
  (class entity%
    (inherit-field pos-x pos-y width height)
    (super-new [pos-x 50] [pos-y 50] [width 5] [height 5]
               [on-draw (λ (dc)
                          (send dc set-pen (make-color #xFF #x0 #x0) 1 'solid)
                          (send dc set-brush (make-color #xFF #x0 #x0) 'solid)
                          (send dc draw-ellipse pos-x pos-y width height))]
               [on-collision (λ (e)
                               (send e hurt (get-field damage this)))]
               [damage 1])
    (init-field [wave 0])))
 

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
