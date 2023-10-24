#
# Práctica 1: Programación Lineal - Heurística y Optimización
#
# Parte 2
#
# Eduardo Alarcón & Enrique Alcocer


# Declaración de conjuntos
set DISTRICTS;  # Conjunto de distritos
set PARKINGS;   # Conjunto de parkings
set POSIBLES_PARKINGS;   # Conjunto de parkings posibles

# Parámetros
param tiempo_respuesta{PARKINGS, DISTRICTS};    # Tiempo de respuesta por ambulancia
param max_llamadas_parking;                     # Máximo número de llamadas por parking
param max_tiempo_respuesta;                     # Máximo tiempo de respuesta
param min_tiempo_respuesta;
param max_reparticiones;                        # Máximo número de llamadas por parking para distribuir
param llamadas_por_distrito{d in DISTRICTS};    # Máximo número de llamadas por distrito (en total)
param M;
param posibles_tiempo_respuesta{POSIBLES_PARKINGS, DISTRICTS};


# Variables de decisión
var ambulancias{p in PARKINGS, d in DISTRICTS} integer >= 0;   # Número de ambulancias que envía cada parking a cada distrito
var ambulancias_binario{p in PARKINGS, d in DISTRICTS} binary;   # Número de ambulancias que envía cada parking a cada distrito
var parkings_posibles{p in PARKINGS} binary;

# Función objetivo
minimize total_tiempo_respuesta: sum {p in PARKINGS, d in DISTRICTS} tiempo_respuesta[p, d] * ambulancias[p, d] * 2 +
  sum{p in POSIBLES_PARKINGS} parkings_posibles[p] * 50000;


# Restricciones
# La suma de las llamadas de cada distrito ha de ser menor al total de llamadas de ese distrito
s.t. total_llamadas_en_distrito{d in DISTRICTS}: sum {p in PARKINGS} ambulancias[p,d] = llamadas_por_distrito[d];

# No puede haber más de 10_000*0.75 llamadas en cada parking
s.t. max_llamadas{p in PARKINGS,d in DISTRICTS}: ambulancias[p, d] <= max_reparticiones - 1;

# No puede haber más de 10_000 llamadas en cada parking
s.t. max_llamadas_10k{p in PARKINGS}: sum {d in DISTRICTS} ambulancias[p, d] <= max_llamadas_parking;

# Poner la matriz de variables binarias a 0 o 1
s.t. binario_0 {p in PARKINGS, d in DISTRICTS}: ambulancias[p,d] >= ambulancias_binario[p,d];
s.t. binario_1 {p in PARKINGS, d in DISTRICTS}: M * ambulancias_binario[p,d] >= ambulancias[p,d];


# Restricción de variables binarias para que se cumpla que si se envían ambulancias a un distrito, se envían al menos 10% de las llamadas
s.t. se_usa {p in PARKINGS, d in DISTRICTS}: ambulancias[p,d] + M*(1-ambulancias_binario[p,d]) >= 0.1*llamadas_por_distrito[d];


# El tiempo máximo que puede tardar una ambulancia en llegar a un distrito es de 35 minutos.
s.t. max_tiempo{d in DISTRICTS, p in PARKINGS}: tiempo_respuesta[p, d] * ambulancias[p, d] <= max_tiempo_respuesta * ambulancias[p, d];

# El número de ambulancias que se envían a un distrito no ha de ser un 50% más que el que se hace desde otro parking.
s.t. balance_esfuerzo{p1 in PARKINGS, p2 in PARKINGS: p1 <> p2}: sum {d in DISTRICTS} ambulancias[p1, d] + M*(parkings_posibles[p1] - 1) <= 1.5 * sum {d in DISTRICTS} ambulancias[p2, d] + M*(1-parkings_posibles[p2]);

# Setea Parkings Posibles
s.t. uso_parking{p in PARKINGS}: sum{d in DISTRICTS} ambulancias_binario[p, d] >= parkings_posibles[p];
s.t. uso_parking_min{p in PARKINGS}: M * parkings_posibles[p] >= sum{d in DISTRICTS} ambulancias_binario[p, d];


solve;
end;
