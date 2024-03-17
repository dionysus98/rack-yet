#lang br/quicklang
(provide + *)

(require threading)

(define-macro (stackerizer-mb EXPR)
  #'(#%module-begin
     (~>> EXPR
          flatten
          reverse
          (for-each displayln))))

(provide (rename-out [stackerizer-mb #%module-begin]))

(define-macro (define-ops OP ...)
  #'(begin ;; Acts as a fragment
      (define-macro-cases OP
        [(OP FIRST) #'FIRST]
        [(OP FIRST NEXT (... ...))
         #'(list 'OP FIRST (OP NEXT (... ...)))]
        )
      ...))

(define-ops + *)
