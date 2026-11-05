(in-package :paquete-unificacion)

(defun unificar (e1 e2)
  (cond
    ;; Son exactamente iguales por lo que no hay sustitución
    ((equal e1 e2) 'NADA)

    ;; e1 es variable
    ((es-variable e1)
     (if (aparece-en e1 e2)
         'FALLO
         (list (list e2 e1))))

    ;; e2 es variable
    ((es-variable e2)
     (if (aparece-en e2 e1)
         'FALLO
         (list (list e1 e2))))

    ;; Ambos son listas por lo que hacemos recursividad
    ((and (listp e1) (listp e2))
     (setf sigma1 (unificar (first e1) (first e2)))
     (cond
       ((eq sigma1 'FALLO) 'FALLO)
       (T
        (setf rest1 (if (eq sigma1 'NADA) (rest e1) (aplicar sigma1 (rest e1))))
        (setf rest2 (if (eq sigma1 'NADA) (rest e2) (aplicar sigma1 (rest e2))))
        (setf sigma2 (unificar rest1 rest2))
        (cond
          ((eq sigma2 'FALLO) 'FALLO)
          ((eq sigma1 'NADA) sigma2)
          ((eq sigma2 'NADA) sigma1)
          (T (componer sigma2 sigma1))))))

    ;; En cualquier otro caso no unificable
    (T 'FALLO)))