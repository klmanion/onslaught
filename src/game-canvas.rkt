;;;; game-canvas

#lang racket/base

(require racket/class
         racket/gui/base
         racket/function)
(require "defs.rkt"
         "hero.rkt" "enemy.rkt"
         "entity-controller.rkt")

(provide game-canvas%)

(define game-canvas%
  (class canvas%
    (super-new [min-width SCREEN-WIDTH]
               [min-height SCREEN-HEIGHT])
    (inherit get-dc)
    (field [timer (new timer% [notify-callback (thunk (send this refresh))]
                              [interval 42])])
    (init-field [keyrep #f] [model #f] [entity-controller #f])

    (define/override on-paint
      (λ ()
        (let ([dc (get-dc)])
          (send* dc
                 (set-background (make-color #x0 #x0 #x0))
                 (set-smoothing 'unsmoothed)
                 (clear))
          (send entity-controller check-collisions)
          (send entity-controller draw dc)
          (send dc set-text-foreground (make-color #xFF #xFF #xFF))
          (send dc draw-text (format "wave: ~a" (get-field wave model))
                   430 280))))

    (define/override on-size
      (λ (width height)
        (let ([dc (get-dc)]
              [scale (min (/ width 485)
                          (/ height 300))])
          (send dc set-scale scale scale))))

    (define/override on-char
      (λ (ke)
        (when keyrep
          (send keyrep handle-key-event ke))))))

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
