# Búsqueda de Planes en una Mina

El objetivo general del proyecto consiste en el desarrollo de un algoritmo de búsqueda en Prolog que implemente la estrategia del método A*. El mismo sera utilizado por un agente minero que buscará planes con el objetivo de
encontrar la carga explosiva que se halla escondida en la mina para posteriormente ubicarla en el lugar correspondiente, recolectar el detonador y activarlo una vez situado en una posición designada para la
detonación. En particular, los planes hallados por el agente minero deberan ser tales que su ejecución incurra en el menor costo posible.

## Descripción

Como se mencionó anteriormente, el objetivo del minero es la búsqueda de planes mientras se encuentra en la mina. En particular, la meta del minero es efectuar la detonación una vez situado en uno de los lugares designados para tal fin (para lo cual debe poseer el detonador), habiendo colocado la carga explosiva en su ubicación correspondiente (es decir, la tarea de colocar la carga ya no se encuentra pendiente). A tal efecto, el minero podría planificar su búsqueda en diversas situaciones, partiendo de diferentes puntos de la mina. En cada caso, el plan hallado para que el minero alcance su objetivo deberá ser optimal, en el sentido de que el costo asociado a la ejecución de la correspondiente secuencia de acciones deberá ser mínima. Con el objetivo de obtener tales planes, deberá implementarse el método de búsqueda A_. Concretamente, deberá implementarse el predicado:
buscar plan(+EInicial, -Plan, -Destino, -Costo)
que dado un estado inicial (EInicial), y teniendo en cuenta la configuración de la mina, halle una secuencia de acciones (Plan) que le permitan recoger el detonador y la carga explosiva, ubicar la carga en su lugar designado y, finalmente, efectuar la detonación desde una de las posiciones habilitadas para tal fin (siendo dicha posición identificada como Destino). Asimismo, deberá retornarse el Costo asociado a la ejecución del Plan hallado. Este predicado permitirá al minero hallar un plan optimal (el de menor costo posible) para alcanzar su objetivo.


### Representación de una mina en Prolog

La mina se encuentra representada por una colección de hechos Prolog con la siguiente forma:
* celda(Pos, Suelo) indica el tipo de suelo de una posición Pos dentro de la mina.
* estaEn(Obj, Pos) indica que el objeto Obj se encuentra en la posición Pos de la mina.
* ubicacionCarga(Pos) indica que la posición Pos de la mina es el sitio donde debe ubicarse la carga explosiva (donde Pos tiene la estructura antes descripta).
* sitioDetonacion(Pos) indica que la posición Pos de la mina es uno de los sitios habilitados para activar el detonador y así detonar la carga explosiva (donde Pos tiene la estructura antes
descripta).
* abreReja(Llave, Reja) indica que la llave Llave permite atravesar la reja Reja (donde Llave y Reja tienen la estructura antes descripta).

### Ejemplo de representacion en Prolog de una mina irregular con 14 filas y 13 columnas.

<p align="center">
<img src="https://i.ibb.co/L03V07Y/Sin-t-tulo.png" alt="drawing" />
</p>

### Ejemplos de funcionamiento

?- buscar_plan([[4,10], o, [], si], Plan, Destino, Costo).
Plan = [rotar(s), caminar, caminar, rotar(o), caminar, caminar, caminar, caminar, rotar(s),
juntar_carga([c,c1]), caminar, caminar, caminar, juntar_llave([l,l1]), caminar,
dejar_carga([c,c1]), rotar(o), caminar, caminar, rotar(n), caminar, caminar, caminar,
caminar, rotar(o), saltar_valla([v,v1,1]), juntar_detonador([d,d1,no]), rotar(n),
caminar, caminar, caminar, caminar, rotar(e), caminar, caminar, detonar([d,d1,no])],
Destino = [2, 4],
Costo = 71.

-----------------------------------------

?- buscar_plan([[6,4], n, [], si], Plan, Destino, Costo).
Plan = [rotar(o), saltar_valla([v,v1,1]), juntar_detonador([d,d1,no]), rotar(e),
saltar_valla([v,v1,1]), rotar(s), caminar, caminar, rotar(e), caminar, caminar,
rotar(n), caminar, caminar, rotar(s), juntar_carga([c,c1]), caminar, caminar, caminar,
caminar, dejar_carga([c,c1]), caminar, rotar(o), caminar, saltar_valla([v,v8,3]),
caminar,rotar(s), caminar, detonar([d,d1,no])],
Destino = [12, 2],
Costo = 62.

## Tecnologías utilizadas

* [Prolog](https://devdocs.io/c/) - General-purpose, procedural computer programming language supporting structured programming,

## Autores

* **Artola Bianca** - [BiancaArtola](https://github.com/BiancaArtola)
