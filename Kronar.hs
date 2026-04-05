module Kronar where

-- Representa el tablero como lista de enteros
type Tablero = [Int]

-- Obtiene el valor de una casilla (base 1)
valorEn :: Tablero -> Int -> Int
valorEn tablero i = tablero !! (i - 1)

-- Regla del Vacío: si la última casilla vale 0, el final es n-1
ajustarFinal :: Tablero -> Int
ajustarFinal [] = 0
ajustarFinal tablero
    | last tablero == 0 = length tablero - 1
    | otherwise         = length tablero

-- Genera todos los caminos posibles desde posActual hasta el final
-- Usa recursión: desde cada posición intenta avanzar 1, 2 o 3
caminos :: Tablero -> Int -> [[Int]]
caminos t posActual
    | posActual > final = []
    | posActual == final = [[posActual]]
    | otherwise = map (posActual :) (juntarCaminos pasosSiguientes)
  where
    final :: Int
    final = ajustarFinal t

    pasosSiguientes :: [Int]
    pasosSiguientes = [posActual + s | s <- [1, 2, 3], posActual + s <= final]

    juntarCaminos :: [Int] -> [[Int]]
    juntarCaminos []     = []
    juntarCaminos (x:xs) = caminos t x ++ juntarCaminos xs

-- Suma los valores de las casillas visitadas en un camino
puntajeBruto :: Tablero -> [Int] -> Int
puntajeBruto tablero camino = sumar [valorEn tablero i | i <- camino]
  where
    sumar []     = 0
    sumar (x:xs) = x + sumar xs

-- Regla del Zafiro: -5 por cada par de casillas consecutivas ambas negativas
penalizacionZafiro :: Tablero -> [Int] -> Int
penalizacionZafiro _ []        = 0
penalizacionZafiro _ [_]       = 0
penalizacionZafiro tablero (i:j:resto)
    | valorEn tablero i < 0 && valorEn tablero j < 0 =
        5 + penalizacionZafiro tablero (j:resto)
    | otherwise =
        penalizacionZafiro tablero (j:resto)

-- Regla del Éter: +10 si llegó exactamente a casilla n con total par
-- llegoExacto: 1 si llegó, 0 si no
bonoEter :: Int -> Int -> Int
bonoEter total llegoExacto
    | llegoExacto == 1 && even total = 10
    | otherwise                      = 0

-- Calcula el puntaje total de un camino aplicando las tres reglas
puntajeTotal :: Tablero -> [Int] -> Int
puntajeTotal tablero camino =
    let bruto    = puntajeBruto tablero camino
        penal    = penalizacionZafiro tablero camino
        subtotal = bruto - penal
        llego    = if last camino == length tablero then 1 else 0
        bono     = bonoEter subtotal llego
    in subtotal + bono

-- Implementación propia de máximo (no usa maximum)
maximo :: [Int] -> Int
maximo []     = error "maximo: lista vacia"
maximo [x]    = x
maximo (x:xs)
    | x > resto = x
    | otherwise  = resto
  where
    resto = maximo xs

-- Función principal: retorna el mejor puntaje posible
kronar :: Tablero -> Int
kronar tablero
    | length tablero < 2  = 0
    | length tablero > 15 = 0
    | otherwise = maximo [puntajeTotal tablero c | c <- caminos tablero 1]

-- Devuelve el camino óptimo (base 1)
caminoOptimo :: Tablero -> [Int]
caminoOptimo tablero
    | length tablero < 2  = []
    | length tablero > 15 = []
    | null todos          = []
    | otherwise           = elegirMejor todos
  where
    todos :: [[Int]]
    todos = caminos tablero 1

    elegirMejor :: [[Int]] -> [Int]
    elegirMejor [c]        = c
    elegirMejor (c1:c2:cs)
        | puntajeTotal tablero c1 >= puntajeTotal tablero c2 = elegirMejor (c1:cs)
        | otherwise                                           = elegirMejor (c2:cs)
    elegirMejor [] = []

-- Convierte índices de base 1 a base 0
convertirBase0 :: [Int] -> [Int]
convertirBase0 []     = []
convertirBase0 (x:xs) = (x - 1) : convertirBase0 xs

-- Convierte una lista de enteros a string JSON  [1,2,3]
listaAJson :: [Int] -> String
listaAJson [] = "[]"
listaAJson xs = "[" ++ unirComas (map show xs) ++ "]"
  where
    unirComas []     = ""
    unirComas [s]    = s
    unirComas (s:ss) = s ++ "," ++ unirComas ss

boolAJson :: Bool -> String
boolAJson True  = "true"
boolAJson False = "false"

-- Exporta el resultado del tablero a un archivo JSON
exportarResultado :: Tablero -> FilePath -> IO ()
exportarResultado tablero ruta
    | length tablero < 2  = writeFile ruta vacio
    | length tablero > 15 = writeFile ruta vacio
    | otherwise = do
        let camino      = caminoOptimo tablero
        let caminoB0    = convertirBase0 camino
        let bruto       = puntajeBruto tablero camino
        let penal       = penalizacionZafiro tablero camino
        let subtotal    = bruto - penal
        let llego       = if last camino == length tablero then 1 else 0
        let bono        = bonoEter subtotal llego
        let puntajeFin  = subtotal + bono
        let reglaVacio  = last tablero == 0

        let json =
              "{\n" ++
              "  \"tablero\": "              ++ listaAJson tablero  ++ ",\n" ++
              "  \"camino_optimo\": "        ++ listaAJson caminoB0 ++ ",\n" ++
              "  \"puntaje_final\": "        ++ show puntajeFin     ++ ",\n" ++
              "  \"bono_eter\": "            ++ show bono           ++ ",\n" ++
              "  \"penalizacion_zafiro\": "  ++ show penal          ++ ",\n" ++
              "  \"regla_vacio_aplicada\": " ++ boolAJson reglaVacio ++ "\n" ++
              "}"

        writeFile ruta json
  where
    vacio = "{\n  \"tablero\": [],\n  \"camino_optimo\": [],\n  \"puntaje_final\": 0,\n  \"bono_eter\": 0,\n  \"penalizacion_zafiro\": 0,\n  \"regla_vacio_aplicada\": false\n}"
