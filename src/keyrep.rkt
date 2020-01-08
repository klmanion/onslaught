;;;; keyrep
;; keyrep% must record pressed keys and release them upon release.
;; It is not an immediately triggered keymap.
;; It is only a representation of what is currently pressed
;;
;; keyrep% understands key-state% objects which test true if their state is
;; satisfied by the representation.

#lang racket/base


(require racket/class
         racket/function
         racket/gui/base)
(require "keystate.rkt"
         "entity.rkt")

(provide keyrep%)

(define keyrep%
  (class object%
    (super-new)
    (field [key-lst '()]
           [keystate-triggers '()])

    (define/private press
      (λ (key)
        (set! key-lst (cons key (remove* (list key) key-lst)))))

    (define/private release
      (λ (key)
        (set! key-lst (remove* (list key) key-lst))))

    (define/public handle-key-event
      (λ (ke)
        (let ([kc (send ke get-key-code)])
          (if (eq? kc 'release)
              (release (send ke get-key-release-code))
              (press kc)))))

    (define/private matches-state?
      (λ (state)
        (send state matches-keys key-lst)))

    (define/private match-state
      (λ (state-lst)
        (for ([state (in-list state-lst)])
          (cond [(matches-state? state) (send state trigger)]
                [else (send state not-pressed)]))))

    (define/public load-keystates
      (λ (keystate-lst)
        (set! keystate-triggers (append keystate-triggers keystate-lst))))

    (define/public load-entity
      (λ (entity)
        (load-keystates (get-field keystate-triggers entity))))

    (define/public check-keystates
      (λ ()
        (match-state keystate-triggers)))))

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
