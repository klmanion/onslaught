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
    (init-field [parent #f] [controller #f]
                [stride 0] [health 0] [damage 0]
                [pos-x #f] [pos-y #f] [height #f] [width #f] [facing #f]
                [on-draw #f] [on-collision #f]
                [keystate-triggers '()])
    (field [cull? #f])

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

    (define/public draw
      (λ (dc)
        (on-draw dc)
        (send controller entity-lst-cull)))

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
          (set! facing dir)
          (send controller check-collisions))
        (unless (null? rst)
          (send/apply this move rst))))

    (define/public collides-with?
      (λ (e)
        (let ([x0 pos-x] [y0 pos-y] [w0 width] [h0 height]
              [x1 (get-field pos-x e)] [y1 (get-field pos-y e)]
              [w1 (get-field width e)] [h1 (get-field height e)])
          (or
            (and (<= x0 x1) (<= x1 (+ x1 w0))
                 (<= y0 y1) (<= y1 (+ y0 h0)))
            (and (<= x1 x0) (<= x0 (+ x1 w1))
                 (<= y1 y0) (<= y0 (+ y1 h1)))))))

    (define/public collision
      (λ (e)
        (when on-collision
          (on-collision e))))

    (define/public hurt
      (λ (n)
        (set! health (- health n)) ; TODO add game over
        (when (<= health 0)
          (printf "~a\n" "game over"))))))

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
