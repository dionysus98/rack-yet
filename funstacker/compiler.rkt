#lang br/quicklang

(require threading)

(define (read-syntax _path port)
  (define src-lines (port->lines port))
  (define src-datums (format-datums '~a src-lines))
  (define module-datum
    `(module funstacker-mod "compiler.rkt"
       (handle-args ,@src-datums)))
  (datum->syntax #f module-datum))
(provide read-syntax)

(define-macro (funstacker-module-begin HANDLE-ARGS-EXPR)
  #'(#%module-begin
     (display (first HANDLE-ARGS-EXPR))))
(provide (rename-out [funstacker-module-begin #%module-begin]))

(define (handle-args . args)
  (for/fold
   ([stack-acc empty])
   ([arg (in-list args)]
    #:unless (void? arg))
    (cond
      [(number? arg) (cons arg stack-acc)]
      [(or (equal? + arg) (equal? * arg))
       (~> (arg (first stack-acc) (second stack-acc))
           (cons (drop stack-acc 2))
           )])))
(provide handle-args)

(provide + *)