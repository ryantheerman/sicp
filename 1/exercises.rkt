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

; gotta review the above. go back to notes and pin it down.


; Exercise 1.6 ##
; Alyssa P. Hacker doesn't see why *if* needs to be provided as a special form. "Why can't I just define it as an ordinary procedure in terms of *cond*?" she asks. Alyssa's friend Eva Lu Ator claims this can indeed be done, and defines a new version of *if*.

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

; Eva demonstrates the program for Alyssa:

(new-if (= 2 3) 0 5) ; returns 5

(new-if (= 1 1) 0 5) ; returns 0

; Delighted, Alyssa uses new-if to rewrite the square-root program:

(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x)
                     x)))

; What happens when Alyssa attempts to use this to compute square roots? Explain.


; okay, what will happen?
; the structure of of the sqrt-iter procedure is the same, but the conditional has changed.
; what was an if is now a cond.

; refresher... what are the differences between if and cond?

; cond:
; specifies a series of <predicate> <consequent expression> pairs called clauses
; each predicate is evaluated in order.
; if a predicate evaluates to true, the value corresponding consequent expression is returned as the value for the cond.
; the else clause is a special symbol that can be used in place of the predicate in the final clause of a cond.
; _this causes the cond to return as its value the value of the corresponding consequent expression whenever all previous clauses have been bypassed_
; is the verbiage there significant? when the else clause fires, does that short circuit the recursiveness of evaluating the final expression? dig into this? this might be the key to understanding the answer to this problem.

; if:
; if is a special form of conditional that can be used when there are precisely two cases in the case analysis.
; an if contains a <predicate> followed by a <consequent expression> which is evaluated if the predicate evaluates to true, followed by an <alternative consequent expression> which is evaluated if the predicate evaluates to false.

; the language of evaluated vs returned is why i'm suspicious of the else clause in cond.
; do returned and evaluated mean the same thing in the context of MIT scheme, proxied for me by the racket SICP package?

; think it through.
; let's say returned _does_ short circuit recursive eval.
; in that case, the new-if else clause would return (sqrt-iter (improve guess x) x)
; it would return that procedure call with those arguments, rather than _evaluating_ the procedure call as would occur with the alternative consequent expression of an if.

; the if will evaluate the alternative expression, which will trigger the interpreter rules on sqrt-iter again, recursively refining the guess until the consequent expression is evaluated. because it is a primitive decimal, it will be as itself. because no more evaluations are necessary, that decimal value will be returned as the value of the procedure being applied.

; with the new-if, we won't recursively evaluate the consequent expression of the else clause. we'll just return that consequent expression.
; so either it will return the literal expression, or it will produce an error because maybe you can't do that, or it will be undefined because an expression is not a value, and a value is expected.



; define new-if
(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

; define sqrt-iter in terms of new-if
(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x)
                     x)))

; define improve
(define (improve guess x)
  (average guess (/ x guess)))

; define average
(define (average x y)
  (/ (+ x y) 2))

; define good-enough?
(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

; define square
(define (square x)
  (* x x))

; define trigger operation
(define (sqrt x)
  (sqrt-iter 1.0 x))

; execute
(sqrt 16) ; the value _should_ approximate as close to 4. but i suspect we'll receive an error.

; in fact we're hung.
; why are we hung?

; i am assuming we got into a loop. how did we get into a loop?

; oh my god i overthought it.
; it's an evaluation order problem again.

; the interpreter uses applicative-order evaluation, so it starts from the inside out, first evaluating the arguments before applying the operand which is the procedure to be applied to those arguments.

; when we call sqrt-iter again, we need to evaluate its arguments again. so we'll call sqrt-iter again, and again, and again forever.
; we'll never actually get around to evaluating the predicate of new-if, because we'll forever be recursively calling the interpreter rules on the sqrt-iters else clause consequent expression.


; Exercise 1.7 ##
; The good-enough? test used in computing square roots will not be very effective for finding the square roots of very small numbers. Also, in real computers, arithmetic operations are almost always performed with limited precision. This makes our test inadequate for very large numbers. Explain these statements, with examples showing how the test fails for small and large numbers. An alternative strategy for implementing good-enough? is to watch how guess changes from one iteration to the next, and to stop when the change is a very small fraction of the guess. Design a square-root procedure that uses this kind of test. Does this work better for small and large numbers?


; okay, let's first dissect why the good-enough? test will not be very effective at finding the square roots of very small numbers?
; we defined good-enough? as a procedure acting on two operands, the arguments of which are the current guess and starting problem's radicand.
; good-enough? takes the square of the current guess and subtracts the original radicand, then checks if the absolute value of the that calculation is less than .001.
; effectively this tells us if the square of the guess is within .001 of the actual radicand. 


; Exercise 1.9 ##
; Each of the following two procedures defines a method for adding two positive integers in terms of the procedures 'inc', which increments its argument by 1, and 'dec', which decrements its argument by 1.

; process 1:
(define (+ a b)
  (if (= a 0) b (inc (+ (dec a) b))))

; process 2:
(define (+ a b)
  (if (= a 0) b (+ (dec a) (inc b))))

; Using the substitution model, illustrate the process generated by each procedure in evaluating (+ 4 5). Are these processes iterative or recursive?

; process 1:
#|
(+ 4 5)
(if (= 4 0)
  5
  (inc (+ (dec 4) 5)))
  (inc (+ 3 5))
  (inc 8)
  9
|#
; process 1 is a recursive process in the way it evolves (though not a recursive procedure) <- wrong statement
; it defers the sum until dec has been called on a, and defers the inc operation until the sum of dec a and b has been outputted
; actually it is a recursive procedure as well.
; did not catch at first that the function being called is (+ a b), which we define using the conditional
; so it would expand and contract like this:
#|
(+ 4 5)
(inc (+ 3 5))
(inc (inc (+ 2 5)))
(inc (inc (inc (+ 1 5))))
(inc (inc (inc (inc (+ 0 5)))))
(inc (inc (inc (inc 5))))
(inc (inc (inc 6)))
(inc (inc 7))
(inc 8)
9
|#

; process 2:
#|
(+ 4 5)
(if (= 4 0)
  5
  (+ (dec 4) (inc b)))
  (+ 3 6)
  9
|#
; process 2 is an iterative process in the way it evolves (also not a recursive procedure) <- wrong statement. we are calling (+ a b) at each stage, so the procedure _is_ recursive, but the process is indeed iterative
; it maintains the state of a and b at each step
#|
(+ 4 5)
(+ 3 6)
(+ 2 7)
(+ 1 8)
(+ 0 9)
9
|#


; Exercise 1.10 ##

