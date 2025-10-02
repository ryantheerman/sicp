; CHAPTER 1 - BUILDING ABSTRACTIONS WITH PROCEDURES ##

#| 
Some notes on my setup for working through SICP...
  - using racket, a lisp dialect, with the sicp package installed. this lang variant aligns with the examples and exercises in the book.
  - i don't really care to use the drracket ide, though maybe i'll explore it at some future point. prefer to use vim for note taking and coding.
  - but vim doesn't provide a REPL (read-eval-print loop) out of the box...
  - so i've configured my sicp environment and installed a few vim plugins to make using vim more effective for working through sicp.
    - using tmux for the sicp work session, with vim open in the left pane and my REPL in the right
    - added rainbow parens to make nested racket expressions more readable
    - added auto-pairs to make sure an open paren always closes
    - added tslime and configured keyboard shortcuts to send the selected racket expression to the REPL in the next pane over
    - added nerdtree and configured the sicp session nerdtree buffer to open at the sicp project node
    - note: did away with nerdtree. not gonna be enough files to need a tree view. can reenable it if needed though
    - wrote a script that will open a tmux session called sicp (or switch to it if already open), open vim to the nerdtree buffer at the ~/projects/sicp node in the left pane, and start up my racket sicp interpreter in the right pane.
  - that's the basics. now i can take my notes and work through the exercises here in vim, enabling me to save and version control my work, rather than losing the activity to the terminal history.
|#

; this is a comment 
(inc 55)

; with tslime installed and configured in vim, i can press <C-h><C-t> on a given line, and that line will be sent to my racket interpreter in the next pane over
(inc 2001)

; if there is not a blank line between the previous line and the currently selected line, my tslime shortcuts will send all lines above the current until a line break. this includes comments and other lisp commands
; it will also send lines below the current
; so unless the line i want to sound is bounded top and bottom by blank lines, they'll get sent via tslime too.
; not the end of the world.

(inc 20034)

(inc 201)

; increment is the only thing i know so far, okay?

; opening note: this is the study of computational process.
; computational processes are abstract things that live in computers, which manipulate other abstract things called data.
; the process is directed by a pattern of rules called a program.


; 1.1 The Elements of Programming ##

#|
powerful programming languages provide means for combining simple ideas into complex ideas with these three mechanisms
    1. primitive expressions, which represent the simplest entities the language is concerned with
    2. means of combination, by which compound elements are built from simpler ones, and
    3. means of abstraction, by which compound elements can be named and manipulated as units.
|#

; deal with two kinds of elements in programming: procedures and data.
; data: stuff that we want to manipulate
; procedures: descriptions of the rules for manipulating the data


; 1.1.1 Expressions ##

; in a terminal running an interpreter for the scheme dialect of lisp (or in a vim buffer configured to pipe input to an adjacent racket REPL), i can type an expression, and the interpreter responds with its evaluation of that expression.

; can be a simple numeric
486

; number expressions may be combined with expressions representing primitive procedures (like + - * /) to form compound expressions that represent the application of the procedure to the numbers
(+ 137 349)

(- 1000 334)

(/ 10 5)

(+ 2.7 10) 

(/ 10 3) ;will output 10/3
(/ 10.0 3) ;will output 3.33_

; the above compound expressions (composed of lists of smaller expressions) are called combinations
; the leftmost element in the list is the operator
; the other elements are the operands
; we apply the procedure specified by the operator to the arguments (values of the operands) to get the value of the combination
; placing the operator on the left of the arguments is called prefix notation.
; useful in that the operation can be applied to any number of arguments
(+ 1 2 3 4 5 6)
(* 25 4 12)

; prefix notation is also useful in that it allows for nesting (crafting lists that are combinations of combinations)
(+ (* 3 5) (- 10 6)) ;(3 * 5) + (10 - 6) = 19

; what might look complicated to us is handled quite easily by the lisp interpreter
(+ (* 3 (+ (* 2 4) (+ 3 5))) (+ (- 10 7) 6)); output 57

; can also split the combination over multiple lines to make it more readable
(+ (* 3
      (+ (* 2 4)
         (+ 3 5)))
   (+ (- 10 7)
   6))


; 1.1.2 Naming and the Environment ##

; can use names to refer to computational objects
; name identifies a variable whose value is the object

(define size 2) ;this must be evaluated before we use the expression 'size'
size ; else the REPL trying to interpret 'size' will return undefined

; can then use variables in combinations with any other expressions
(* 5 size)

(define pi 3.14159)
(define radius 10)
(* pi (* radius radius))
(define circumference (* 2 pi radius))
circumference

; define is our language's simplest means of abstraction- it allows us to use simple names to refer to the results of compound operations
; it would be hard for us to remember and track a vast, complex list for use in a more complex operation, so it's good we can abstract compound expressions into simple variables
; lisp can build complexity incrementally in successive interactions via the REPL
; in lisp, complex programs usually consist of many relatively simple procedures

; given that the interpreter can store values in variables indicates that it must have memory
; this memory is called the global environment


; 1.1.3 Evaluating Combinations ##

; note that the interpreter is following a procedure (an abstraction manipulating data, in this case the expressions)
; for the interpreter to evaluate a combination, it must evaluate the subexpressions of the combination, and apply the procedure that is the value of the leftmost subexpression (the operator) to the arguments that are the values of the other subexpressions (the operands)
; my understanding is that it must start on the inside and work out, or, in a tree view view, it must start at the lowest terminal nodes and work up.
; but i'm not sure that's right, because the rule says it must apply the procedure that is the value of the leftmost subexpression. if i have not evaluated all the inner subexpressions, how can i apply an operation that depends on their answers? maybe if it cannot apply the rule because the subexpressions have not been evaluated yet, the rule calls itself to evaluate the subexpression the leftmost subexpression depends on? and so on until the farthest terminal nodes are evaluated, then the evaluation percolates back up the tree?
; if my thinking is correct, that's the recursion they mention. the rule of evaluation calling itself to evaluate more deeply nested subexpressions before it can evaluate the outermost subexpression

(* (+ 2 (* 4 6))
   (+ 3 5 7))

; here's my understanding...
; the lisp evaluate process is called on a combination like the one above.
; it must evaluate all subexpressions in order to evaluate the entire combination
; and it looks first at the leftmost subexpression (the operator) in order to apply the operation denoted by that operator to the relevant subexpressions (above, those are '(+ 2 (* 4 6))' and '(+ 3 5 7)').
; but it cannot perform that evaluation yet, because those subexpressions are too complex, the eval process calls itself on the next leftmost subexpression, in this case, the operator + in the subexpression '(+ 2 (* 4 6))' in order to apply the addition operation to 2 and (* 4 6).
; but it still cannot perform that evaluation, because '(* 4 6)' is not yet evaluated.
; so the eval process calls itself again on '(* 4 6)', which can be evaluated to 24.
; now '(+ 2 24)' can be evaluated into 26
; here the eval process also calls itself on (+ 3 5 7), as it the other operand of the subexpression that has been evaluated to 26. (+ 3 5 7) evaluates to 15
; so the eval process has reached the point of being able to evaluate the original combination, as its outermost operands have been evaluated to 26 and 15, leaving the expression (* 26 15), which is simply evaluated to 390.
; in this way, the eval process starts at the leftmost subexpression, the operator, and recursively calls itself on the subexpressions composing the operands until every level of the tree is evaluated and the outermost combination can be evaluated.
; this makes good sense.
; considering this in the context of a tree structure, this is called percolating values upward, or more exactly, tree accumulation.

; important to note...
; when eval recursively calls itself to evaluate subexpressions, it proceeds to the point of needing to evaluate primitive expressions such as numerals, built-in operators, or other names.
; lisp handles the eval of primitive cases with the following rules

; 1. the values of numerals are the numbers that they name
; 2. the values of built-in operators are the machine instruction sequences that carry out the corresponding operations
; 3. the values of other names are the objects associated with those names in the environment

; the second rule is a special case of the third rule.
; symbols like '+' and '*' are included in the global env and are associated with the addition and multiplication machine instructions as their values
; the environment is critical to providing context for the execution of programs.

; the above rules (regarding recursive eval of combinations and eval of primitives) does not handle definitions.
(define x 10)
x
; does not apply the operator 'define' to the two arguments 'x' and '10'
; (define x 10) is not a combination. it is an association of the variable x with the value 10.
; this exception (and others we haven't seen yet) to the general evaluation rule and is called a "special form".
; each special form has its own eval rule.
; the various possible expressions and their associated rules make up the syntax of the language.
; lisp syntax is quite simple... the general eval rules, together with a handful of specialized rules for special forms


; 1.1.4 Compound Procedures ##

#| any powerful programming language will include the following elements
  - numbers and arithmetic operations are primitive data and procedures
  - nesting of combinations provides a mean of combining operations
  - definitions that associate names with values provide a limited means of abstraction
|#

; there exists a much more powerful abstraction technique... procedure definitions, by which a compound operation can be named and referred to as a unit.
; is this like assigning a function to a variable, and calling that function by referencing that variable? keep going, we'll see.

; think about the idea of squaring. to square something is to multiply it by itself.
(define (square x) (* x x))

;(define (square     x)         (*          x       x))
; to      square     something,  multiply   it   by itself

; the above is called a compound procedure, given the name square.
; the procedure represents the operation of multiplying something by itself.
; x, the thing to be multiplied, is given a local name. it does not have meaning outside the definition of square
; evaluating the above definition creates the compound procedure and associates it with the name square.

; general form of procedure definition:
; (define (<name> <formal parameters>) <body>)

; name: the symbol to be associated with the procedure definition in the env
; formal parameters: names used within the body of the procedure to refer to the corresponding arguments of the procedure.
; body: the expression that will yield the value of the procedure when it is applied with actual arguments

; now that square is defined, it can be used
(square 5) ;25

; ... and combined with other expressions
(square (+ 2 5)) ;49

; ... which can be more invocations of square
(square (square 3)) ;81

; can use square to build other procedures as well
; x^2 + y^2
(+ (square x) (square y)) ;this won't evaluate, but can be used in a new definition.

; but it can be used to build a new compound procedure and associate that with another name using define
(define (sum-of-squares x y)
  (+ (square x) (square y)))

; now we have a compound procedure called sum-of-squares taking 2 arguments, locally called x and y
; the body of the procedure is the addition of the square of the value of argument x and the square of the argument y

(sum-of-squares 3 4)

(sum-of-squares (+ 2 3) (* 2 5))

; sum-of-squares likewise can be used as a building block for further procedures...
(define (f a)
  (sum-of-squares (+ a 1) (* a 2)))

(f 5)

; there is no difference in how compound and primitive procedures are used. just by looking at them one can't tell if compound procedures are built into the interpreter like the primitives or not


; 1.1.5 The Substitution Model for Procedure Application ##

; refresher...
; things like + - * / are primitive procedures (maybe there are more, but those are the ones I'm aware of at the moment)
; while things like square, sum-of-squares, and f mentioned above are compound procedures
; well, to be exact, those symbols above are the *names* representing the primitive and compound procedures. the procedure itself is what is denoted by the body of the compound procedure definition.
; the point is that the interpreter follows much the same process for evaluating a compound procedure as it does a primitive.
; namely "the interpreter evaluates the elements of the combination and applies the procedure (which is the value of the operator of the combination) to the arguments (which are the values of the operands of the combination)"

; the interpreter rule for evaluating a compound procedure:
; "to apply a compound procedure to arguments, evaluate the body of the procedure with each formal parameter replaced by the corresponding argument"

; consider (f 5) from the prior section
; f is the name of the compound operation, 5 is formal argument, and (sum-of-squares (+ a 1) (* a 2)) is the body

; so to evaluate (f 5), we first retrieve the body (sum-of-squares (+ a 1) (* a 2))

; then we replace the formal param(s) 'a' with the actual argument '5', giving us (sum-of-squares (+ 5 1) (* 5 2))

; now (f 5) has resolved to (sum-of-squares (+ 5 1) (* 5 2)), leaving us with 3 subexpressions to evaluate
; 1. we must evaluate sum-of-squares to know which operation to apply to the arguments (+ 5 1) and (* 5 2)
; 2. we must evaluate (+ 5 1) to 6
; 3. we must evaluate (* 5 2) to 10

; now we know that we need to apply sum-of-squares to 6 and 10
; (sum-of-squares x y) takes x and y as formal arguments, and applies them to the combination (+ (square x) (square y))
; so our problem is now (sum-of-squares 6 10), which resolves to (+ (square 6) (square 10))

; the definition of (square x) resolves the above expression to (+ (* 6 6) (* 10 10))...
; which resolves by multiplication to (+ 36 100)...
; which resolves finally 136

; the process of evaluating describe above is called the *substitution model*
; we can use this as a model of the "meaning" of procedure application.
; NOTE: the substitution model helps us think about procedure application, but it is not a literal description of how the interpreter really works. typically the interpreter uses the local environment for formal parameters, rather than literally substituting the text of the operand with the text of the operands' value, or what it resolves to.
; NOTE: the substitution model is a simplified way of thinking about procedure application that will break down when things get more complex, but it's a good starting point to start thinking about the process.

; the substitution model can be evaluated a different way.
; rather than substituting and evaluating at every step like in the example above, we could substitute and *wait* to expand until the end.

; method 1, how we evaluated above:
(f 5)
(sum-of-squares (+ 5 1) (* 5 2))
(sum-of-squares 6 10)
(+ (square 6) (square 10))
(+ (* 6 6) (* 10 10))
(+ 36 100)
136

; method 2, another way to evaluate:
(f 5)
(sum-of-squares (+ 5 1) (* 5 2))
(+ (square (+ 5 1)) (square (+ 5 2)))
(+ (* (+ 5 1) (+ 5 1)) (* (* 5 2) (* 5 2))) ; NOTE: (+ 5 1) and (* 5 2) are each performed twice here, rather than once each like above.
; which reduces to
(+ (* 6 6) (* 10 10))
(+ 36 100)
136
; same answer, different order of evaluation
; the second way we are not evaluating the operands until they are needed, whereas in the first way we were evaluating the operands first
; both approaches result in reducing to primitives that can be resolved by the in-built rules in the interpreter.

; method 2 ("fully expand and then reduce") is called *normal-order evaluation* as opposed to method 1 which the interpreter actually uses ("evaluate the arguments and then apply"), called *applicative-order evaluation*.

; substitution model refresher...
; normal-order evaluation: fully expand and then reduce
; applicative-order evaluation: evaluate the arguments and then apply (actually used by the interpreter)
; but remember, the interpreter doesn't literally substitute string expressions for names. rather it uses the local environment (in a way that has not yet been defined).

; for most problems and examples in the first two chapters of the book, normal-order and applicative-order evaluations will yield the same result.

; Lisp uses applicative-order
; it is more efficient (don't need to evaluate identical expressions multiple times)
; but also, normal-order evaluation (fully expand then reduce) becomes complicated when the substitution model no longer applies
; normal order eval can still be valuable though, even if it's not universally applicable.


; 1.1.6 Conditional Expressions and Predicates ##

; so far what we've gone over is not super powerful. we can do some math, and we can define some procedures, but we have can't do conditional logic.
; Lisp can do conditional though, of course
; say we want to compute absolute zero by testing if a number is positive, negative, or zero

#|
     /  x  if x > 0
|x| <   0  if x = 0
     \ -x  if x < 0
|#

; the above *case analysis* can be expressed with with Lisp special form **cond**, meaning "conditional"
; remember, the special forms are expressions in Lisp that are not evaluated in the same way as the primitive or compound expressions

(define (abs x)
  (cond ((> x 0) x)
        ((= x 0) x)
        ((< x 0) (- x))))

(abs 10)
(abs 0)
(abs -10)

#| the general form of the conditional expression is as follows

(cond (<p1> <e1>)
      (<p2> <e2>)
      .
      .
      .
      (<pn> <en>))
|#

;the symbol cond is followed by parenthesized pairs of expressions (<p> <e>) called *clauses*.
;the first expression in each pair is a *predicate*, an expression whose value is interpreted as either true or false.
;NOTE: Scheme has two distinguished values denoted by constants #t and #f. when the interpreter checks a predicate's value, it interprets #f as false.
; so a predicate is like a boolean? not exactly. a predicate has a boolean value. it can be true or false.

; conditional expressions are evaluated as follows:
; predicate <p1> is evaluated. if its value is false, <p2> is evaluated. if <p2> evaluates to false, <p3> is evaluated.
; this goes on until a predicate evaluates to true, at which point the interpreter returns the value of <e>, the corresponding *consequent expression* of the clause, as the value of the conditional expression.
; if none of the <p>s evaluate to true, the value of the cond is undefined.

; okay, so let me reword all this to make sure i've got it
; to do anything useful with a language we need to be capable of evaluating conditionally
; this lets us takes different paths through the code based on the outcome of evaluating those conditions
; in Lisp, to specify a conditional expression we use the special form "cond" followed by parenthetical clauses consisting of a predicate, which can evaluate to true or false, and a consequent expression, which is returned as the value of the conditional if the associated predicate evaluates to true.
; conditionals are evaluated like so... each predicate is evaluated until one evaluates to true. if none evaluate to true, the conditional is undefined.
; that all makes sense, moving on

; *predicate* is used both for procedures that return true or false and for expressions that evaluate to true or false.
; for example, the primitive predicates >, <, =, which take two numbers and test whether the first is greater than, less than, or equal to the second.

; could define the absolute value conditional more simply
(define (abs x)
  (cond ((< x 0) (- x))
        (else x)))

(abs 10)

; if x is less than zero, return -x; otherwise return x
; this makes sense. if the value is 0 or greater, the value does not need to be transformed to be positive. but if the value is negative, the return the negation of that value.
; the else symbol above is a special that can be used in place of the final predicate in the final clause of a conditional.
; if all other predicates in the conditional evaluate to false, the else clause will be returned by default.
; any expression that always evaluates to true can be used as the final predicate, like so...

(define (abs x)
  (if (< x 0)
      (- x)
      x))

(abs 15)
(abs 0)
(abs -35)

; this uses the if special form
; the if form can be used when there are exactly 2 cases in the case analysis
; the general form of an if expression is
; (if <predicate> <consequent> <alternative>)

; the interpreter evaluates the predicate. if the predicate evaluates to true, the interpreter evaluates the consequent and returns its value. otherwise the interpreter evaluates the alternative and returns its value.
; it's like a ternary in java.

; so many of these constructs are the same as what i find in java, which is obvious. like duh man.
; but it's cool to see the fundamentals of programming so cleanly laid out
; languages need conditional evaluation. and the logic is the same across languages. it doesn't necessarily matter which language is being used, or how it internally handles the evaluations, but >, <, = *mean* the same thing and the numbers being compared are compared the same way.

#|
in addition to the primitive predicates >, <, and =, there are logical composition operations which enable us to construct compound predicates
  - (and <e1> ... <en>): interpreter evaluates expressions <e> one at a time. if any <e> evaluates to false, the value of the and expression is false and the rest of the <e>s are not evaluated. if all <e>s evaluate to true, the value of the and expression is the value of the last expression.
  - (or <e1> ... <en>): each <e> is evaluated one at a time, left to right. if any <e> evaluates to a true, that value is returned as the value of the or expression and the rest of the <e>s are skipped.
  - (not <e>): TODO: finish these notes
|#

; TODO: go over this section again when you're not so exhausted. i'm getting this, but my brain is sludge after several long days. need to review this with more focus and attention. this felt like just copying down what the book says rather than attempting to integrate it into my understanding.

; 2nd pass ##

; to be usefua, a programming language needs to be able to proceed along differing paths based on the outcomes of evaluating conditions.
; Lisp accomplishes this with the *cond* special form
(define (abs x)
  (cond ((> x 0) x)
        ((= x 0) 0)
        ((< x 0) (- x))))

(abs 10)
(abs 0)
(abs -10)

#| the general form of the conditional expression is as follows
(cond (<p1> <e1>)
      (<p2> <e2>)
      .
      .
      .
      (<pn> <en>))
|#

; the keyword cond indicates this is a conditional
; followed by some number of parenthetical pairs called clauses
; <p> refers to a predicate (something that can evaluate to true or false)
; <e> refers to the consequent expression _if_ that clauses' predicate evaluates to true
; the interpreter evaluates predicates from top to bottom. when one evaluates to true, its consequent expression is returned as the value of the cond.
; if no predicates evaluate to true, the cond is undefined.

; NOTE: the word predicate is used both for procedures that return true or false and for expressions that evaluate to true or false.
; what does this mean exactly? the difference is in the wording... "... procedures that return ..." "... expressions that evaluate ..."
; so if the value that is returned by some process is true of false, that process is a predicate
; and if an expression boils down to true of false, that is also a predicate
; but how do those differ?
; something like (< x 0) uses the primitive predicate <, which takes 2 numbers and returns true if the first is less than the second, or returns false otherwise.
; oh oh oh i see...
; so the primitive predicates < or > or = are predicate **procedures**...
; and using them in an expression results in a primitive **expression**.

; predicate procedures:
; even?
; odd?
; >

; predicate expressions:
; (even? 4)
; (odd? 2)
; (> 2 5)

(even? 4) ; returns #t

(odd? 2) ; returns #f

(> 2 5) ; returns #f

; gotta go to work. will pick this up later.

; are the predicate procedures actually predicate expressions abstracted away behind the name?
; how would we define a procedure like even?
; something like...
(define (even? x)
  ((if x % 2 == 0) (#t) (#f)))

; i don't know the Lisp for modulo, but something like this could work.
; even? is likely a conditional checking if the input value modulo 2 is equal to 0. if yes, return true. else return false.
; not sure where this falls in the structure of the language. define is a special form, not interpreted according to the rules used for other expressions. cond is also a special form. so is if. moving on. will revisit this question i'm sure in time.
; the special form if expression is returning the value #t or #f based on the if conditional, and that if conditional is being associated with the name even via the define special form. so the predicate procedure even is actually a predicate expression if it's unpacked from its abstraction.
; moving on

; can define the absolute value function more simply than the example above
(define (abs x)
  cond ((< x 0) (- x)
        (else x)))

; else is a special symbol that can be used in place of a predicate expression in the final clause. rather than 'else', any predicate expression that always evaluates to true could be used in its place. else just signifies that if all other predicates are false, return the consequent expression of the else clause.
; the above in plain english: if x is less than 0, return the negation of x. otherwise return x.

; another way to define the absolute value function is...
(define (abs x)
  (if (< x 0)
      (- x)
      x))

; if is another special form, a type of conditional (not a type of *cond*).
; the interpreter first evaluates the predicate. if it evaluates to true, the first consequent expression is returned. if it evaluates to false, the alternative consequent expression is returned.
; cond can represent any number of cases in a case analysis with multiple clauses
; if can only represent two cases in a case analysis.
; sort of like a ternary in java
; one key difference of note between cond and if conditionals...
; the consequent expression of a cond clause can be a sequence of expressions, which once evaluated return the final value as the value of the cond
; but if consequent expressions must be single expressions

; beyond primitive predicates like >, <, and =, we have _logical composition operations_ in Lisp.
; we can use these to construct compound predicates
; think boolean gates...

; and <e1> ... <en>:
; all expressions are evaluated by the interpreter, one at a time, left to right. if all evaluate to true, the compound predicate evaluates to true. if any evaluate to false, the compound predicate evaluates to false.

; or <e1> ... <en>
; the expressions are evaluated by the interpreter, one at a time, left to right. if any evaluate to true, the compound predicate evaluates to true and the rest of the expressions are skipped. if all expressions evaluate to false, the value of the compound or expression is false.

; not <e>
; returns true when <e> evaluates to false, and false when <e> evaluates to true.

; NOTE: 'and' and 'or' are special forms, not procedures, because the subexpressions are not all necessarily evaluated. 'not' however is an ordinary procedure.

; some examples of compound predicates in action...

(define (between-five-ten x)
         (if (and (> x 5) (< x 10)) (= x x) (not (= x x))))
(between-five-ten 2)
(between-five-ten 6)
(between-five-ten 5)
(between-five-ten 10)
(between-five-ten 9)


(define (>= x y)
  (or (> x y) (= x y)))
(>= 3 4)
(>= 3 3)
(>= 3 2)

; could also define the above as...

(define (>= x y)
  (not (< x y)))
(>= 3 4)
(>= 3 3)
(>= 3 2)
