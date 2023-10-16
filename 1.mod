# Declaración de conjuntos
set DISTRICTS;  # Conjunto de distritos
set PARKINGS;   # Conjunto de parkings

# Parámetros
param tiempo_respuesta{PARKINGS, DISTRICTS};    # Tiempo de respuesta por ambulancia
param max_llamadas_parking;                     # Máximo número de llamadas por parking
param max_tiempo_respuesta;                     # Máximo tiempo de respuesta
param llamadas_por_distrito{d in DISTRICTS};    # Máximo número de llamadas por distrito (en total)

# Variables de decisión
var ambulancias{p in PARKINGS, d in DISTRICTS} integer >= 0;   # Número de ambulancias que envía cada parking a cada distrito

# Función objetivo
minimize total_tiempo_respuesta: sum {p in PARKINGS, d in DISTRICTS} tiempo_respuesta[p, d] * ambulancias[p, d];


# Restricciones
# La suma de las llamadas de cada distrito ha de ser menor al total de llamadas de ese distrito
s.t. total_llamadas_en_distrito{d in DISTRICTS}: sum {p in PARKINGS} ambulancias[p,d] == llamadas_por_distrito[d];


# No puede haber más de 10_000 llamadas en cada parking
s.t. max_llamadas{p in PARKINGS}: sum {d in DISTRICTS} ambulancias[p, d] <= 10000;


# El tiempo máximo que puede tardar una ambulancia en llegar a un distrito es de 35 minutos. Que es lo mismo que multiplicarlo por el número de ambulancias que se envían a ese distrito
s.t. max_tiempo{d in DISTRICTS, p in PARKINGS}:  tiempo_respuesta[p, d] * ambulancias[p, d] <= max_tiempo_respuesta * ambulancias[p, d];

# El número de ambulancias que se envían a un distrito no ha de ser un 50% más que el que se hace desde otro parking.
s.t. balance_esfuerzo{p1 in PARKINGS, p2 in PARKINGS: p1 <> p2}: sum {d in DISTRICTS} ambulancias[p1, d] <= 1.5 * sum {d in DISTRICTS} ambulancias[p2, d];

# Resuelve el modelo
solve;

end;