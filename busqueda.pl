:- [heuristicas].
:- [minero].
:- [auxiliares].
:- [celdas].
:- dynamic frontera/1, visitados/1.

% ------------------------------ BUSCAR PLAN --------------------------------%
% ------------ buscar_plan(+EstadoInicial, -Plan, -Destino, -Costo) ---------%

buscar_plan(EstadoInicial, Plan, Destino, Costo):-
    vaciar_estructuras(),
    calcular_heuristica(EstadoInicial, Heuristica),
    assertz(frontera(nodo(EstadoInicial, [], 0, Heuristica))),
    aEstrella(Plan, Costo, Destino).

buscar_plan(_,_,_,_):-
    writeln('No se pudo encontrar un plan para el estado ingresado.'), 
    fail.

% -------------------------  METODO DE BUSQUEDA A* --------------------------%
% ----------------- aEstrella(-Solucion, -Costo, -Destino) ----------------- %

aEstrella(Solucion, Costo, Destino):-
    Nodo = nodo(Estado, Camino, Costo, _Heuristica),
    seleccionar(Nodo),
    esMeta(Estado),
    !,
    Estado = [Destino, _, _, _],
    reverse(Camino, Solucion).

aEstrella(Solucion, Costo, Destino):-
    seleccionar(Nodo),
    agregar_visitados(Nodo),
    eliminar_nodo_frontera(Nodo),
    generar_vecinos(Nodo, Vecinos),
    agregar_vecinos(Vecinos),
    aEstrella(Solucion, Costo, Destino).


% ----------------------------- SELECCIONAR ------------------------------- %
% -------------------------- seleccionar(-Nodo) --------------------------- %

% Selecciona el nodo minimo de la frontera.
seleccionar(Nodo) :-
    findall( nodo(Estado, Camino, Costo, Heuristica), 
          (frontera(nodo(Estado, Camino, Costo, Heuristica))),
             [Vecino|RestoVecinos]),
    seleccionar(Vecino, RestoVecinos, Nodo).
  
seleccionar(Nodo, [], Nodo).
seleccionar(nodo(Estado, Camino, Costo, Heuristica), [nodo(Estado2, Camino2, Costo2, Heuristica2)|RestoVecinos], Nodo) :-
    Total is Costo+Heuristica,
    Total2 is Costo2+Heuristica2,
    Total < Total2 -> 
        seleccionar(nodo(Estado, Camino, Costo, Heuristica), RestoVecinos, Nodo) ;
        seleccionar(nodo(Estado2, Camino2, Costo2, Heuristica2),    RestoVecinos, Nodo).


% -------------------------- AGREGAR VISITADOS ---------------------------- %
% ------------------------ agregar_visitados(+Nodo) ------------------------%
% Agrega en los nodos visitados el nodo enviado como parametro
agregar_visitados(Nodo):-
    assertz(visitados(Nodo)).


% -------------------------- GENERAR VECINOS ------------------------------ %
% ------------------ generar_vecinos(+Nodo, -Vecinos) ----------------------%

% Se generan todos los vecinos del nodo ingresado como parametro, con sus
% respectivos costos y heuristicas.
generar_vecinos(nodo(Estado, Camino, Costo, _Heuristica), NuevosVecinos):-
    findall(
        nodo(EstadoVecino, [Operador|Camino], CostoVecino, Heuristica),
            (realizar_movimiento(Estado, EstadoVecino, Operador, CostoMovimiento),
            CostoVecino is CostoMovimiento + Costo,
            calcular_heuristica(EstadoVecino, Heuristica)),
            Vecinos),
    control_visitados(Vecinos, NuevosVecinos).

% -------------------------- AGREGAR VECINOS ------------------------------ %
% -------------------------- agregar_vecinos(+Nodo) ----------------------- %

% Agrega en la frontera el nodo enviado como parametro
agregar_vecinos([]):-
    !.

agregar_vecinos([Vecino|RestoVecinos]):-
    assertz(frontera(Vecino)),
    agregar_vecinos(RestoVecinos).


% ---------------------- eliminar_nodo_frontera(+Nodo) ----------------------- %
% Elimina el nodo enviado como parametro de la frontera
eliminar_nodo_frontera(Nodo):-
    retract(frontera(Nodo)).
    
% -------------------------- VACIAR ESTRUCTURAS ------------------------------ %
% ------------------------- vaciar_estructuras() ----------------------------- % 

% Se vacian las estructuras generadas en ejecuciones anteriores.
vaciar_estructuras():-
    retractall(frontera(_)),
    retractall(visitados(_)).



% -------------------------- CONTROL DE VISITADOS --------------------------- %
% --------------- control_visitados(+Vecinos, -NuevosVecinos) --------------- %

% Caso 1 (o caso base): Si no tiene vecinos, no se necesitan controles
control_visitados([], []):- !.

% Caso 2: Si existe en la Frontera un nodo N etiquetado con el estado E tal que f(N’) < f(N), 
% entonces reemplazamos N en la Frontera por el nodo N’
control_visitados(Vecinos, NuevosVecinos):-
    Vecinos = [Nodo | RestoVecinos],
    Nodo = nodo(Estado, Camino, G, H),
    frontera(nodo(Estado, Camino2, G2, H2)),
    Costo is G + H,
    Costo2 is G2 + H2,
    Costo2 > Costo, 
    !,
    retract(frontera(nodo(Estado, Camino2, G2, H2))),
    assertz(frontera(nodo(Estado, Camino, G, H))),
    control_visitados(RestoVecinos, NuevosVecinos).

% Caso 3: Si existe en el conjunto de nodos Visitados un nodo N etiquetado con el estado E tal que f(N’) < f(N) 
% entonces removemos el nodo N del conjunto de Visitados y añadimos a la Frontera el nodo N’.
control_visitados(Vecinos, NuevosVecinos):-
    Vecinos = [Nodo | RestoVecinos],
    Nodo = nodo(Estado, Camino, G, H),
    visitados(nodo(Estado, Camino2, G2, H2)),
    Costo is G + H,
    Costo2 is G2 + H2,
    Costo2 > Costo,
    !,
    retract(visitados(nodo(Estado, Camino2, G2, H2))),
    assertz(frontera(nodo(Estado, Camino, G, H))),
    control_visitados(RestoVecinos, NuevosVecinos).

% Caso 4: Si existe en la Frontera un nodo N etiquetado con el estado E tal que f(N’) >= f(N), 
% entonces se descarta el nodo N’ (no se efectúan cambios en la Frontera). 
control_visitados(Vecinos, NuevosVecinos):-
    Vecinos = [Nodo | RestoVecinos],
    Nodo = nodo(Estado, _, G, H),
    frontera(nodo(Estado, _, G2, H2)),
    Costo is G + H,
    Costo2 is G2 + H2,
    Costo2 =< Costo, 
    control_visitados(RestoVecinos, NuevosVecinos).

% Caso 5: Si existe en el conjunto de Visitados un nodo N etiquetado con el estado E tal que f(N’) >= f(N),
% entonces se descarta el nodo N’ (no se efectúan cambios en Visitados).  
control_visitados(Vecinos, NuevosVecinos):-
    Vecinos = [Nodo | RestoVecinos],
    Nodo = nodo(Estado, _, G, H),
    visitados(nodo(Estado, _, G2, H2)),
    Costo is G + H,
    Costo2 is G2 + H2,
    Costo2 =< Costo,
    control_visitados(RestoVecinos, NuevosVecinos).

% Caso 6: Si no existe en la Frontera ni en el conjunto de Visitados un nodo N etiquetado con el estado E, 
% entonces añadimos a la Frontera el nodo N
control_visitados([Nodo|Vecinos], [Nodo|NuevosVecinos]):-
    control_visitados(Vecinos, NuevosVecinos).