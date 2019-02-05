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

(defun merge-list (firstList secondList)
    (if (and (listp firstList) (listp secondList))
        (recursive-merge firstList secondList) ; Recursive main function call
        (if (listp firstList) ; Returning the only list if the other one isn't a list if both of them arent lists.
            firstList
            (if (listp secondList)
                secondList
                nil))   ; Returning null if they bot arent lists
    )
)

(defun recursive-merge (firstList secondList)
    (if (null secondList) ; Base case for returning from function if secondList is empty (null check for last element)
        (return-from recursive-merge firstList)
    )
    (setq firstList (add firstList (car secondList))) ; Adding first member of secondList to firstList
    (recursive-merge firstList (cdr secondList)) ; Recursive call for merging rest of the secondList to the firstList
)

(defun add (aList value)
    (reverse (cons value (reverse aList))) ; Reversing list, adding new cell value to list and reversing again.
)

;; MAIN FUNCTION
(defun main ()
  (with-open-file (stream #p"input_part2.csv")
    (loop :for line := (read-csv-line stream) :while line :collect
      (format t "~a~%"
      ;; CALL YOUR (MAIN) FUNCTION HERE
      (merge-list (read-from-string (nth 0 line)) (read-from-string (nth 1 line)))


      )
    )
  )
)

;; CALL MAIN FUNCTION
(main)
