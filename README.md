# HEU-LAB01
Laboratorio de heurística para resolver el problema de asignación de ambulancias a unos distritos concretos. [Enunciado](practica-1.pdf)

Para ejecutar las diferentes partes, utilizamos glpksol, de glpk.

Para instalarlo, utilizaremos:
### Ubuntu (apt)
```sh
sudo apt install glpk-utils
```

### Mac (brew):
```sh
brew install glpk
```

### Fedora (dnf):
```sh
sudo dnf install glpk-utils
```

## Ejecutando el modelo
Para ejecutar el modelos utilizaremos el comano _glpsol_:
```sh
glpsol -m 1.mod -d 1.dat -o output.txt
```


## Autores:
- Eduardo Alarcón
- Enrique Alcocer