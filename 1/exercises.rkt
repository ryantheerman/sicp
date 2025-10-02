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


; Exercise 1.2 ##
; Translate the following expression into prefix form

; 5+4+(2-(3-(6+(4/5))))/3(6-2)(2-7)

(/ 
 (+ 5 4 
    (- 2 
       (- 3 
          (+ 6 
             (/ 4 5))))) 
 (* 3 
    (- 6 2) 
    (- 2 7)))


; Exercise 1.3 ##
; Define a procedure that takes three numbers as arguments and returns the sum of the squares of the two largest numbers

(define (square x) (* x x))

(define (sum-of-squares x y) (+ (square x) (square y)))

(define (sum-of-squares-of-two-largest x y z)
  (cond ((and (< x y) (< x z)) (sum-of-squares y z))
        ((and (< y x) (< y z)) (sum-of-squares x z))
        (else (sum-of-squares x y))))

(sum-of-squares-of-two-largest 1 2 3); 13
(sum-of-squares-of-two-largest 1 3 2); 13
(sum-of-squares-of-two-largest 2 1 3); 13
(sum-of-squares-of-two-largest 2 3 1); 13
(sum-of-squares-of-two-largest 3 1 2); 13
(sum-of-squares-of-two-largest 3 2 1); 13

(sum-of-squares-of-two-largest 2 4 5); 41
(sum-of-squares-of-two-largest 2 5 4); 41
(sum-of-squares-of-two-largest 4 2 5); 41
(sum-of-squares-of-two-largest 4 5 2); 41
(sum-of-squares-of-two-largest 5 2 4); 41
(sum-of-squares-of-two-largest 5 4 2); 41

(sum-of-squares-of-two-largest 2 5 5); 50
(sum-of-squares-of-two-largest 5 2 5); 50
(sum-of-squares-of-two-largest 5 5 2); 50 

(sum-of-squares-of-two-largest 5 5 5); 50

; could do some more here. could i make some kind of conditional to discover the 2 largest?


; Exercise 1.4 ##
; Observe that our model of evaluation allows for combinations whose operators are compound expressions. Use this observation to describe the behavior of the following procedure:

(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

; this procedure is called a-plus-abs-b
; it takes two values, a and b, and sums a and the absolute value of b
; it does this by checking if b is greater than 0 and...
; if true, returns the addition primitive procedure
; if false, return the subtraction primitive procedure
; and applies the resultant procedure to a and b
; so if b is greater than 0, b is positive and will be added to a's value
; if b is 0, the operation that is applied to a and b is subtraction, but that doesn't matter because a - 0 is a
; if b is less than 0, b is negative and will be subtracted from a's value.
; subtracting a negative is equivalent to adding a positive, so this procedure effectively sums a and the absolute value of b

(a-plus-abs-b 1 1) ; 2
(a-plus-abs-b 1 0) ; 1
(a-plus-abs-b 1 10) ; 11
(a-plus-abs-b 1 -1) ; 2
(a-plus-abs-b 1 -4) ; 5
(a-plus-abs-b 1 -1004) ; 1005


; Exercise 1.5 ##
; Ben Bitdiddle has invented a test to determine whether the interpreter he is faced with is using applicative-order evaluation or normal-order evaluation. He defines the following two procedures:

(define (p) (p))

(define (test x y)
  (if (= x 0)
      0
      y))

; Then he evaluates the expression

(test 0 (p))

; What behavior will Ben observe with an interpreter that uses applicative-order evaluation? What behavior will he observe with an interpreter that uses normal-order evaluation? Explain your answer. (Assume that the evaluation rule for the special form *if* is the same whether the interpreter is using normal or applicative order: The predicate expression is evaluated first, and the result determines whether to evaluate the consequent or alternative expression.)

; refresher...
; normal-order evaluation is the "fully expand and then reduce" method
; applicative-order evaluation is the "evaluate the arguments and then apply" method

; if the interpreter for Ben's test uses normal-order evaluation, it will fully expand and then reduce all expressions
; so it will see the operator "test" and the operands "0" and "(p)"
; test is defined as (if (= x 0) 0 y)
; (p) is defined as itself
; so in normal-order evaluation, (test 0 (p)) will expand "test" into (if (= 0 0) 0 (p)) <- this is substituting the conditional for test, and substituting the actual arguments for the formal arguments.
; because (p) is defined as itself, it cannot be substituted with anything meaningful.
; i expect we'll see some kind of interpreter error saying that (p) is undefined

; if the interpreter uses applicative-order evaluation, it will evaluate the arguments and then apply
; so it will substitute the operand "test" with the conditional (if (= x 0) 0 y)
; then it will substitute the formal arguments with the actual arguments, leaving us with (if (= 0 0) 0 (p))
; then it will apply the operation on (test 0 (p))
; because x = 0, the if conditional predicate evaluates to true, so 0 is returned for the test operation.
; if x did not equal 0, the predicate would be false and the interpreter would attempt to evaluate (p), which is defined in as itself, so is ultimately undefined. probably we'd see some type of interpreter error.
; let's test it.

; hmmm okay, seem like the operation hangs when i run (test 0 (p)).
; why might it hang?
; because we're using applicative-order eval and cannot substitute anything for (p)?

; wow i got that one totally wrong.

; i needed to think about how the interpreter rules are applied more in normal vs applicative order eval.
; yes it's true that in normal-order eval, the subexpressions are fully expanded as early as possible, but the key is that those expanded subexpressions are not _evaluated_ until they are needed.
; in the case of (test 0 (p)), yes (p) is defined as itself (the function p), but because x = 0, only the first consequent expression is evaluated, returning 0. the alternative consequent does not need to be evaluated, so we skip past the infinite loop that an applicative-order eval interpreter gets stuck in.

; why does an applicative-order eval interpreter get stuck in an infinite loop?
; the rules of evaluating a combination...
; (test 0 (p)) will start with the operand, and evaluate the operator to (if (= x 0) 0 y)
; then it will evaluate the 0 as 0
; then it will evaluate (p)
; (p) is defined as the function (p), so the interpreter will attempt to apply the rules of interpretation to this expression
; it will start with the operator, and evaluate (p) as (p)
; then it will attempt to apply the procedure denoted by the operator to the operands. the operator is (p) and there are no operands.
; to apply a compound procedure, the operation must be applied to the arguments of the procedure, but there are no arguments, so in order to attempt applying the compound procedure, the interpreter must again follow the rules and evaluate the operator then the operands. it will evaluate (p) to (p) and start the loop again.
