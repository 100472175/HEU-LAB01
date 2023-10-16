#
# Práctica 1: Heurística y Optimización
#
# Optimal solution to minimize cost
#
# Parte 1
#
# glpsol -m model.mod -d data.dat -o output.txt
# ambulancia_model.mod

set PARKINGS;
set DISTRITOS;

param tiempo{PARKINGS, DISTRITOS};

param demanda{DISTRITOS};

param max_llamadas_parking;

var x{PARKINGS, DISTRITOS} binary;

minimize tiempo_total: sum{i in PARKINGS, j in DISTRITOS} tiempo[i, j] * x[i, j];

subject to capacidad_por_parking{i in PARKINGS}:
   sum{j in DISTRITOS} x[i, j] <= 1;

subject to demanda_por_distrito{j in DISTRITOS}:
   sum{i in PARKINGS} x[i, j] == demanda[j];

solve;

end;
