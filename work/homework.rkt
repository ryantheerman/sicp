; week 1 ##

; Exercise 1 ##
; do exercise 1.6, page 25. ... if you had trouble understanding the square root program in the book, explain instead what will happen if you use _new-if_ instead of _if_ in the pigl pig latin procedure.

; using the new-if procedure to rewrite the square root program...
; the new-if procedure redefines if in terms of a cond.
; let's refresh on the behavior of if.
; if is used when there are two possible cases.
; if true, then case 1 output
;          else case 2 output
; if is a special form in that it does not first evaluate the arguments before evaluating the if.
; if it did and one of the arguments was recursive, it would infinitely try to evaluate that argument.
; so if will first evaluate if and see that it's a special form.
; then it will evaluate the first argument, the test
; if it evaluates to true, it will evaluate the first consequent
; if it evaluates to false, it will skip evaluating the first consequent and instead evaluate the second consequent.

; now, with new-if...
; here's the definition:
(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))
; how will this behave with the square root program?
; here's the definition:
(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x)
                     x)))

; will look like:
; (cond ((good-enough? guess x) guess)
;       (sqrt-iter (improve guess x)
;                   x))

; so every time we loop call sqrt-iter with inputs guess and x,
; we will first evaluate the test of the first clause (good-enough? guess x).
; if it is true, we will return guess
; else we will return the else-expression (sqrt-iter (improve guess x) x)

; except we won't evaluate like that.
; when we call new-if, because it's not a special form we will first evaluate all it's arguments
; so we'll evaluate predicate, then-clause, and else-clause _before_ actually getting into the cond.
; only after those arguments are evaluated do we pass their values to the cond.
; but because the else clause is a recursive call, we will never stop calling.
; the procedure will hang, consuming more and more memory as time goes on until it's killed.

; same would occur would the pigl function.
; it recursively calls pigl in the else-expression
; if we used new-if, it would call pigl trying to evaluate it's actual argument value forever, and never actually resolving to something that could be passed to new-ifs implementation.


; Exercise 2 ##
; write a procedure *squares* that takes a sentence of numbers as its argument and returns a sentence of the squares of the numbers:
; > (squares '(2 3 4 5)
; (4 9 16 25))

(sentence 'now 'here)
; i'll want to use sentence to build the final output
; something like (sentence (square of first) (square of second) etc)

(define (squares sent)
  (sentence (square (first sent)))) ; need to replace this with a call that iterates over sent and returns each word passed to square?

; function to iterate over sent and square words
; basic flow
; if we're on the last word in the sentence, return (square sent) <--- base case
(define (sent-iter sent)
  (if (last-word? (square sent))
      sent-iter (bf sent)))

; square function
(define (square x)
  (* x x))

(squares '(2 3 4 5))


; what do i know?

; input is a sentence.
(define (squares sent)
  ; and output is a sentence
  (sentence (output)))
; output above is a placeholder which needs to generate the output

; i know i need a procedure square to square each word in the input sentence
; so in plain english, output needs to...
  ; isolate each word of the input sentence
  ; square it
  ; and return the square 

; checking the simply scheme docs it looks like i have access to a primitive function 'empty?'
; could maybe use this in the base case
(empty? '(test)) ; works

; i'll want to do something with first (to isolate it)

; this won't work, but moving in the right direction?
; what i'm saying here is take an input sentence
; if the sentence is not empty, return the square of the first word
; else call sent-iter with all but the first word of the sentence
; why it won't work...
; my test is checking if the input sentence is not empty
; if true, it's returning the square of the first word
; else, it's removing the first word from the sentence and calling sent-iter again
; 
(define (sent-iter sent)
  (if (= (empty? sent) #f) (square (first sent))
      (sent-iter (bf sent))))

; what if we use a cond?
; i still need to call sent-iter in the else
; so how do i return the square of one word, while still removing that word and calling the iterator again?
; i don't think i can do both at once.
; i could create a variable called output-sent and use it to store the squared values.
; would be empty at first
; pass both into sent-iter
; something in me does not like that path, but i will try. remember, get it working first. then optimize.

(define (squares sent)
  (define (square x)
    (* x x))
  (define (sent-iter input output)
    (if (empty? input) output
        (sent-iter (bf input) (sentence output (square (first input))))))
  (sent-iter sent '()))

(squares '(2 3))

(squares '(1 2 3 4 5 6 7 8 9 10))

(squares '(-10 -5 0 5 10))

; that works.

; Exercise 3 ##
; Write a procedure switch that takes a sentence as its argument and returns a sentence in which every instance of the words I or me is replaced by you, while every instance of you is replaced by me except at the beginning of the sentence, where it's replaced by I (Don't worry about the capitalization of letters). Example:
; > (switch '(You told me that I should wake you up))
; (i told you that you should wake me up)

; could use the input output sentence strategy again?
(define (switch sent)
  ; helper functions
  (define (sent-iter input output bool)
    (if (empty? input) output
        (sent-iter (bf input) (sentence output (should-replace? (first input) bool)) #f)))
  (define (should-replace? wd bool)
    (cond ((member? wd '(me Me I)) (word 'you)) ; how to know here if the input word is the first word in the outer input sentence?
          ((and (member? wd '(you You)) bool) 'I)
          ((member? wd '(you You)) (word 'me))  ; could pass some kind of bool into should-replace indicating if it's our first time through or not.
           (else wd)))
  (sent-iter sent '() #t))

(switch '(I told you I need you to help me))

(switch '(you told me you need me to help you))

(switch '(You told me that I should wake you up))

(switch '(I I me you You me I))

(switch '(you you you me me you you))

; cool. that works too. seems messy. but it works.


; Exercise 4 ##
; Write a predicate *ordered?* that takes a sequence of numbers as its argument and returns a true value if the numbers are in ascending order, or a false value otherwise.

; what we're doing here is learning to use recursion to iterate.

(define (ordered? seq) ; what is sequence? a sentence? why not?
  (check-order seq))
(define (check-order seq)
  (cond ((= (count seq) 1) #t)
        ((< (first seq) (first (bf seq))) (check-order (bf seq)))
        (else #f)))

(ordered? '(1 2 3))

(ordered? '(1 5 2 10 100 209))

; works.


; Exercise 5 ##
; Write a procedure *ends-e* that takes a sentence as its argument and returns a sentence containing only those words of the argument whose last letter is :
; > (ends-e '(please put the salami above the blue elephant))
; (please the above the blue)

(define (ends-e input)
  (build-output input '()))
(define (build-output input output)
  (if (empty? input) output
      (build-output (bf input)
                    (if (check-if-e (last (first input))) (sentence output (first input))
                        output))))
(define (check-if-e wd)
  (if (equal? (last wd) 'e) #t
      #f))

(ends-e '(please put the salami above the blue elephant))


; Exercise 6 ##
; Most versions of Lisp provide *and* and *or* procedures like the ones on page 19. In principle there is no reason why these can't be ordinary procedures, but some versions of Lisp make them special forms. Suppose, for example, we evaluate
; (or (= x 0) (= y 0) (= z 0))
; If *or* is an ordinary procedure, all three argument expressions will be evaluated before *or* is invoked. But if the variable x has the value 0, we know that the entire expression has to be true regardless of the values of y and z. A Lisp interpreter in which *or* is a special form can evaluate the arguments one by one until either a true is found or it runs out of arguments.
; Your mission is to devise a test that will tell you whether Scheme's *and* and *or* are special forms or ordinary functions. This is a somewhat tricky problem, but it'll get you thinking about the evaluation process more deeply than you otherwise might.
; Why might it be advantageous for an interpreter to treat *or* as a special form and evaluate its arguments one at a time? Can you think of reasons why it might be advantageous to treat *or* as an ordinary function?

; approach to solving this problem. or at least... working through this problem...
; go back and review normal and applicative order evaluation. really wrap your head around that.
; then trace through some *and* and *or* conditionals using each method.
; might be worth writing order functions like Brian demonstrated to take as input some function and print out each evaluation step based on the evaluation method.
; to get to understand evaluation better.
; yes i'll do that. that's at least a direction i know to go in, which i trust will open doors to more thoughts regarding the above problem. currently i'm not sure how to think about it.
