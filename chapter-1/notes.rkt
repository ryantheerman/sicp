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

#|
powerful programming languages provide means for combining simple ideas into complex ideas with these three mechanisms
    1. primitive expressions, which represent the simplest entities the language is concerned with
    2. means of combination, by which compound elements are built from simpler ones, and
    3. means of abstraction, by which compound elements can be named and manipulated as units.
|#

; deal with two kinds of elements in programming: procedures and data.
; data: stuff that we want to manipulate
; procedures: descriptions of the rules for manipulating the data

; in a terminal running an interpreter for the scheme dialect of lisp (or in a vim buffer configured to pipe input to an adjacent racket REPL), i can type an expression, and the interpreter responds with its evaluation of that expression.

; can be a simple numeric
486

; number expressions may be combined with expressions representing primitive procedures (like + - * /) to form compound expressions that represent the application of the procedure to the numbers
(+ 137 349)

(- 1000 334)

(/ 10 5)

(+ 2.7 10) 

(/ 10 3) ; will output 10/3
(/ 10.0 3) ; will output 3.33_

; the above compound expressions (composed of lists of smaller expressions) are called combinations
; the leftmost element in the list is the operator
; the other elements are the operands
; we apply the procedure specified by the operator to the arguments (values of the operands) to get the value of the combination
; placing the operator on the left of the arguments is called prefix notation.
; useful in that the operation can be applied to any number of arguments
(+ 1 2 3 4 5 6)
(* 25 4 12)

; prefix notation is also useful in that it allows for nesting (crafting lists that are combinations of combinations)
(+ (* 3 5) (- 10 6)) ; (3 * 5) + (10 - 6) = 19

; what might look complicated to us is handled quite easily by the lisp interpreter
(+ (* 3 (+ (* 2 4) (+ 3 5))) (+ (- 10 7) 6)); output 57

; can also split the combination over multiple lines to make it more readable
(+ (* 3
      (+ (* 2 4)
         (+ 3 5)))
   (+ (- 10 7)
   6))
