(defun write-recursive (token-list file-stream)
    (if (null (car token-list)) (return-from write-recursive))
    (format file-stream "~W~%" (car token-list))
    (write-recursive (cdr token-list) file-stream)
)

(defun write-tokens-to-file (list)
    (with-open-file (stream "161044057.tree"
                        :direction :output
                        :if-does-not-exist :create)
        (format stream "; DIRECTIVE: print~%")
        (write-recursive list stream)
    )
)

(defun parser (token-list)
    (write-tokens-to-file token-list)
)