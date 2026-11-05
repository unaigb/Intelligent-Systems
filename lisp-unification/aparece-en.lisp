(in-package :paquete-unificacion)

(defun aparece-en (var lista)
	(cond
		((equal var lista) T)
		((atomo lista) NIL)
		(T (or (aparece-en var (first lista))
			(aparece-en var (rest lista))
			)
		)
	)
)
