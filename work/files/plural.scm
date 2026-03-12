(define (plural wd)
  (if (equal? (last wd) 'y)
      (word (bl wd) 'ies)
      (word wd 's)))


; what are the possible outcomes?
  ; book -> books
  ; fly  -> flies
  ; boy  -> boys
; what conditions can lead to those outputs?
  ; so if a letter word ends in y and the last letter but the last is not a vowel, replace the last of the word with ies
  ; else add s


(define (plural-2 wd)
  (if (and (equal? (last wd) 'y)
           (not (member? (last (bl wd)) 
                         '(a e i o u)))) (word (bl wd) 'ies)
      (word wd 's)))

