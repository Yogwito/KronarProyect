import Kronar

-- =============================================
-- Tableros del enunciado
-- =============================================

t1 :: Tablero
t1 = [3, -2, -1, 4, 2]
-- Camino óptimo: 1->3->4->5 (base 1), valores: 3,-1,4,2 = 8 bruto
-- Penalizacion Zafiro: casillas 3 y 4 no son ambas negativas en este camino -> 0
-- Subtotal: 8 - 0 = 8 (par) -> Bono Eter: +10
-- Puntaje final esperado: 18

t2 :: Tablero
t2 = [1, -3, -4, 2, 0]
-- Regla del Vacío: casilla 5 vale 0 -> el final es casilla 4
-- Camino óptimo: 1->4 (salto de 3), valores: 1,2 = 3 bruto
-- Penalizacion Zafiro: no hay consecutivas negativas -> 0
-- Subtotal: 3 (impar) -> sin bono Eter (además no llega a n original)
-- Puntaje final esperado: 3

t3 :: Tablero
t3 = [5, 5, 5, 5, 5, 5]
-- Camino óptimo: 1->2->3->4->5->6 (avanzar 1 cada vez), valores: 5+5+5+5+5+5 = 30 bruto
-- Sin casillas negativas -> Penalizacion Zafiro: 0
-- Subtotal: 30 (par) -> Bono Eter: +10
-- Puntaje final esperado: 40

-- =============================================
-- Tableros propios con justificación
-- =============================================

-- Tablero 4: verifica que la penalización Zafiro se aplica correctamente
-- y que el algoritmo evita el camino penalizado si hay uno mejor
t4 :: Tablero
t4 = [2, -5, 6, -1, 3]
-- Caminos posibles desde 1:
--   1->2->3->4->5: valores 2,-5,6,-1,3 = 5 bruto, pen=0 (no hay dos neg. consecutivas visitadas), subtotal=5 (impar) -> 5
--   1->2->3->5:    valores 2,-5,6,3   = 6 bruto, pen=0, subtotal=6 (par) -> bono +10 = 16
--   1->2->4->5:    valores 2,-5,-1,3  = -1 bruto, pen=5 (-5 y -1 consecutivos en el camino), subtotal=-6 (par) -> bono +10 = 4
--   1->3->4->5:    valores 2,6,-1,3   = 10 bruto, pen=0, subtotal=10 (par) -> bono +10 = 20  <- OPTIMO
--   1->3->5:       valores 2,6,3      = 11 bruto, pen=0, subtotal=11 (impar) -> 11
--   1->4->5:       valores 2,-1,3     = 4 bruto, pen=0, subtotal=4 (par) -> bono +10 = 14
-- Puntaje final esperado: 20  (camino 1->3->4->5)

-- Tablero 5: verifica el bono Éter con un tablero simple de paridad controlada
t5 :: Tablero
t5 = [4, -2, -3, 1, 2]
-- Caminos posibles:
--   1->2->3->4->5: valores 4,-2,-3,1,2 = 2 bruto, pen=5 (-2 y -3 consecutivos), subtotal=-3 (impar) -> -3
--   1->2->3->5:    valores 4,-2,-3,2   = 1 bruto, pen=5, subtotal=-4 (par) -> bono +10 = 6
--   1->2->4->5:    valores 4,-2,1,2    = 5 bruto, pen=0, subtotal=5 (impar) -> 5
--   1->2->5:       valores 4,-2,2      = 4 bruto, pen=0, subtotal=4 (par) -> bono +10 = 14
--   1->3->4->5:    valores 4,-3,1,2    = 4 bruto, pen=0, subtotal=4 (par) -> bono +10 = 14
--   1->3->5:       valores 4,-3,2      = 3 bruto, pen=0, subtotal=3 (impar) -> 3
--   1->4->5:       valores 4,1,2       = 7 bruto, pen=0, subtotal=7 (impar) -> 7
-- Puntaje final esperado: 14  (camino 1->2->5 o 1->3->4->5)

-- =============================================
-- Main
-- =============================================

main :: IO ()
main = do
    putStrLn "=== PRUEBAS KRONAR ==="

    putStrLn "\n--- Tablero t1 [3,-2,-1,4,2] ---"
    putStrLn ("Puntaje maximo:         " ++ show (kronar t1))
    putStrLn ("Camino optimo (base 1): " ++ show (caminoOptimo t1))
    putStrLn ("Camino optimo (base 0): " ++ show (convertirBase0 (caminoOptimo t1)))
    putStrLn "Esperado: 18"

    putStrLn "\n--- Tablero t2 [1,-3,-4,2,0] (Regla del Vacio activa) ---"
    putStrLn ("Puntaje maximo:         " ++ show (kronar t2))
    putStrLn ("Camino optimo (base 1): " ++ show (caminoOptimo t2))
    putStrLn ("Camino optimo (base 0): " ++ show (convertirBase0 (caminoOptimo t2)))
    putStrLn "Esperado: 3"

    putStrLn "\n--- Tablero t3 [5,5,5,5,5,5] ---"
    putStrLn ("Puntaje maximo:         " ++ show (kronar t3))
    putStrLn ("Camino optimo (base 1): " ++ show (caminoOptimo t3))
    putStrLn ("Camino optimo (base 0): " ++ show (convertirBase0 (caminoOptimo t3)))
    putStrLn "Esperado: 40"

    putStrLn "\n--- Tablero t4 [2,-5,6,-1,3] (prueba propia 1) ---"
    putStrLn ("Puntaje maximo:         " ++ show (kronar t4))
    putStrLn ("Camino optimo (base 1): " ++ show (caminoOptimo t4))
    putStrLn ("Camino optimo (base 0): " ++ show (convertirBase0 (caminoOptimo t4)))
    putStrLn "Esperado: 20  (camino 1->3->4->5, bono Eter incluido)"

    putStrLn "\n--- Tablero t5 [4,-2,-3,1,2] (prueba propia 2) ---"
    putStrLn ("Puntaje maximo:         " ++ show (kronar t5))
    putStrLn ("Camino optimo (base 1): " ++ show (caminoOptimo t5))
    putStrLn ("Camino optimo (base 0): " ++ show (convertirBase0 (caminoOptimo t5)))
    putStrLn "Esperado: 14  (penalizacion Zafiro evitada, bono Eter aplicado)"

    exportarResultado t1 "resultado.json"
    putStrLn "\nArchivo resultado.json generado con t1."
