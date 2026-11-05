(in-package :paquete-unificacion)

(defun componer (s1 s2)
  (cond
    ((eq s1 'NADA) s2)
    ((eq s2 'NADA) s1)
    ((null s1) s2)
    ((null s2) s1)
    (T (append 
         (procesar-s1 s1 s2)
         (filtrar-s2 s1 s2)))))

;; Aplica s2 a cada valor de s1
(defun procesar-s1 (s1 s2)
  (cond
    ((null s1) NIL)
    (T (cons 
         (list (aplicar s2 (first (first s1))) (second (first s1)))
         (procesar-s1 (rest s1) s2)))))

;; Filtra s2 eliminando variables que ya están en s1
(defun filtrar-s2 (s1 s2)
  (cond
    ((null s2) NIL)
    ((esta-variable-en-s1 (second (first s2)) s1)
     (filtrar-s2 s1 (rest s2)))
    (T (cons (first s2) (filtrar-s2 s1 (rest s2))))))

;; Verifica si una variable está en s1
(defun esta-variable-en-s1 (var s1)
  (cond
    ((null s1) NIL)
    ((equal var (second (first s1))) T)
    (T (esta-variable-en-s1 var (rest s1)))))
