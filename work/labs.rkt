; Week 01 Lab 01 ##
; 1. start emacs ##
  ; not gonna do this part for now.
  ; i will explore emacs later. for now i'm sticking with vim.

; 2. think about each of the following Scheme expressions. run them. think about the results. try to understand how Scheme interprets what you type. ##

3 ; will return 3. the interpreter sees a number with no procedure definition and will simply print the number

(+ 2 3) ; primitive addition operation. interpreter will evaluate 2 and 3 as 2 and 3, then apply the + operator to those values. outputs 5

(+ 5 6 7 8) ; same as above. interpreter will evaluate the number literals as themselves then apply the + operator to those arguments. outputs 26

(+) ; call to use addition primitive procedure with no inputs. will return 0 (plus with no arguments)

(sqrt 16) ; if sqrt is defined in this dialect, and its named sensibly, will return 4

+ ; the addition procedure name, but not a call to it (lacks parens). will return the description of the operation

'+ ; will return + as a word

'hello ; will return the word hello

'(+ 2 3) ; will return the sentence + 2 3, of which the words are +, 2, and 3

'(good morning) ; will return the sentence '(good morning)

(first 274) ; procedure call to apply the first operator to the 274 argument. will return 2

(butfirst 274) ; procedure call to apply the butfirst operator to the 274 argument. will return 74

(first 'hello) ; procedure call to apply the first operator the word hello. will return 'h

(first hello) ; procedure call to apply the first operator the variable hello. hello is undefined, so will return an error of some kind. if hello was defined, calling first upon it would return the first element of whatever hello returns (number, letter, word)

(first (bf 'hello)) ; interpreter needs to apply the first operator to the argument (bf 'hello). (bf 'hello) is itself a procedure call the interpreter will need to evaluate before applying first to its output. (bf 'hello) outputs 'ello. (first 'ello) will return 'e

(+ (first 23) (last 45)) ; applies the + operator to the arguments, which need to be resolved. first 23 will resolve to 2. last 45 will resolve to 5. (+ 2 5) will return 7

  (define pi 3.14159) ; define a variable pi with a value 3.14159. define is a special form, so it does not need to evaluate pi before evaluating define. if it did it could never work, because it is define that gives pi a value to be evaluated. will return... pi? or 3.14159. neither. simply returns the line (define pi 3.14159)

  pi ; will return the value of pi 3.14159

  'pi ; will return the word 'pi

  (+ pi 7) ; interpreter will evaluate pi as 3.14159 and 7 as 7, then apply the plus operator to those arguments, returning 10.14159

  (* pi pi) ; interpreter will evaluate both pi argument as 3.14159, then apply the multiplication operator to them. will return something like 9.86958 but i'm not sure how many significant figures it will use

  (define (square x) (* x x)) ; defines a procedure called square which takes argument x as the multiplication of x and x. will return the line itself. when square is called with some valid input, it will use (* x x) to return the output

  (square 5) ; interpreter will evaluate the argument 5 as 5, then evaluate apply the square procedure to that argument. will evaluate square as (* 5 5) and return 25

  (square (+ 2 3)) ; same output as last, 25, but interpreter will first have to evaluate the procedure call (+ 2 3) to 5 before using the argument to square.

  ; 3. Use emacs (or whatever) to create a file called pigl.scm in your directory containing the pig latin program shown below: ##
(define (pigl wd)
  (if (pl-done? wd)
      (word wd 'ay)
      (pigl (word (bf wd) (first wd)))))

(define (pl-done? wd)
  (vowel? (first wd)))

(define (vowel? letter)
  (member? letter '(a e i o u)))

; 4. Now run Scheme. You are going to create a transcript of a session using the file you just created:
(transcript-on "lab1")  ; this starts the transcript file

(load "projects/sicp/work/files/pigl.scm")       ; this reads in the file you created earlier

(pigl 'scheme)          ; try out your program
                        ; feel free to try more test cases here
(trace pigl)            ; this is a debugging aid. watch what happens

(pigl 'scheme)          ; when you run a traced procedure.

(exit)

; i don't have those procedures. let me try running racket using the dyoo simply scheme package
; okay, with any simply-scheme variant i have (dyoo-simply-scheme1, dyoo-simply-scheme2, simply-scheme) i can load and trace, but i can't use transcript-on
; with dyoo-simply-scheme1 i get transcript-on: unsupported at least

; i don't know that i need to even generate a transcript. i imagine all it does is record the input and output on the repl to a file.
; given my setup using vim to hold all my notes and functions and slinging input to a repl running in another tmux pane, i don't know that i need a transcript.
; this document doesn't retain the output, but it retains all the repl input + context.
; that's good enough for me.

racket -I simply-scheme

; Week 01 Lab 02 ##
; 1. Predict what Scheme will print in response to each of these expressions. _Then_ try and make sure your answer was correct, or if not, that you understand why. ##

(define a 3) ; will return (define a 3). we are defining a variable to have value 3. the evaluator will simply print the assignment operation, not the variable or the value alone

(define b (+ a b)) ; will again print the define procedure with the arguments we provided. slow down and see with your eyes man. in fact this fails. we're here defining a variable b to hold the value of (+ a b), but the evaluator needs to evaluate (+ a b) to store that assign that value to be, but b is not yet defined.

(define b (+ a 1)) ; i incorrectly transcribed the above problem. the value of b should have been assigned as (+ a 1). because a was assigned value 3, adding 1 produces 4 which is assigned to variable b. will return the call to define again

(+ a b (* a b)) ; this addition operation sums a, b, and the product of a and b. evaluator will evaluate the unresolved arguments first, so (* a b) = 12. then will add 3 + 4 + 12 = 19, to be returned

(= a b) ; a predicate. will return #f because a does not equal b

(if (and (> b a) (< b (* a b)))
    a
    b) ; will evaluate the predicate, checking if both b is greater than a and b is less than the product of a and b. both conditions are true (4 is greater than 3, 4 is less than 12). will return a, 3.

(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25)) ; special form cond. will evaluate each predicate top to bottom, and for the first that evaluates to true, the interpreter will return the corresponding consequent expression. in this case, (= a 4) is #f, so 6 is not returned. (= b 4) is true, so the interpreter will evaluate that clause's consequent expression (+ 6 7 a) by first evaluating a to 3, then summing the arguments, returning 16. the else clause is never reached.

(+ 2 (if (> a b) b a)) ; ultimately an addition operation with a 2 arguments: the number 2, and the value returned by evaluating the condition "if a is greater than b, return b, else return a". the interpreter will evaluate the if condition, find that a (3) is not greater than b (4), and return a (3) to be summed with 2, returning 5

(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1)) ; will multiply the output of the cond and the sum of a + 1. a is less than b, so the cond returns b (4). the sum of a (3) and 1 is 4. the product of 4 and 4 is 16, which is returned.

((if (< a b) + -) a b) ; will error out i think. but take a good look. no. the operation that will be applied to a and b is conditional. if a is less than b, we sum them, else we take their difference. a _is_ less than b, so we sum a and b, 3 and 4, returning 7

; 2. In the shell, type the command 'cp ~cs61a/lib/plural.scm .' This will copy a file from the class library to your directory yada yada yada. Then modify the procedure so that it correctly handles cases like (plural 'boy). ##

; well can't copy from the class library.
; but we wrote this procedure during lecture. i can just use that, or rewrite it.
; i'll rewrite it. the best way to get good at coding is to do more coding (and read more code).
; NOTE: dig into that reading part more, broadly. i've heard that grandmaster chess players are great not because they've _played_ so many games, but because they've _studied_ so many games.


(load "files/plural.scm")

(plural 'boy)

(plural-2 'boy)

(plural-2 'book)

(plural-2 'day)

(plural-2 'fly)

(plural-2 'sharks) ; does not recognize existing plurals.

; 3. Define a procedure that takes three numbers as arguments and returns the sum of the squares of the two larger numbers. ##

(define (square x)
  (* x x))

(define (sum-of-squares x y)
  (+ (square x) (square y)))

; 3 numbers
; 2 largest could be a and b, a and c, or b and c
; or any of them could be equal
(define (fun a b c)
  (cond ((and (>= a c) (>= b c)) (sum-of-squares a b))
        ((and (>= b a) (>= c a)) (sum-of-squares b c))
        (else (sum-of-squares a c))))

(fun 0 11 0)

; 4. Write a procedure dupls-removed that, given a sentence as input, returns the result of removing duplicate words from the sentence. It should work this way: ##
  ; (dupls-removed '(a b c a e d e b)) ##
  ; (c a d e b) ##
  ; (dupls-removed '(a b c)) ##
  ; (a b c) ##
  ; (dupls-removed '(a a a a b a a)) ##
  ; (b a) ##

(define (dupls-removed sent)
  (if (member? (first sent) (bf sent)) (dupls-removed (bf sent))
      sent))


(dupls-removed '(a b c a e d e b))

(dupls-removed '(a b c))

(dupls-removed '(a a a a b a a))

; not quite right. this only removes duplicates if they're the first word in the sentence.
; will come back to this in the morning. brain is tired. been a long day.
