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

; will be focusing more on the exercises than the note taking. at least this time around. don't want to get bogged down trying to record every detail, but i will take note of interesting/important concepts.


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


