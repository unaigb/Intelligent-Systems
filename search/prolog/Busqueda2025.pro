/*****************************************************************************

        Copyright (c) My Company

 Project:  BUSQUEDA2025
 FileName: BUSQUEDA2025.PRO
 Purpose: Practica Sistemas Inteligentes
 Written by: Visual Prolog
 Comments:
******************************************************************************/

domains
    ciudad = symbol
    distancia = integer
    lista = ciudad*

predicates
    % --- Datos del Mapa ---
    carretera(ciudad, ciudad, distancia)
    conectado(ciudad, ciudad, distancia)

    % --- Apartado 1: Ruta entre dos ciudades ---
    ruta(ciudad, ciudad, lista, distancia)
    ruta_busqueda(ciudad, ciudad, lista, lista, distancia)

    % --- Apartado 2: Circuito Viajante ---
    circuito_viajero(lista, distancia, ciudad)
    viaje_etapas(ciudad, lista, ciudad, lista, distancia)
    
    % --- Utilidades ---
    miembro(ciudad, lista)
    inversa(lista, lista)
    concatenar(lista, lista, lista)
    longitud(lista, integer)
    permutacion(lista, lista)
    borrar(ciudad, lista, lista)
    tramo_sin_cabeza(lista, lista)

clauses

    % --- Base de conocimiento ---
    
    carretera(oradea, zerind, 71).
    carretera(oradea, sibiu, 151).
    carretera(zerind, arad, 75).
    carretera(arad, sibiu, 140).
    carretera(arad, timisoara, 118).
    carretera(timisoara, lugoj, 111).
    carretera(lugoj, mehadia, 70).
    carretera(mehadia, dobreta, 75).
    carretera(dobreta, craiova, 120).
    carretera(craiova, rimnicu_vilcea, 146).
    carretera(craiova, pitesti, 138).
    carretera(rimnicu_vilcea, sibiu, 80).
    carretera(rimnicu_vilcea, pitesti, 97).
    carretera(sibiu, fagaras, 99).
    carretera(fagaras, bucharest, 211).
    carretera(pitesti, bucharest, 101).
    carretera(bucharest, giurgiu, 90).
    carretera(bucharest, urziceni, 85).
    carretera(urziceni, hirsova, 98).
    carretera(hirsova, eforie, 86).
    carretera(urziceni, vaslui, 142).
    carretera(vaslui, iasi, 92).
    carretera(iasi, neamt, 87).

    % Regla para bidireccionalidad
    conectado(A, B, Dist):- carretera(A, B, Dist).
    conectado(A, B, Dist):- carretera(B, A, Dist).


    % --- Lógica del Apartado 1 ---

    ruta(Inicio, Fin, Camino, Dist):-
        ruta_busqueda(Inicio, Fin, [Inicio], CaminoInvertido, Dist),
        inversa(CaminoInvertido, Camino).

    ruta_busqueda(Fin, Fin, Visitados, Visitados, 0).

    ruta_busqueda(Actual, Fin, Visitados, Camino, DistTotal):-
        conectado(Actual, Siguiente, DistPaso),
        not(miembro(Siguiente, Visitados)),
        ruta_busqueda(Siguiente, Fin, [Siguiente|Visitados], Camino, DistResto),
        DistTotal = DistPaso + DistResto.


    % --- Lógica del Apartado 2 ---

    circuito_viajero(CaminoCompleto, DistTotal, Inicio):-
        Destinos = [iasi, sibiu, lugoj],
        permutacion(Destinos, DestinosOrdenados),
        nl, write("Probando orden: ", DestinosOrdenados), nl,
        viaje_etapas(Inicio, DestinosOrdenados, Inicio, CaminoCompleto, DistTotal),
        !.

    % Caso Base: No quedan destinos intermedios, volvemos al 'Home' (Inicio)
    viaje_etapas(Actual, [], Home, CaminoFinal, Dist):-
        ruta(Actual, Home, CaminoFinal, Dist).
    
    % Caso Recursivo
    viaje_etapas(Actual, [SiguienteDestino|RestoDestinos], Home, CaminoTotal, DistTotal):-
        ruta(Actual, SiguienteDestino, Tramo, DistTramo),
        viaje_etapas(SiguienteDestino, RestoDestinos, Home, CaminoResto, DistResto),
        DistTotal = DistTramo + DistResto,
        tramo_sin_cabeza(CaminoResto, CaminoRestoSinCabeza),
        concatenar(Tramo, CaminoRestoSinCabeza, CaminoTotal).

    % --- Predicados auxiliares ---

    miembro(X, [X|_]).
    miembro(X, [_|Cola]):- miembro(X, Cola).

    inversa([], []).
    inversa([H|T], L):- inversa(T, R), concatenar(R, [H], L).

    concatenar([], L, L).
    concatenar([H|T], L, [H|R]):- concatenar(T, L, R).

    permutacion([], []).
    permutacion(L, [X|P]):- borrar(X, L, R), permutacion(R, P).

    borrar(X, [X|R], R).
    borrar(X, [Y|R], [Y|S]):- borrar(X, R, S).

    longitud([], 0).
    longitud([_|T], N):- longitud(T, N0), N = N0 + 1.
    
    tramo_sin_cabeza([], []).
    tramo_sin_cabeza([_|T], T).

goal
    write("--- APARTADO 1: ---"), nl,
    ruta(arad, bucharest, Ruta, Distancia),
    write("Camino: ", Ruta), nl,
    write("Distancia: ", Distancia), nl,
    
    write("\n--- APARTADO 2: ---"), nl,
    circuito_viajero(CaminoCircuito, DistCircuito, bucharest),
    write("Circuito completo: ", CaminoCircuito), nl,
    write("Distancia Total: ", DistCircuito), nl,
    !.