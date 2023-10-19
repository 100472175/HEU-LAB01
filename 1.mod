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
param max_reparticiones;                        # Máximo número de llamadas por parking para distribuir
param llamadas_por_distrito{d in DISTRICTS};    # Máximo número de llamadas por distrito (en total)
param M;
param posibles_tiempo_respuesta{POSIBLES_PARKINGS, DISTRICTS};

# Variables de decisión
var ambulancias{p in PARKINGS, d in DISTRICTS} integer >= 0;   # Número de ambulancias que envía cada parking a cada distrito
var ambulancias_binario{p in PARKINGS, d in DISTRICTS} binary;   # Número de ambulancias que envía cada parking a cada distrito
var num_parking_nuevos integer >= 0;   # Número de parkings nuevos que se abren
var parkings_posibles{p in POSIBLES_PARKINGS} binary;

# Función objetivo
minimize total_tiempo_respuesta: sum {p in PARKINGS, d in DISTRICTS} tiempo_respuesta[p, d] * ambulancias[p, d] * 2 +
  sum{p in POSIBLES_PARKINGS} parkings_posibles[p] * 50000;


# Restricciones
# La suma de las llamadas de cada distrito ha de ser menor al total de llamadas de ese distrito
s.t. total_llamadas_en_distrito{d in DISTRICTS}: sum {p in PARKINGS} ambulancias[p,d] == llamadas_por_distrito[d];

# No puede haber más de 10_000 llamadas en cada parking
s.t. max_llamadas{p in PARKINGS}: sum {d in DISTRICTS} ambulancias[p, d] <= max_reparticiones;

s.t. binario_0{d in DISTRICTS, p in PARKINGS}: ambulancias[p,d] - M * ambulancias_binario[p, d] >= -M+llamadas_por_distrito[d] * 0.1;
s.t. binario_1{d in DISTRICTS, p in PARKINGS}: ambulancias[p,d] - M * ambulancias_binario[p, d] <= 0;


# Debe haber más de 10% de llamadas en cada parking
s.t. llamadas_parking{d in DISTRICTS, p in PARKINGS}: ambulancias[p,d]  +  M*(1-ambulancias_binario[p, d]) >= llamadas_por_distrito[d] * 0.1;

# El tiempo máximo que puede tardar una ambulancia en llegar a un distrito es de 35 minutos. Que es lo mismo que multiplicarlo por el número de ambulancias que se envían a ese distrito
s.t. max_tiempo{d in DISTRICTS, p in PARKINGS}:  tiempo_respuesta[p, d] * ambulancias[p, d] <= max_tiempo_respuesta * ambulancias[p, d];

# El número de ambulancias que se envían a un distrito no ha de ser un 50% más que el que se hace desde otro parking.
s.t. balance_esfuerzo{p1 in PARKINGS, p2 in PARKINGS: p1 <> p2}: sum {d in DISTRICTS} ambulancias[p1, d] <= 1.5 * sum {d in DISTRICTS} ambulancias[p2, d];

# Resuelve el model
s.t. uso_parking{p in POSIBLES_PARKINGS}: sum{d in DISTRICTS} ambulancias_binario[p, d] -M*parkings_posibles[p] <= 0;
s.t. uso_parking_min{p in POSIBLES_PARKINGS}: sum{d in DISTRICTS} ambulancias_binario[p, d] - M*parkings_posibles[p] >= -M+1;


solve;

end;
