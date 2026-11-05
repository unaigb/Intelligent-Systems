(defpackage :lisp-unit
  (:use :common-lisp)
  (:export :define-test :assert-equal :run-tests))

(in-package :lisp-unit)

(defmacro define-test (name &body body)
  `(progn
     (format t "~%Ejecutando test: ~A~%" ',name)
     ,@body))

(defun assert-equal (expected actual)
  (if (equal expected actual)
      (format t " [OK]: ~A == ~A~%" expected actual)
      (progn
        (format t " [ERROR]: {ESPERADO: ~A } != {RECIBIDO: ~A }~%" expected actual)
        (ext:exit 1)
      )
  )
)

(defun run-tests ()
  (format t "Todas las pruebas ejecutadas.~%"))
