% ------------- METODOS AUXILIARES UTILIZADOS POR OTROS MODULOS  ------------- %

%  --------------------------  hayPilar(+Posicion) --------------------------- %
% Indica si hay un pilar en la posicion enviada por parametro.
hayPilar([X, Y]):-
    estaEn([p, _, _], [X,Y]).

% --------------------------- hayValla(+Posicion) ---------------------------- %
% Indica si hay una valla en la posicion enviada por parametro.
hayValla([X,Y]):-
    estaEn([v, _, _], [X,Y]).

% ---------------------------- hayReja(+Posicion) ---------------------------- %
% Indica si hay una reja en la posicion enviada por parametro.
hayReja([X, Y]):-
    estaEn([r, _], [X,Y]).

% ----------------------- tieneLlave(+Objetos, +Llave) ------------------------%
% Indica si la lista Objetos contiene la llave enviada como parametro.
tieneLlave(Objetos, Llave):-
    member(Llave, Objetos).

% ------------------------------ esMeta(+Estado)------------------------------ %
% Indica si el estado enviado como parametro es meta.
esMeta([[X, Y], _, ListaPosesiones, no]):-
    sitioDetonacion([X, Y]),
    member([d, _, si], ListaPosesiones).

% ----------------------- retornarSitiosDetonacion(-Lista) ------------------- %
% Crea una lista con todos los sitios de detonacion.
retornarSitioDetonacion(Lista):-
    findall([X, Y], sitioDetonacion([X, Y]), Lista).    