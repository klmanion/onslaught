;;;; game-canvas

#lang racket/base

(require racket/class
         racket/gui/base
         racket/function)
(require "model.rkt"
         "hero.rkt" "enemy.rkt"
         "keyrep.rkt"
         "entity-controller.rkt")

(provide game-canvas%)

(define game-canvas%
  (class canvas%
    (super-new [min-width 485]
               [min-height 300])
    (inherit get-dc)
    (field [keyrep (new keyrep%)]
           [timer (new timer% [notify-callback (thunk (send this refresh))]
                              [interval 42])])
    (field [hero (new hero% [pos-x 100] [pos-y 100] [facing 'R] [stride 5])])

    ((thunk
       (send keyrep load-entity hero)
       (spawn-entity hero)))

    (define/override on-paint
      (λ ()
        (let ([dc (get-dc)])
          (send* dc
                 (set-background (make-color #x0 #x0 #x0))
                 (set-smoothing 'unsmoothed)
                 (clear))
          (send keyrep check-keystates)
          (send entity-controller check-collisions)
          (send entity-controller draw dc)
          (send dc set-text-foreground (make-color #xFF #xFF #xFF))
          (send dc draw-text (format "wave: ~a" (get-field wave model))
                   420 280))))

    (define/override on-size
      (λ (width height)
        (let ([dc (get-dc)]
              [scale (min (/ width 485)
                          (/ height 300))])
          (send dc set-scale scale scale))))

    (define/override on-char
      (λ (ke)
        (send keyrep handle-key-event ke)))))

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
