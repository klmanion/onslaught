;;;; hero
;;

#lang racket/base

(require racket/class
         racket/gui/base
         racket/draw)
(require "entity.rkt"
         "bullet.rkt")

(provide hero%)

(define hero%
  (class entity% 
    (inherit-field pos-x pos-y)
    (super-new [on-draw (λ (dc)
                          (send dc set-pen (make-color #xFF #xFF #xFF) 1 'solid)
                          (send dc set-brush (make-color #xFF #xFF #xFF) 'solid)
                          (send dc draw-ellipse pos-x pos-y 5 5))]
               [keystate-triggers
                 (list
                   (make-keystate (list #\w) (λ ()
                                               (send this move 'U)))
                   (make-keystate (list #\s) (λ ()
                                               (send this move 'D)))
                   (make-keystate (list #\a) (λ ()
                                               (send this move 'L)))
                   (make-keystate (list #\d) (λ ()
                                               (send this move 'R)))
                   (make-keystate (list #\j) (λ ()
                                               (send this fire))))])
    (inherit add-entity)

    (define/public fire
      (λ ()
        (add-entity (new bullet% [parent this]))))))

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
