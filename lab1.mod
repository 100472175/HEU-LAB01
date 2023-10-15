# Programa copia del excel, pero en Mathprog

set Ambulancias;

/* parameters */
param Tiempo_respuesta {i in JUGUETES};
param Horas_acabado {i in JUGUETES};
param Demanda_juguetes {i in JUGUETES};
param Beneficio_juguetes {i in JUGUETES};


/* decision variables */
var units {i in JUGUETES} >=0; /* number of units of each toy to produce */
 
/* objective function */
maximize Beneficio_total: sum {i in JUGUETES} Beneficio_juguetes[i]*units[i];


/* constraints */
s.t. carpinteria: sum {i in JUGUETES} Horas_carpinteria[i]*units[i] <= 80;
s.t. acabado: sum {i in JUGUETES} Horas_acabado[i]*units[i] <= 100;
s.t. demanda {i in JUGUETES}: units[i] <= Demanda_juguetes[i];

end;
