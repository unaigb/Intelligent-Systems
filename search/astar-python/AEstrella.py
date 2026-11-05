#-------------------------------------------
#               AUTOR
#   UNAI GARCÍA BLANCO
#-------------------------------------------

import heapq
import itertools
import math

# ============================================================================
# 1. DATOS DEL PROBLEMA: MAPA Y COORDENADAS
# ============================================================================

mapa_rumania = {
    'Arad': [('Zerind', 75), ('Sibiu', 140), ('Timisoara', 118)],
    'Zerind': [('Arad', 75), ('Oradea', 71)],
    'Oradea': [('Zerind', 71), ('Sibiu', 151)],
    'Sibiu': [('Arad', 140), ('Oradea', 151), ('Fagaras', 99), ('Rimnicu Vilcea', 80)],
    'Timisoara': [('Arad', 118), ('Lugoj', 111)],
    'Lugoj': [('Timisoara', 111), ('Mehadia', 70)],
    'Mehadia': [('Lugoj', 70), ('Dobreta', 75)],
    'Dobreta': [('Mehadia', 75), ('Craiova', 120)],
    'Craiova': [('Dobreta', 120), ('Rimnicu Vilcea', 146), ('Pitesti', 138)],
    'Rimnicu Vilcea': [('Sibiu', 80), ('Craiova', 146), ('Pitesti', 97)],
    'Fagaras': [('Sibiu', 99), ('Bucharest', 211)],
    'Pitesti': [('Rimnicu Vilcea', 97), ('Craiova', 138), ('Bucharest', 101)],
    'Bucharest': [('Fagaras', 211), ('Pitesti', 101), ('Giurgiu', 90), ('Urziceni', 85)],
    'Giurgiu': [('Bucharest', 90)],
    'Urziceni': [('Bucharest', 85), ('Hirsova', 98), ('Vaslui', 142)],
    'Hirsova': [('Urziceni', 98), ('Eforie', 86)],
    'Eforie': [('Hirsova', 86)],
    'Vaslui': [('Urziceni', 142), ('Iasi', 92)],
    'Iasi': [('Vaslui', 92), ('Neamt', 87)],
    'Neamt': [('Iasi', 87)]
}

# Coordenadas (x, y) aproximadas para la heurística.
# Fuente: Russell & Norvig (AIMA).
coordenadas = {
    'Arad': (91, 492), 'Zerind': (108, 531), 'Oradea': (131, 571),
    'Sibiu': (207, 457), 'Fagaras': (305, 449), 'Timisoara': (94, 410),
    'Lugoj': (165, 379), 'Mehadia': (168, 339), 'Dobreta': (165, 279),
    'Craiova': (253, 288), 'Rimnicu Vilcea': (233, 410), 'Pitesti': (320, 368),
    'Bucharest': (400, 181), 'Giurgiu': (375, 80), 'Urziceni': (456, 229),
    'Hirsova': (534, 227), 'Eforie': (562, 129), 'Vaslui': (509, 344),
    'Iasi': (477, 417), 'Neamt': (406, 437)
}

# ============================================================================
# 2. ALGORITMO A* (A-STAR)
# ============================================================================

def calcular_heuristica(ciudad_actual, ciudad_destino):
    """
    Calcula la distancia en línea recta (Euclídea) entre dos ciudades.
    h(n) = sqrt((x2 - x1)^2 + (y2 - y1)^2)
    """
    if ciudad_actual not in coordenadas or ciudad_destino not in coordenadas:
        return 0
    
    x1, y1 = coordenadas[ciudad_actual]
    x2, y2 = coordenadas[ciudad_destino]
    
    return math.hypot(x2 - x1, y2 - y1)

def busqueda_a_estrella(inicio, destino):
    """
    Ejecuta el algoritmo A* para encontrar el camino más corto entre dos ciudades.
    Retorna: (coste_total, lista_de_ciudades)
    """

    cola_prioridad = []
    
    h_inicial = calcular_heuristica(inicio, destino)
    heapq.heappush(cola_prioridad, (h_inicial, 0, inicio, [inicio]))
    
    visitados = set()
    
    while cola_prioridad:
        f, g, actual, camino = heapq.heappop(cola_prioridad)
        
        if actual == destino:
            return g, camino

        if actual in visitados:
            continue
        visitados.add(actual)

        vecinos = mapa_rumania.get(actual, [])
        for vecino, distancia_km in vecinos:
            if vecino not in visitados:
                nuevo_g = g + distancia_km
                nuevo_h = calcular_heuristica(vecino, destino)
                nuevo_f = nuevo_g + nuevo_h
                nuevo_camino = camino + [vecino]
                
                heapq.heappush(cola_prioridad, (nuevo_f, nuevo_g, vecino, nuevo_camino))

    return float('inf'), []

# ============================================================================
# 3. LÓGICA DEL CIRCUITO (RESOLUCIÓN DEL PROBLEMA)
# ============================================================================

def resolver_circuito_viajero(ciudad_origen):
    """
    Calcula el circuito óptimo que parte de 'ciudad_origen', visita obligatoriamente
    Iasi, Sibiu y Lugoj (en el mejor orden posible) y regresa a 'ciudad_origen'.
    """
    
    ciudades_a_visitar = ['Iasi', 'Sibiu', 'Lugoj']
    
    # Si la ciudad de origen es una de las de destino, la quitamos de la lista intermedia
    # para evitar redundancias (ej: ir de Lugoj a Lugoj), aunque el algoritmo lo manejaría (coste 0).
    objetivos_intermedios = [c for c in ciudades_a_visitar if c != ciudad_origen]
    
    print(f"\n--- Calculando rutas desde: {ciudad_origen} ---")
    print(f"Objetivos a cubrir: {objetivos_intermedios} (y vuelta al inicio)")
    print("-" * 65)
    print(f"{'ORDEN DE VISITA':<40} | {'DISTANCIA':<15}")
    print("-" * 65)
    
    mejor_distancia = float('inf')
    mejor_ruta_completa = []
    mejor_orden = []
    
    permutaciones = itertools.permutations(objetivos_intermedios)
    
    for perm in permutaciones:
        itinerario = [ciudad_origen] + list(perm) + [ciudad_origen]
        
        distancia_total_itinerario = 0
        ruta_completa_itinerario = []
        es_valido = True

        for i in range(len(itinerario) - 1):
            tramo_inicio = itinerario[i]
            tramo_fin = itinerario[i+1]

            coste_tramo, ruta_tramo = busqueda_a_estrella(tramo_inicio, tramo_fin)
            
            if coste_tramo == float('inf'):
                es_valido = False
                break
            
            distancia_total_itinerario += coste_tramo

            if i == 0:
                ruta_completa_itinerario.extend(ruta_tramo)
            else:
                ruta_completa_itinerario.extend(ruta_tramo[1:])

        if es_valido:
            etiqueta = f"{ciudad_origen}->" + "->".join(perm) + f"->{ciudad_origen}"
            print(f"{etiqueta:<40} | {distancia_total_itinerario} km")
            
            if distancia_total_itinerario < mejor_distancia:
                mejor_distancia = distancia_total_itinerario
                mejor_ruta_completa = ruta_completa_itinerario
                mejor_orden = list(perm)

    return mejor_distancia, mejor_ruta_completa, mejor_orden

# ============================================================================
# 4. INTERFAZ DE USUARIO
# ============================================================================

def main():
    print("\n============================================================")
    print("      PRÁCTICA PARTE 2: CIRCUITO TURÍSTICO CON A*")
    print("============================================================")
    
    ciudades_lista = sorted(mapa_rumania.keys())
    print(f"Ciudades disponibles: {', '.join(ciudades_lista)}\n")
    
    while True:
        entrada = input(">> Introduce la ciudad de partida (ej: Arad): ").strip()

        if entrada:
            ciudad = entrada[0].upper() + entrada[1:].lower()
            if ciudad in mapa_rumania:
                break
            else:
                print("Error: Ciudad no encontrada en el mapa.")
        else:
            print("Introduce un nombre.")

    distancia, ruta, orden = resolver_circuito_viajero(ciudad)
    
    print("\n" + "="*65)
    print("                 RESULTADO ÓPTIMO FINAL")
    print("="*65)
    
    if distancia < float('inf'):
        print(f"1. Distancia Total Mínima:   {distancia} km")
        print(f"2. Orden de visita óptimo:   {orden}")
        print(f"3. Ruta detallada completa:  {' -> '.join(ruta)}")
        print(f"4. Ciudades transitadas:     {len(ruta)}")
    else:
        print("No se encontró solución posible.")

if __name__ == "__main__":
    main()