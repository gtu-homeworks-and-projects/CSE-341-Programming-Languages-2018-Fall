;; CSE341 – Programming Languages (Fall 2018)
;; Project #1
;; Halil Onur Çeçen

(defvar operators "+-/*()") ; valid operators

(defvar keywords '("and" "or" "not" "equal" "append" "concat" "set" "deffun" "for" "while" "if" "exit")) ; valid keywords

(defvar booleans '("true" "false")) ; valid booleans

;; Checks given string and checks if it contains any token. If it contains any identifier[a-zA-z], integer or operator.
;; Binary values and keywords can be checked later in identifiers.
(defun tokenize (possible-tokens)
    (setq tokens '())
    (setq i 0)
    (loop
        (setq currentToken (aref possible-tokens i))
        (if (position currentToken operators) ; Operator check
            (progn
                (setq negativeIntegerFlag nil)
                (if (char= #\- currentToken)
                    (if (setq j (findIntegerEnd possible-tokens (+ i 1))) 
                        (progn
                            (setq negativeIntegerFlag t)
                            (setq token (subseq possible-tokens i j))
                            (setq tokens (append tokens (list (list "integer" token))))
                            (setq i j)
                        )
                    )
                )
                (if (not negativeIntegerFlag)
                    (progn
                        (setq tokens (append tokens (list (list "operator" (string currentToken)))))
                        (setq i (+ i 1))
                    )
                )
            )
            (if (and (isChar currentToken)) ; DFA condition for identifiers
                (progn
                    (setq j (findCharEnd possible-tokens i))
                    (setq token (subseq possible-tokens i j))
                    (if (isKeyword token)
                        (setq tokens (append tokens (list (list "keyword" token))))
                        (if (isBoolean token)
                            (setq tokens (append tokens (list (list "binary" token))))
                            (setq tokens (append tokens (list (list "identifier" token))))
                        )
                    )
                    (setq i j)
                )
                (if (isDigit currentToken) ; DFA condition for integer values
                    (progn
                        (setq j (findIntegerEnd possible-tokens i))
                        (setq tokens (append tokens (list (list "integer" (subseq possible-tokens i j)))))
                        (setq i j)
                    )
                    (setq i (+ i 1))
                )
            )
        )
        
        (when (>= i (length possible-tokens)) (return i))
    )
    tokens
)

;; Checks if given input is a charachter from alphabet
(defun isChar (char)
    (and (char>= char #\A) (char<= char #\z))
)

;; Finds the index of identifier, keyword or binary value end in given token
(defun findCharEnd (token i)
    (if (>= i (length token)) (return-from findCharEnd nil))
    (loop
        (when (not (isChar (aref token i)))  (return i))
        (setq i (+ i 1))
        (if (>= i (length token))
            (return i)
        )
    )
)

;; Checks if given input is a digit
(defun isDigit (digit)
    (and (char>= digit #\0) (char<= digit #\9))
)

;; Finds the index of integer end in given token
(defun findIntegerEnd (token i)
    (if (>= i (length token)) (return-from findIntegerEnd nil))
    (loop
        (when (not (isDigit (aref token i)))  (return i))
        (setq i (+ i 1))
        (if (>= i (length token))
            (return i)
        )
    )
)

;; Checks if given string is keyword or not
(defun isKeyword (keyword)
    (loop for n in keywords
        do (if (string= keyword n) (return t))
    )
)

;; Checks if given string is boolean or not
(defun isBoolean (bool)
    (loop for n in booleans
        do (if (string= bool n) (return t))
    )
)

;; Splits a string by given char andr returns a list of strings
(defun split (str char)
    (setq list '())
    (setq len (- (length str) 1 ))
    (loop for i from 0 to len
        do (if (not (char= char (aref str i)))
            (progn
                (setq k (loop for j from i to len
                    do (when (char= char (aref str j)) (return j))
                ))
                (if (null k) 
                    (progn 
                        (setq list (append list (list (subseq str i (length str)))))
                        (setq i (length str)))
                    (progn 
                        (setq list (append list (list (subseq str i k))))
                        (setq i k))
                )
            )
        )
    )
    list
)

;; Reads file into a single string
(defun read-file (filename)
    (setq input "")
    (setq space " ")
    (with-open-file (stream filename)
        (loop 
            (when (not (setq line (read-line stream nil nil))) (return input))
            (setq input (concatenate 'string input space line))
        )
    )
)

;; This function takes a filename, reads its inputs into a string as a line, 
;; splits string into string list by white space and tokenizes according to operators, identifiers and numeral terminals.
(defun lexer (filename)
    (setq input (read-file filename))
    (setq input (split input #\Space))
    (setq tokens '())
    (dolist (n input)
        (setq tokens (append tokens (tokenize n)))
    )
    tokens
)

;; Main function calls the function lexer and retrieves all tokens in a list.
(defun main ()
    (dolist (n (lexer "input.coffee"))
        (print n) ; This one prints all tokens with their types
    )

    (setq inp "")
    (dolist (n (lexer "input.coffee"))
        (setq inp (concatenate 'string inp " " (string (car (cdr n))))) ; To match wanted single string output i concatenated the list and printed the final version.
    )
    (print inp)
)

;;(main)