% ------------------------ REALIZAR MOVIMIENTO -------------------------- %
% --- realizar_movimiento(EstadoActual, EstadoNuevo, Operador, Costo) --- %

% Metodo cascara utilizado desde clase busqueda para realizar un movimiento.
realizar_movimiento(EstadoActual, EstadoFinal, detonar, Costo):-
    detonar(EstadoActual, EstadoFinal, Costo).

realizar_movimiento(EstadoActual, EstadoFinal, caminar, Costo):-
    caminar(EstadoActual, EstadoFinal, Costo).

realizar_movimiento(EstadoActual, [Posicion, Direccion, Objetos, ColocacionCargaPendiente], rotar(Direccion), Costo):-
    rotar(EstadoActual, [Posicion, Direccion, Objetos, ColocacionCargaPendiente], Costo).

realizar_movimiento(EstadoActual, EstadoFinal, saltar_valla, Costo):-
    saltar_valla(EstadoActual, EstadoFinal, Costo).

realizar_movimiento(EstadoActual, EstadoFinal, juntar_llave, Costo):-
    juntar_llave(EstadoActual, EstadoFinal, Costo).

realizar_movimiento(EstadoActual, EstadoFinal, juntar_carga, Costo):-
    juntar_carga(EstadoActual, EstadoFinal, Costo).

realizar_movimiento(EstadoActual, EstadoFinal, juntar_detonador, Costo):-
    juntar_detonador(EstadoActual, EstadoFinal, Costo).

realizar_movimiento(EstadoActual, EstadoFinal, dejar_carga, Costo):-
    dejar_carga(EstadoActual, EstadoFinal, Costo).



%----------------------------------------------------------------------%
% ----------------------- ACCIONES DEL MINERO -------------------------%

% ---------- detonar(+EstadoActual, -EstadoFinal, -Costo) ---------------%

% Accion: detonar la carga dejada en sitio de detonacion.
detonar([[X, Y], Direccion, ListaPosesiones, no], [[X, Y], Direccion, ListaPosesionesModificada, no], Costo):-
    member([d, NombreDetonador, no], ListaPosesiones),
    sitioDetonacion([X, Y]),
    delete(ListaPosesiones, [d, NombreDetonador, no], ListaAuxiliar),
    append(ListaAuxiliar, [[d, NombreDetonador, si]], ListaPosesionesModificada),
    Costo is 1.


% ---------- caminar(+EstadoActual,-EstadoFinal,-Costo) ---------------%

% Accion: caminar hacia el norte sobre piso firme cuando no hay obstaculos
caminar([[X, Y], n, Objetos, ColocacionCargaPendiente], [[X2, Y2], n, Objetos, ColocacionCargaPendiente], Costo):-
    Y2 is Y,
    X2 is X-1,
    celda([X2, Y2], firme),
    not(hayPilar([X2, Y2])),
    not(hayValla([X2, Y2])),
    not(hayReja([X2,Y2])),
    Costo is 2.

% Accion: caminar hacia el sur sobre piso firme cuando no hay obstaculos
caminar([[X, Y], s, Objetos, ColocacionCargaPendiente], [[X2, Y2], s, Objetos, ColocacionCargaPendiente], Costo):-
    Y2 is Y,
    X2 is X+1,
    celda([X2, Y2], firme),
    not(hayPilar([X2, Y2])),
    not(hayValla([X2, Y2])),
    not(hayReja([X2,Y2])),
    Costo is 2.

% Accion: caminar hacia el este sobre piso firme cuando no hay obstaculos
caminar([[X, Y], e, Objetos, ColocacionCargaPendiente], [[X2, Y2], e, Objetos, ColocacionCargaPendiente], Costo):-
    Y2 is Y+1,
    X2 is X,
    celda([X2, Y2], firme),
    not(hayPilar([X2, Y2])),
    not(hayValla([X2, Y2])),
    not(hayReja([X2,Y2])),
    Costo is 2.

% Accion: caminar hacia el oeste sobre piso firme cuando no hay obstaculos
caminar([[X, Y], o, Objetos, ColocacionCargaPendiente], [[X2, Y2], o, Objetos, ColocacionCargaPendiente], Costo):-
    Y2 is Y-1,
    X2 is X,
    celda([X2, Y2], firme),
    not(hayPilar([X2, Y2])),
    not(hayValla([X2, Y2])),
    not(hayReja([X2,Y2])),
    Costo is 2.

% Accion: caminar hacia el norte sobre piso resbaladizo cuando no hay obstaculos
caminar([[X, Y], n, Objetos, ColocacionCargaPendiente], [[X2, Y2], n, Objetos, ColocacionCargaPendiente], Costo):-
    Y2 is Y,
    X2 is X-1,
    celda([X2, Y2], resbaladizo),
    not(hayPilar([X2, Y2])),
    not(hayValla([X2, Y2])),
    not(hayReja([X2,Y2])),    
    Costo is 3.

% Accion: caminar hacia el sur sobre piso resbaladizo cuando no hay obstaculos
caminar([[X, Y], s, Objetos, ColocacionCargaPendiente], [[X2, Y2], s, Objetos, ColocacionCargaPendiente], Costo):-
    Y2 is Y,
    X2 is X+1,
    celda([X2, Y2], resbaladizo),
    not(hayPilar([X2, Y2])),
    not(hayValla([X2, Y2])),
    not(hayReja([X2,Y2])),
    Costo is 3.

% Accion: caminar hacia el este sobre piso resbaladizo cuando no hay obstaculos
caminar([[X, Y], e, Objetos, ColocacionCargaPendiente], [[X2, Y2], e, Objetos, ColocacionCargaPendiente], Costo):-
    Y2 is Y+1,
    X2 is X,
    celda([X2, Y2], resbaladizo),
    not(hayPilar([X2, Y2])),
    not(hayValla([X2, Y2])),
    not(hayReja([X2,Y2])),
    Costo is 3.

% Accion: caminar hacia el oeste sobre piso resbaladizo cuando no hay obstaculos
caminar([[X, Y], o, Objetos, ColocacionCargaPendiente], [[X2, Y2], o, Objetos, ColocacionCargaPendiente], Costo):-
    Y2 is Y-1,
    X2 is X,
    celda([X2, Y2], resbaladizo),
    not(hayPilar([X2, Y2])),
    not(hayValla([X2, Y2])),
    not(hayReja([X2,Y2])),
    Costo is 3.

% Accion: caminar hacia el norte sobre piso firme cuando hay una reja
caminar([[X, Y], n, Objetos, ColocacionCargaPendiente], [[X2, Y2], n, Objetos, ColocacionCargaPendiente], Costo):-
    Y2 is Y,
    X2 is X-1,
    celda([X2, Y2], firme),
    estaEn([r, NombreReja], [X2,Y2]),
    tieneLlave(Objetos, [l, NombreLlave]),
    abreReja([l, NombreLlave], [r, NombreReja]),
    Costo is 2.

% Accion: caminar hacia el sur sobre piso firme cuando hay una reja
caminar([[X, Y], s, Objetos, ColocacionCargaPendiente], [[X2, Y2], s, Objetos, ColocacionCargaPendiente], Costo):-
    Y2 is Y,
    X2 is X+1,
    celda([X2, Y2], firme),
    estaEn([r, NombreReja], [X2,Y2]),
    tieneLlave(Objetos, [l, NombreLlave]),
    abreReja([l, NombreLlave], [r, NombreReja]),
    Costo is 2.

% Accion: caminar hacia el este sobre piso firme cuando hay una reja
caminar([[X, Y], e, Objetos, ColocacionCargaPendiente], [[X2, Y2], e, Objetos, ColocacionCargaPendiente], Costo):-
    Y2 is Y+1,
    X2 is X,
    celda([X2, Y2], firme),
    estaEn([r, NombreReja], [X2,Y2]),
    tieneLlave(Objetos, [l, NombreLlave]),
    abreReja([l, NombreLlave], [r, NombreReja]),
    Costo is 2.

% Accion: caminar hacia el oeste sobre piso firme cuando hay una reja
caminar([[X, Y], o, Objetos, ColocacionCargaPendiente], [[X2, Y2], o, Objetos, ColocacionCargaPendiente], Costo):-
    Y2 is Y-1,
    X2 is X,
    celda([X2, Y2], firme),
    estaEn([r, NombreReja], [X2,Y2]),
    tieneLlave(Objetos, [l, NombreLlave]),
    abreReja([l, NombreLlave], [r, NombreReja]),
    Costo is 2.

% Accion: caminar hacia el norte sobre piso resbaladizo cuando hay una reja
caminar([[X, Y], n, Objetos, ColocacionCargaPendiente], [[X2, Y2], n, Objetos, ColocacionCargaPendiente], Costo):-
    Y2 is Y,
    X2 is X-1,
    celda([X2, Y2], resbaladizo),
    estaEn([r, NombreReja], [X2,Y2]),
    tieneLlave(Objetos, [l, NombreLlave]),
    abreReja([l, NombreLlave], [r, NombreReja]),
    Costo is 2.

% Accion: caminar hacia el sur sobre piso resbaladizo cuando hay una reja
caminar([[X, Y], s, Objetos, ColocacionCargaPendiente], [[X2, Y2], s, Objetos, ColocacionCargaPendiente], Costo):-
    Y2 is Y,
    X2 is X+1,
    celda([X2, Y2], resbaladizo),
    estaEn([r, NombreReja], [X2,Y2]),
    tieneLlave(Objetos, [l, NombreLlave]),
    abreReja([l, NombreLlave], [r, NombreReja]),
    Costo is 2.

% Accion: caminar hacia el este sobre piso resbaladizo cuando hay una reja
caminar([[X, Y], e, Objetos, ColocacionCargaPendiente], [[X2, Y2], e, Objetos, ColocacionCargaPendiente], Costo):-
    Y2 is Y+1,
    X2 is X,
    celda([X2, Y2], resbaladizo),
    estaEn([r, NombreReja], [X2,Y2]),
    tieneLlave(Objetos, [l, NombreLlave]),
    abreReja([l, NombreLlave], [r, NombreReja]),
    Costo is 2.

% Accion: caminar hacia el oeste sobre piso resbaladizo cuando hay una reja
caminar([[X, Y], o, Objetos, ColocacionCargaPendiente], [[X2, Y2], o, Objetos, ColocacionCargaPendiente], Costo):-
    Y2 is Y-1,
    X2 is X,
    celda([X2, Y2], resbaladizo),
    estaEn([r, NombreReja], [X2,Y2]),
    tieneLlave(Objetos, [l, NombreLlave]),
    abreReja([l, NombreLlave], [r, NombreReja]),
    Costo is 2.

% ---------- rotar(+EstadoActual, -EstadoFinal, -Costo) ---------------%

% Accion: rotar desde el norte
rotar([Posicion, n, Objetos, ColocacionCargaPendiente], [Posicion, e, Objetos, ColocacionCargaPendiente], 1).
rotar([Posicion, n, Objetos, ColocacionCargaPendiente], [Posicion, o, Objetos, ColocacionCargaPendiente], 1).
rotar([Posicion, n, Objetos, ColocacionCargaPendiente], [Posicion, s, Objetos, ColocacionCargaPendiente], 2).

% Accion: rotar desde el sur
rotar([Posicion, s, Objetos, ColocacionCargaPendiente], [Posicion, e, Objetos, ColocacionCargaPendiente], 1).
rotar([Posicion, s, Objetos, ColocacionCargaPendiente], [Posicion, o, Objetos, ColocacionCargaPendiente], 1).
rotar([Posicion, s, Objetos, ColocacionCargaPendiente], [Posicion, n, Objetos, ColocacionCargaPendiente], 2).

% Accion: rotar desde el este
rotar([Posicion, e, Objetos, ColocacionCargaPendiente], [Posicion, n, Objetos, ColocacionCargaPendiente], 1).
rotar([Posicion, e, Objetos, ColocacionCargaPendiente], [Posicion, s, Objetos, ColocacionCargaPendiente], 1).
rotar([Posicion, e, Objetos, ColocacionCargaPendiente], [Posicion, o, Objetos, ColocacionCargaPendiente], 2).

% Accion: rotar desde el oeste
rotar([Posicion, o, Objetos, ColocacionCargaPendiente], [Posicion, n, Objetos, ColocacionCargaPendiente], 1).
rotar([Posicion, o, Objetos, ColocacionCargaPendiente], [Posicion, s, Objetos, ColocacionCargaPendiente], 1).
rotar([Posicion, o, Objetos, ColocacionCargaPendiente], [Posicion, e, Objetos, ColocacionCargaPendiente], 2).

% ---------- saltar(+EstadoActual, -EstadoFinal, -Costo) ---------------%

% Accion: saltar hacia el norte cuando el piso es firme
saltar_valla([[X,Y], n, Objetos, ColocacionCargaPendiente], [[X2, Y2], n, Objetos, ColocacionCargaPendiente], Costo):-
    Xauxiliar is X-1,
    estaEn([v, _, Altura], [Xauxiliar, Y]), 
    Altura<4,
    X2 is X-2,
    Y2 is Y,
    not(hayValla([X2, Y2])),
    not(hayPilar([X2, Y2])),
    celda([X2, Y2], firme),
    Costo is 3.

% Accion: saltar hacia el sur cuando el piso es firme
saltar_valla([[X,Y], s, Objetos, ColocacionCargaPendiente], [[X2, Y2], s, Objetos, ColocacionCargaPendiente], Costo):-
    Xauxiliar is X+1,
    estaEn([v, _, Altura], [Xauxiliar, Y]), 
    Altura<4,
    X2 is X+2,
    Y2 is Y,
    not(hayValla([X2, Y2])),
    not(hayPilar([X2, Y2])),
    celda([X2, Y2], firme),
    Costo is 3.


% Accion: saltar hacia el este cuando el piso es firme
saltar_valla([[X,Y], e, Objetos, ColocacionCargaPendiente], [[X2, Y2], e, Objetos, ColocacionCargaPendiente], Costo):-
    Yauxiliar is Y+1,
    estaEn([v, _, Altura], [X, Yauxiliar]),
    Altura<4,
    Y2 is Y+2,
    X2 is X,
    not(hayValla([X2, Y2])),
    not(hayPilar([X2, Y2])),
    celda([X2, Y2], firme),
    Costo is 3.


% Accion: saltar hacia el Oeste cuando el piso es firme
saltar_valla([[X,Y], o, Objetos, ColocacionCargaPendiente], [[X2, Y2], o, Objetos, ColocacionCargaPendiente], Costo):-
    Yauxiliar is Y-1,
    estaEn([v, _, Altura], [X, Yauxiliar]), 
    Altura<4,
    Y2 is Y-2,
    X2 is X,
    not(hayValla([X2, Y2])),
    not(hayPilar([X2, Y2])),
    celda([X2, Y2], firme),
    Costo is 3.


% Accion: saltar hacia el norte cuando el piso es resbaladizo
saltar_valla([[X,Y], n, Objetos, ColocacionCargaPendiente], [[X2, Y2], n, Objetos, ColocacionCargaPendiente], Costo):-
    Xauxiliar is X-1,
    estaEn([v, _, Altura], [Xauxiliar, Y]), 
    Altura<4,
    X2 is X-2,
    Y2 is Y,
    not(hayValla([X2, Y2])),
    not(hayPilar([X2, Y2])),
    celda([X2, Y2], resbaladizo),
    Costo is 4.

% Accion: saltar hacia el sur cuando el piso es resbaladizo
saltar_valla([[X,Y], s, Objetos, ColocacionCargaPendiente], [[X2, Y2], s, Objetos, ColocacionCargaPendiente], Costo):-
    Xauxiliar is X+1,
    estaEn([v, _, Altura], [Xauxiliar, Y]),
    Altura<4,
    X2 is X+2,
    Y2 is Y,
    not(hayValla([X2, Y2])),
    not(hayPilar([X2, Y2])),
    celda([X2, Y2], resbaladizo),
    Costo is 4.


% Accion: saltar hacia el este cuando el piso es resbaladizo
saltar_valla([[X,Y], e, Objetos, ColocacionCargaPendiente], [[X2, Y2], e, Objetos, ColocacionCargaPendiente], Costo):-
    Yauxiliar is Y+1,
    estaEn([v, _, Altura], [X, Yauxiliar]), 
    Altura<4,
    Y2 is Y+2,
    X2 is X,
    not(hayValla([X2, Y2])),
    not(hayPilar([X2, Y2])),
    celda([X2, Y2], resbaladizo),
    Costo is 4.


% Accion: Saltar hacia el Oeste cuando el piso es resbaladizo
saltar_valla([[X,Y], o, Objetos, ColocacionCargaPendiente], [[X2, Y2], o, Objetos, ColocacionCargaPendiente], Costo):-
    Yauxiliar is Y-1,
    estaEn([v, _, Altura], [X, Yauxiliar]), 
    Altura<4,
    Y2 is Y-2,
    X2 is X,
    not(hayValla([X2, Y2])),
    not(hayPilar([X2, Y2])),
    celda([X2, Y2], resbaladizo),
    Costo is 4.


% ---------- juntar_llave(+EstadoActual, -EstadoFinal, -Costo) ---------------%

% Accion: Juntar llave 
juntar_llave([[X, Y], Posicion, Objetos, ColocacionCargaPendiente], [[X, Y], Posicion, ObjetosConLlave, ColocacionCargaPendiente], Costo):-
    estaEn([l, NombreLlave], [X, Y]),
    not(member([l, NombreLlave], Objetos)),
    append(Objetos, [[l, NombreLlave]], ObjetosConLlave),
    Costo is 1.    


% ---------- juntar_carga(+EstadoActual, -EstadoFinal, -Costo) ---------------%

% Accion: Juntar carga
juntar_carga([[X, Y], Posicion, Objetos, _], [[X, Y], Posicion, ObjetosConCarga, si], Costo):-
    estaEn([c, NombreCarga], [X, Y]),
    not(member([c, NombreCarga], Objetos)),
    append(Objetos, [[c, NombreCarga]], ObjetosConCarga),
    Costo is 3.  

% ---------- juntar_detonador(+EstadoActual, -EstadoFinal, -Costo) ---------------%

% Accion: Juntar detonador
juntar_detonador([[X, Y], Posicion, Objetos, ColocacionCargaPendiente], [[X, Y], Posicion, ObjetosConDetonador, ColocacionCargaPendiente], Costo):-
    estaEn([d, NombreDetonador, ColocacionDetonador], [X, Y]),
    not(member([d, NombreDetonador, ColocacionDetonador], Objetos)),
    append(Objetos, [[d, NombreDetonador, ColocacionDetonador]], ObjetosConDetonador),
    Costo is 2.     

% ---------- dejar_carga(+EstadoActual, -EstadoFinal, -Costo) ---------------%

% Accion: dejar carga en sitio correspondiente
dejar_carga([[X,Y], Posicion, Objetos, _], [[X, Y], Posicion, ObjetosSinCarga, no], Costo):-
    member([c, NombreCarga], Objetos),
    ubicacionCarga([X,Y]),
    delete(Objetos, [c, NombreCarga], ObjetosSinCarga),
    Costo is 1.

