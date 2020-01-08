;;;; delegate
;;

#lang racket/base

(require racket/class
         racket/gui/base
         racket/function)
(require "game-canvas.rkt"
         "model.rkt"
         "keyrep.rkt" "keystate.rkt"
         "entity-controller.rkt"
         "hero.rkt" "enemy.rkt")

(provide delegate%)

(define delegate%
  (class object%
    (super-new)
    (field [model (new model%)])
    (field [keyrep (new keyrep%)]
           [keyrep-timer (new timer%
                              [notify-callback
                                (thunk
                                  (send keyrep check-keystates))]
                              [interval 42])])

    (field [entity-controller (new entity-controller%)])
    (field [frame (new frame% [label "onslaught"] [style '(fullscreen-button)])]
           [screen-controller (new game-canvas% [parent frame] [keyrep keyrep]
                                   [model model]
                                   [entity-controller entity-controller])])

    ((thunk
       (send keyrep load-keystates (list
                                     (new keystate% [seq (list #\space)]
                                          [callback (λ ()
                                                      (send this next-wave))]
                                          [no-hold #t])))))
    ((thunk
       (define hero (new hero% [pos-x 100] [pos-y 100] [facing 'R] [stride 5]
                         [controller entity-controller]))
       (send entity-controller add-entity hero)
       (send keyrep load-entity hero)))

    (define/public start
      (λ ()
        (send frame show #t)))

    (define/public next-wave
      (λ ()
        (send model next-wave)
        (spawn-enemy)))

    (define/private spawn-enemy
      (λ ([n 1])
        (cond [(= n 0) (void)]
              [else (send entity-controller
                          add-entity (new enemy%
                                          [wave (get-field wave model)]
                                          [controller entity-controller]))
                    (spawn-enemy (- n 1))])))))

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
