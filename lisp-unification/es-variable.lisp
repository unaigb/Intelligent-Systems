(in-package :paquete-unificacion)

(defun es-variable (var)
  (cond 
    ((atom var) NIL)
    ((and (eq (first var) '?) (eq (rest (rest var)) NIL)) T)
    (T NIL)
  )
)
