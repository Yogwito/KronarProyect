#lang racket

;; ============================================================
;; Integración Kronar - Racket (adaptado al Grupo OCaml)
;; Lee resultado.json generado por Haskell y genera reporte
;; ============================================================

(require json)

;; ------------------------------------------------------------
;; Tipos algebraicos: estado de cada casilla
;; Equivalente a: type estado = Visitada | Omitida
;; ------------------------------------------------------------

(struct Visitada (valor) #:transparent)
(struct Omitida  (valor) #:transparent)

;; ------------------------------------------------------------
;; Determina el estado de cada casilla según el camino óptimo
;; Usa pattern matching con match
;; ------------------------------------------------------------

(define (clasificar-casilla indice valor camino)
  (if (member indice camino)
      (Visitada valor)
      (Omitida  valor)))

(define (clasificar-tablero tablero camino)
  (for/list ([i (in-range (length tablero))]
             [v (in-list tablero)])
    (clasificar-casilla i v camino)))

;; ------------------------------------------------------------
;; Imprime una casilla con su estado usando pattern matching
;; ------------------------------------------------------------

(define (imprimir-estado estado)
  (match estado
    [(Visitada _) (display "[X]")]
    [(Omitida  _) (display "[ ]")]))

(define (imprimir-valor estado)
  (match estado
    [(Visitada v) (display (~a v #:min-width 4))]
    [(Omitida  v) (display (~a v #:min-width 4))]))

;; ------------------------------------------------------------
;; Reconstruye el tablero visual en consola
;; Ejemplo: [X] [ ] [X] [X] [X]
;;            3   -2  -1   4   2
;; ------------------------------------------------------------

(define (mostrar-tablero-visual casillas)
  (displayln "\n--- Tablero visual ---")
  (for ([c casillas])
    (imprimir-estado c)
    (display " "))
  (newline)
  (for ([c casillas])
    (imprimir-valor c)
    (display " "))
  (newline))

;; ------------------------------------------------------------
;; Calcula estadísticas propias (sin confiar en el JSON)
;; ------------------------------------------------------------

(define (contar-visitadas casillas)
  (length (filter Visitada? casillas)))

(define (contar-omitidas casillas)
  (length (filter Omitida? casillas)))

(define (hay-negativas-visitadas? casillas)
  (for/or ([c casillas])
    (match c
      [(Visitada v) (< v 0)]
      [_ #f])))

;; ------------------------------------------------------------
;; Reporte principal en consola
;; ------------------------------------------------------------

(define (mostrar-reporte datos casillas)
  (define tablero   (hash-ref datos 'tablero))
  (define camino    (hash-ref datos 'camino_optimo))
  (define puntaje   (hash-ref datos 'puntaje_final))
  (define bono      (hash-ref datos 'bono_eter))
  (define penaliz   (hash-ref datos 'penalizacion_zafiro))
  (define vacio     (hash-ref datos 'regla_vacio_aplicada))

  (displayln "╔══════════════════════════════════════╗")
  (displayln "║      REPORTE KRONAR - Racket         ║")
  (displayln "╚══════════════════════════════════════╝")

  (display "Tablero:            ") (displayln tablero)
  (display "Camino optimo:      ") (displayln camino)
  (display "Puntaje final:      ") (displayln puntaje)
  (display "Bono Eter:          ") (displayln bono)
  (display "Penal. Zafiro:      ") (displayln penaliz)
  (display "Regla Vacio activa: ") (displayln vacio)

  (mostrar-tablero-visual casillas)

  (displayln "\n--- Estadisticas propias ---")
  (display "Casillas visitadas: ") (displayln (contar-visitadas casillas))
  (display "Casillas omitidas:  ") (displayln (contar-omitidas casillas))
  (display "Negativas visitadas: ")
  (if (hay-negativas-visitadas? casillas)
      (displayln "SI — hay casillas negativas en el camino optimo")
      (displayln "NO — ninguna casilla negativa fue visitada")))

;; ------------------------------------------------------------
;; Main: leer JSON y ejecutar todo
;; ------------------------------------------------------------

(define (main)
  (define ruta "resultado.json")

  (unless (file-exists? ruta)
    (displayln (string-append "Error: no se encontro el archivo " ruta))
    (exit 1))

  (define datos
    (with-input-from-file ruta
      (lambda () (read-json))))

  (define tablero (hash-ref datos 'tablero))
  (define camino  (hash-ref datos 'camino_optimo))

  (define casillas (clasificar-tablero tablero camino))

  (mostrar-reporte datos casillas))

(main)
