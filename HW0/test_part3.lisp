(load "csv-parser.lisp")
(in-package :csv-parser)

;; (read-from-string STRING)
;; This function converts the input STRING to a lisp object.
;; In this code, I use this function to convert lists (in string format) from csv file to real lists.

;; (nth INDEX LIST)
;; This function allows us to access value at INDEX of LIST.
;; Example: (nth 0 '(a b c)) => a

;; !!! VERY VERY VERY IMPORTANT NOTE !!!
;; FOR EACH ARGUMENT IN CSV FILE
;; USE THE CODE (read-from-string (nth ARGUMENT-INDEX line))
;; Example: (mypart1-funct (read-from-string (nth 0 line)) (read-from-string (nth 1 line)))

;; DEFINE YOUR FUNCTION(S) HERE

(defun insert-n (originalList value index) 
    (if (< index 0) ; Index Limit for our list
        (setq index 0)
        (if (> index (length originalList))
            (setq index (length originalList))
        )
    )

    (setq firstPart (subseq originalList 0 index)) ; Gets the first half of the list till the index
    (setq secondPart (subseq originalList index (length originalList))) ; Gets the second half  of the list from index

    (append firstPart (list value) secondPart) ; Appends first half, the value as list and second half in order
)

;; MAIN FUNCTION
(defun main ()
  (with-open-file (stream #p"input_part3.csv")
    (loop :for line := (read-csv-line stream) :while line :collect
      (format t "~a~%"
      ;; CALL YOUR (MAIN) FUNCTION HERE
      (insert-n (read-from-string (nth 0 line)) (read-from-string (nth 1 line)) (read-from-string (nth 2 line)))


      )
    )
  )
)

;; CALL MAIN FUNCTION
(main)
