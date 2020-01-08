;;;; delegate
;;

#lang racket/base

(require racket/class
         racket/gui/base)
(require "game-canvas.rkt")

(provide delegate%)

(define delegate%
  (class object%
    (super-new)
    (field [frame (new frame% [label "onslaught"] [style '(fullscreen-button)])]
           [screen-controller (new game-canvas% [parent frame])])

    (define/public start
      (λ ()
        (send frame show #t)))))

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
