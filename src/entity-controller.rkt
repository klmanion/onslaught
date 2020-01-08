;;;; entity-controller
;;

#lang racket/base

(require racket/class)

(provide entity-controller%)

(define entity-controller%
  (class object%
    (super-new)
    (field [entity-lst '()])

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
        (entity-lst-cull)
        (for-each (λ (e)
                    (send e draw dc))
                  entity-lst)))

    (define/public check-collisions
      (λ ()
        (for ([e0 (in-list entity-lst)])
          (for ([e1 (in-list (remove e0 entity-lst))])
            (when (send e0 collides-with? e1)
              (send e0 collision e1))))))))

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
