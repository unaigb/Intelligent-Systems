(in-package :paquete-unificacion)

(defun atomo (var)
  (cond ((atom var) T)
        ((and (eq (first var) '?)
              (eq (rest (rest var)) NIL)) T)
        (T NIL)
  )
)
