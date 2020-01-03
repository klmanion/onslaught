;;;; keystate
;; keystate% matches a representation of keyboard state.
;; Contains a callback which can be called upon match.

#lang racket/base


(require racket/class
         racket/function
         racket/gui/base)

(provide keystate% make-keystate)

(define keystate%
  (class object%
    (super-new)
    (init-field [seq #f] [callback #f])

    (define/public matches-keys
      (λ (key-lst)
        (cond [(or (eq? seq #f) (null? seq)) #f]
              [(null? key-lst) #f]
              [else (null? (remove* key-lst seq))])))

    (define/public trigger
      (λ ()
        (callback)))))

(define make-keystate
  (λ (seq cb)
    (new keystate% [seq seq] [callback cb])))

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
