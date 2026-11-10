<div align="center">

# 🧠 Sistemas Inteligentes

**Búsqueda A\* en Python, programación lógica en Prolog y unificación de expresiones en Lisp**

[![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)]()
[![Prolog](https://img.shields.io/badge/Prolog-Visual_Prolog-B5322D?style=flat)]()
[![Lisp](https://img.shields.io/badge/Lisp-CLISP-3FB68B?style=flat)]()
[![IA](https://img.shields.io/badge/IA-b%C3%BAsqueda_y_razonamiento-0F172A?style=flat)]()

[Descripción](#-sobre-el-proyecto) · [Búsqueda](#-parte-1--búsqueda-en-el-mapa-de-rumanía) · [Unificación](#-parte-2--unificación-en-lisp) · [Cómo ejecutarlo](#-cómo-ejecutarlo) · [Estructura](#-estructura-del-repositorio) · [Stack](#-stack-tecnológico)

</div>

---

## 📖 Sobre el proyecto

Tres prácticas de *Fundamentos de Sistemas Inteligentes* que ilustran tres maneras distintas de que un programa «razone»: **buscando** caminos en un grafo, **deduciendo** con reglas lógicas y **unificando** expresiones simbólicas.

> 📌 **Proyecto académico** de la asignatura de *Fundamentos de Sistemas Inteligentes* (Universidad de Salamanca, 2025).

---

## 🗺️ Parte 1 · Búsqueda en el mapa de Rumanía

El problema clásico del mapa de Rumanía (Russell y Norvig), con 20 ciudades y las distancias de sus carreteras. El reto: **desde una ciudad de partida, visitar Iasi, Sibiu y Lugoj, en el mejor orden posible, y volver al origen** (una versión del problema del viajante).

Se resuelve de dos formas, para poder compararlas:

| Implementación | Enfoque | Resultado |
| :--- | :--- | :--- |
| **Prolog** (`search/prolog`) | Ruta entre dos ciudades y circuito mediante **permutaciones**, con recursividad. | Encuentra una solución válida, pero **la primera que halla**: no garantiza el menor coste. |
| **Python** (`search/astar-python`) | Algoritmo **A\*** con cola de prioridad y **heurística de distancia en línea recta** (admisible). | Garantiza el **camino más corto** entre cada par de ciudades; prueba las 6 permutaciones y elige la mejor. |

La heurística es la distancia euclídea entre las coordenadas de dos ciudades: `h(n) = √((x₂ − x₁)² + (y₂ − y₁)²)`. Al ser admisible, A\* nunca subestima el coste y por eso el resultado es óptimo. Las reflexiones de la práctica están en [`search/notas.txt`](search/notas.txt).

**Ejemplo real** de ejecución con `Arad` como ciudad de partida:

```text
ORDEN DE VISITA                          | DISTANCIA
-----------------------------------------------------------------
Arad->Iasi->Sibiu->Lugoj->Arad           | 1932 km
Arad->Iasi->Lugoj->Sibiu->Arad           | 2069 km
Arad->Sibiu->Iasi->Lugoj->Arad           | 1789 km
Arad->Sibiu->Lugoj->Iasi->Arad           | 2069 km
Arad->Lugoj->Iasi->Sibiu->Arad           | 1789 km
Arad->Lugoj->Sibiu->Iasi->Arad           | 1932 km

1. Distancia Total Mínima:   1789 km
2. Orden de visita óptimo:   ['Sibiu', 'Iasi', 'Lugoj']
```

---

## 🔣 Parte 2 · Unificación en Lisp

Implementación del **algoritmo de unificación** sobre expresiones simbólicas, el mecanismo que hay detrás de Prolog. Las variables se escriben `(? X)`. El paquete `paquete-unificacion` exporta:

| Función | Qué hace |
| :--- | :--- |
| `atomo` | Indica si una expresión es un átomo. |
| `es-variable` | Indica si una expresión es una variable `(? X)`. |
| `aparece-en` | Comprueba si una variable aparece en una expresión (*occurs check*). |
| `aplicar` | Aplica una sustitución a una expresión. |
| `componer` | Compone dos sustituciones. |
| `unificar` | Devuelve la sustitución que hace iguales dos expresiones, `NADA` si ya lo son o `FALLO` si no se pueden unificar. |

```lisp
(unificar 'f 'f)          ; => NADA        (ya son iguales)
(unificar 'A '(? X))      ; => ((A (? X))) (sustituye X por A)
```

---

## 🚀 Cómo ejecutarlo

**Python** (3.8 o superior, solo biblioteca estándar):

```bash
python search/astar-python/AEstrella.py
```

**Lisp** (pensado para [CLISP](https://clisp.sourceforge.io/)). Desde `lisp-unification/`, carga los ficheros en este orden:

```lisp
(load "lisp-unit.lisp")
(load "paquete-unificacion.lisp")
(load "atomo.lisp")
(load "es-variable.lisp")
(load "aparece-en.lisp")
(load "aplicar.lisp")
(load "componer.lisp")
(load "unificar.lisp")
(in-package :paquete-unificacion)
(unificar 'A '(? X))
```

**Prolog:** abre `search/prolog/Busqueda2025.vpr` con Visual Prolog.

---

## 📂 Estructura del repositorio

```
Intelligent-Systems/
├── search/
│   ├── astar-python/AEstrella.py     # A* y circuito del viajante
│   ├── prolog/Busqueda2025.*         # Proyecto de Visual Prolog
│   └── notas.txt                     # Comentarios sobre la práctica
└── lisp-unification/
    ├── paquete-unificacion.lisp      # Definición del paquete
    ├── atomo · es-variable · aparece-en · aplicar · componer · unificar  (.lisp)
    └── lisp-unit.lisp                # Mini framework de aserciones
```

---

## 🖥️ Stack tecnológico

| Categoría | Herramientas |
| :--- | :--- |
| **Lenguajes** | Python · Prolog (Visual Prolog) · Common Lisp |
| **Algoritmos** | A\* · búsqueda con permutaciones · unificación con *occurs check* |
| **Conceptos** | Heurísticas admisibles · recursividad · programación lógica y funcional |

---

## 🎓 Qué aprendí

- Que **una heurística admisible** es lo que convierte la búsqueda en una garantía de optimalidad.
- La diferencia entre **encontrar una solución** y **encontrar la mejor**.
- Cómo funciona por dentro la **unificación**, base de la programación lógica.

---

## 📝 Notas

- La práctica incluía además ejercicios con **G2** (de Gensym), un software comercial cuyos ejecutables, manuales y licencia no se redistribuyen y por tanto no forman parte de este repositorio.
- El banco de pruebas de la asignatura para la parte de Lisp tampoco se incluye.

---

## 👤 Autoría

**Unai García** — Grado en Ingeniería Informática (Universidad de Salamanca)

- 🐙 GitHub: [@unaigb](https://github.com/unaigb)
- 🌐 Portfolio: [unaigb.dev](https://unaigb.dev)

---

<div align="center">

**⭐ Si este repositorio te resulta útil, considera darle una estrella.**

</div>
