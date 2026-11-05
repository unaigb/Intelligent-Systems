(defpackage :paquete-unificacion
  (:use :common-lisp :lisp-unit)
  (:export :atomo :es-variable :aparece-en :aplicar :componer :unificar))

(setf DEBUG NIL)

(in-package :paquete-unificacion)
