(in-package :paquete-unificacion)

(defun aplicar (sustituciones lista)
  (cond
    ;; Caso 1: No hay sustituciones
    ((eq sustituciones 'NADA) lista)

    ;; Caso 2: La lista es una variable
    ((es-variable lista)
     (cond
       ((null sustituciones) lista)
       ((equal (second (first sustituciones)) lista)
        (first (first sustituciones)))
       (T (aplicar (rest sustituciones) lista))))

    ;; Caso 3: Lista vacía
    ((null lista) lista)

    ;; Caso 4: Es una lista no vacía → aplicar recursivamente
    ((listp lista)
     (cons (aplicar sustituciones (first lista))
           (aplicar sustituciones (rest lista))))

    ;; Caso base: átomo sin sustitución
    (T lista)
  )
)

