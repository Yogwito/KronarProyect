# El Juego de los Kronares

Proyecto Integrador — Haskell + Racket

## Requisitos

- [GHC](https://www.haskell.org/ghc/) (compilador de Haskell)
- [Racket](https://racket-lang.org/) (intérprete)

### Verificar instalación

```bash
ghc --version
racket --version
```

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `Kronar.hs` | Implementación completa en Haskell |
| `Pruebas.hs` | Pruebas con tableros justificados |
| `integracion.rkt` | Programa de integración en Racket |
| `resultado.json` | Generado por Haskell con t1 |
| `README.md` | Este archivo |

## Ejecución (en orden)

### Paso 1 — Compilar y ejecutar Haskell

Esto compila ambos archivos y genera `resultado.json` con el tablero t1.

```bash
ghc -o pruebas Pruebas.hs Kronar.hs
./pruebas
```

Verás las pruebas en consola y se creará el archivo `resultado.json` en el mismo directorio.

### Paso 2 — Ejecutar integración en Racket

El programa lee `resultado.json` y genera el reporte. Debe ejecutarse en el mismo directorio donde está el JSON.

```bash
racket integracion.rkt
```

## Ejemplo de salida esperada

### Haskell (`./pruebas`)

```
=== PRUEBAS KRONAR ===

--- Tablero t1 [3,-2,-1,4,2] ---
Puntaje maximo:         18
Camino optimo (base 1): [1,3,4,5]
Camino optimo (base 0): [0,2,3,4]
Esperado: 18
...
Archivo resultado.json generado con t1.
```

### Racket (`racket integracion.rkt`)

```
╔══════════════════════════════════════╗
║      REPORTE KRONAR - Racket         ║
╚══════════════════════════════════════╝
Tablero:            (3 -2 -1 4 2)
Camino optimo:      (0 2 3 4)
Puntaje final:      18
Bono Eter:          10
Penal. Zafiro:      0
Regla Vacio activa: #f

--- Tablero visual ---
[X] [ ] [X] [X] [X]
3    -2   -1   4    2

--- Estadisticas propias ---
Casillas visitadas: 4
Casillas omitidas:  1
Negativas visitadas: SI — hay casillas negativas en el camino optimo
```

## Notas

- El archivo `resultado.json` **debe existir** antes de ejecutar Racket. Siempre corre Haskell primero.
- Ambos programas deben estar en el **mismo directorio**.
- El programa Racket no depende de los cálculos del JSON para las estadísticas — las recalcula por su cuenta a partir del tablero y el camino.
