;;;; main
;;

#lang racket/base

(require racket/class
         racket/gui/base)
(require "game-canvas.rkt")
         
(define f (new frame% [label "onslaught"] [style '(fullscreen-button)]))

(define cv (new game-canvas% [parent f]))
    
(module+ main
  (send f show #t))

;; vi: set ts=2 sw=2 expandtab lisp tw=79:
