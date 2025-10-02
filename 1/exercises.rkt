; Exercise 1.1 ##
; Below is a sequence of expressions. What is the result printed by the interpreter in response to each expression? Assume that the sequence is to be evaluated in the order in which it is presented.

10 ; nothing? Lisp expressions need to be parenthesized.
; wrong. was 10. numeric primitives can be standalone. duh. that was in the first section.

(+ 5 3 4) ; 12

(- 9 1) ; 8

(/ 6 2) ; 3

(+ (* 2 4) (- 4 6)) ; 6

(define a 3) ; no output. this is not an ordinary procedure. it's a special form associating the value 3 with the name 'a'

(define b (+ a 1)) ; still no output, but it will be defined. a is defined as the value 3, so we can define b as the sum of 3 and 1

(+ a b (* a b)) ; 19. 3 + 4 + 12

(= a b) ; #f

(if (and (> b a) (< b (* a b)))
    b
    a) ; if b is greater than a and b is less than the product of a and b, return b. else return a. return 4, the value of the b, because both predicate expressions in the compound expression evaluate to true

(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25)) ; either no output or an error. this is a conditional, but it's not being defined as associated with any variable, so while the syntax is valid, there's no way to trigger this conditional.
; oh, i was wrong about that. a cond *does not need* to be defined to be evaluated and output returned.
; so the second clause's predicate expression evaluated to true (b is equal to 4), so its consequent expression was evaluated and returned (+ 6 7 a sums to 16)

(+ 2 (if (> b a) b a)) ; 6. return the sum of 2 and the value of b if b is greater than a, or the sum of 2 and the value of a is b is less than a

(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
    (+ a 1)) ; 16
; give me the product of the result of evaluating this cond and the sum of a and 1
; the cond's second clause's predicate (< a b) evaluates to true, so the value of b (4) is returned for the cond.
; (+ a 1) evaluates to (+ 3 1) which reduces to 4
; (* 4 4) evaluates to 16
