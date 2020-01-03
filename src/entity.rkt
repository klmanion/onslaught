;;;; entity
;;

#lang racket/base

(require racket/class
         racket/gui/base
         racket/function)
(require "keystate.rkt")

(provide entity% (all-from-out "keystate.rkt"))

(define entity%
  (class object%
    (super-new)
    (init-field [parent #f] [stride 0] [pos-x #f] [pos-y #f] [facing #f]
                [on-draw #f]
                [keystate-triggers '()])
    (field [cull? #f])
    (field [entity-lst '()])

    ((thunk
       (when parent
         (unless facing
           (set! facing (get-field facing parent)))
         (unless pos-x
           (set! pos-x (get-field pos-x parent)))
         (unless pos-y
           (set! pos-y (get-field pos-y parent))))))

    (define/public should-cull?
      (λ ()
        cull?))

    (define/public add-entity
      (λ (e)
        (set! entity-lst (cons e entity-lst))))

    (define/public remove-entity
      (λ (e)
        (set! entity-lst (remove* (list e) entity-lst))))

    (define/public entity-lst-cull
      (λ ()
        (set! entity-lst (filter (λ (e)
                                   (not (send e should-cull?)))
                                 entity-lst))))

    (define/public draw
      (λ (dc)
        (on-draw dc)
        (entity-lst-cull)
        (for-each (λ (e)
                    (send e draw dc))
                  entity-lst)))

    (define/private pos-x-set!
      (λ (val)
        (set! pos-x val)))

    (define/private pos-y-set!
      (λ (val)
        (set! pos-y val)))

    (define/public move
      (λ (symb . rst)
        (let ([dir (cond [(eq? symb 'facing) facing]
                         [else symb])])
          (case dir
            [(UL) (move 'U 'L)]
            [(U)  (pos-y-set! (- pos-y stride))]
            [(UR) (move 'U 'R)]
            [(L)  (pos-x-set! (- pos-x stride))]
            [(R)  (pos-x-set! (+ pos-x stride))]
            [(DL) (move 'D 'L)]
            [(D)  (pos-y-set! (+ pos-y stride))]
            [(DR) (move 'D 'R)])
          (set! facing dir))
        (unless (null? rst)
          (send/apply this move rst))))))

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
