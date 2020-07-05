% ---------------------------- HEURISTICAS --------------------------- %
% --------------- calcular_heuristica(+Estado, -Heuristica) ---------- %

% Caso 1: El minero no tiene la carga ni el detonador y aun no dejo la carga
calcular_heuristica(Estado, Heuristica):-
    Estado = [_, _, ListaPosesiones, si],
    not(member([c, _], ListaPosesiones)),
    not(member([d, _, _], ListaPosesiones)),
    heuristica_inicial(Estado, Heuristica).

% Caso 2: El minero tiene la carga pero no tiene el detonador.
calcular_heuristica(Estado, Heuristica):-
    Estado = [_, _, ListaPosesiones, si],
    member([c, _], ListaPosesiones),
    not(member([d, _, _], ListaPosesiones)),
    heuristica_con_carga_sin_detonador(Estado, Heuristica).

% Caso 3: El minero tiene la carga y el detonador
calcular_heuristica(Estado, Heuristica):-
    Estado = [_, _, ListaPosesiones, si],
    member([c, _], ListaPosesiones),
    member([d, _, _], ListaPosesiones),
    heuristica_con_carga_detonador(Estado, Heuristica).

% Caso 4: El minero tiene el detonador pero no la carga (aun no fue colocada)
calcular_heuristica(Estado, Heuristica):-
    Estado = [_, _, ListaPosesiones, si],
    not(member([c, _], ListaPosesiones)),
    member([d, _, _], ListaPosesiones),
    heuristica_con_detonador(Estado, Heuristica).

% Caso 5: El minero ya coloco la carga pero no tiene el detonador.
calcular_heuristica(Estado, Heuristica):-
    Estado = [_, _, ListaPosesiones, no],
    not(member([c, _], ListaPosesiones)),
    not(member([d, _, _], ListaPosesiones)),
    heuristica_busqueda_detonador(Estado, EstadoFinal, Heuristica1),    
    heuristica_carga_colocada_con_detonador(EstadoFinal, Heuristica2),
    Heuristica is Heuristica1 + Heuristica2.

% Caso 6: El minero tiene el detonador y la carga ya fue colocada
calcular_heuristica(Estado, Heuristica):-
    Estado = [_, _, ListaPosesiones, no],
    not(member([c, _], ListaPosesiones)),
    member([d, _, _], ListaPosesiones),
    heuristica_carga_colocada_con_detonador(Estado, Heuristica).

% Calculo de la heuristica hacia el estado meta.
% Parte del estado en el que la carga esta colocada y el minero tiene el detonador.
heuristica_carga_colocada_con_detonador([[X, Y], _, _, _], Heuristica):-
    retornarSitioDetonacion(Lista),
    member([Xmeta, Ymeta], Lista),
    Distancia is abs(Xmeta-X)+abs(Ymeta-Y),
    not((member([Xmeta2, Ymeta2], Lista),
        Distancia2 is abs(Xmeta2-X)+abs(Ymeta2-Y),
        Distancia2 < Distancia)),
    Heuristica=Distancia, 
    !.

% Calculo de la heuristica desde la posicion [X,Y] hacia el detonador.
% Parte del estado en el minero no tiene el detonador
heuristica_busqueda_detonador([[X, Y], _, _, _], EstadoFinal, Heuristica):-
    estaEn([d, _, _], [Xdetonador, Ydetonador]),
    DistanciaDetonador is abs(Xdetonador-X)+abs(Ydetonador-Y),
    Heuristica = DistanciaDetonador,
    EstadoFinal = [[Xdetonador, Ydetonador], _,_,_].

% Calculo de la heuristica desde la posicion [X,Y] hacia la carga y el sitio de carga.
% Parte de un estado en el que el minero tiene el detonador pero no tiene la carga, que aun no fue colocada.
heuristica_con_detonador(Estado, Heuristica):-
    Estado = [[X, Y], _, _, _],
    heuristica_buscar_carga([X,Y], DistanciaCarga, [Xcarga, Ycarga]),
    heuristica_ir_sitio_carga([Xcarga, Ycarga], DistanciaSitioCarga, [XsitioCarga, YsitioCarga]),
    HeuristicaCarga is DistanciaCarga + DistanciaSitioCarga,
    heuristica_carga_colocada_con_detonador([[XsitioCarga, YsitioCarga], _, _, _], HeuristicaSitioDetonacion),
    Heuristica is HeuristicaCarga + HeuristicaSitioDetonacion.    

% Calculo de la heuristica desde la posicion enviada [X,Y] hacia la carga
heuristica_buscar_carga([X, Y], Distancia, [Xcarga, Ycarga]):-
    estaEn([c, _], [Xcarga, Ycarga]),
    Distancia is abs(Xcarga-X)+abs(Ycarga-Y).

% Calculo de la heuristica desde la posicion enviada [X,Y] hacia el sitio de carga
heuristica_ir_sitio_carga([X, Y], Distancia, [Xcarga, Ycarga]):-
    ubicacionCarga([Xcarga, Ycarga]),
    Distancia is abs(Xcarga-X)+abs(Ycarga-Y).

% Calculo de la heurista desde la posicion [X,Y] hacia el sitio de carga y hacia la meta
% Parte de un estado donde el minero tiene la carga y el detonador.
heuristica_con_carga_detonador(Estado, Heuristica):-
    Estado = [[X, Y], _, _, _], 
    heuristica_ir_sitio_carga([X, Y], Heuristica1, [XsitioCarga, YsitioCarga]),
    heuristica_carga_colocada_con_detonador([[XsitioCarga, YsitioCarga], _, _, _], Heuristica2),
    Heuristica is Heuristica2 + Heuristica1.

% Calculo dos heuristicas y elijo la de menor valor:
% 1- Busco el detonador, luego coloco la carga y luego voy al sitio de detonacion.
% 2- Dejo la carga, busco el detonador y luego voy al sitio de detonacion.
heuristica_con_carga_sin_detonador(Estado, Heuristica):-
    heuristica_uno(Estado, Heuristica1),
    heuristica_dos(Estado, Heuristica2),
    Heuristica is min(Heuristica1, Heuristica2).

% 1- Busco el detonador, luego coloco la carga y luego voy al sitio de detonacion.
heuristica_uno(Estado, Heuristica):-
    Estado = [[X,Y], _, _,_],
    heuristica_busqueda_detonador([[X, Y], _, _, _], EstadoFinal, HeuristicaDetonador),
    EstadoFinal = [[X2, Y2], _, _, _],
    heuristica_ir_sitio_carga([X2, Y2], HeuristicaSitioCarga, [Xfinal, Yfinal]),
    heuristica_carga_colocada_con_detonador([[Xfinal, Yfinal], _, _, _], HeuristicaSitioDetonacion),
    Heuristica is HeuristicaDetonador + HeuristicaSitioCarga + HeuristicaSitioDetonacion.

% 2- Dejo la carga, busco el detonador y luego voy al sitio de detonacion.
heuristica_dos(Estado, Heuristica):-
    Estado = [[X,Y], _, _,_],
    heuristica_ir_sitio_carga([X, Y], HeuristicaSitioCarga, [Xcarga, Ycarga]),
    heuristica_busqueda_detonador([[Xcarga, Ycarga], _, _, _], [[Xfinal, Yfinal], _, _, _], HeuristicaDetonador),
    heuristica_carga_colocada_con_detonador([[Xfinal, Yfinal], _, _, _], HeuristicaSitioDetonacion),
    Heuristica is HeuristicaDetonador + HeuristicaSitioCarga + HeuristicaSitioDetonacion.

% Calculo las 2 heuristicas y elijo la de menor valor:
% 1 - Agarro el detonador primero, busco la carga, la dejo y voy al sitio de detonacion.
% 2 - Agarro la carga primero.
heuristica_inicial(Estado, Heuristica):-
    heuristica_inicial_detonador(Estado, Heuristica1),
    heuristica_inicial_carga(Estado, Heuristica2),
    Heuristica is min(Heuristica1, Heuristica2).
    
% 1 - Agarro el detonador primero, busco la carga, la dejo y voy al sitio de detonacion.
heuristica_inicial_detonador(Estado, Heuristica):-
    Estado = [[X, Y], _, _, _],
    heuristica_busqueda_detonador([[X, Y], _, _, _], [[Xdetonador, Ydetonador], _, _, _], HeuristicaDetonador),
    heuristica_con_detonador([[Xdetonador, Ydetonador], _, _, _], HeuristicaFinal),
    Heuristica is HeuristicaDetonador + HeuristicaFinal.

% 2 - Agarro la carga primero.
heuristica_inicial_carga(Estado, Heuristica):-
    Estado = [[X, Y], _, _, _],
    heuristica_buscar_carga([X, Y], HeuristicaCarga, [Xcarga, Ycarga]),
    heuristica_con_carga_sin_detonador([[Xcarga, Ycarga], _, _, _], HeuristicaFinal),
    Heuristica is HeuristicaCarga+HeuristicaFinal.

