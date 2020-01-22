# Lista de ejercicios 2
#
# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala

# Integrantes: 
# Elmer Humberto Lémus Flores
# Erwin Roberto Navas Solis

################################################################################
#               Solución numérica de ecuaciones no-lineales                    #
################################################################################

# Frank Lampard tiene que decidir cuanto trabajar (L) y cuanto consumir (C). 
# Frank es un genio dentro y fuera de la cancha por lo que toma esta decisión
# resolviendo el siguiente problema

# Incognitas
#   trabajo (L)
#   Consumo (C)

# Donde w > 0 es su salario
# eps > 1
# 0 < k <= 1. 

# Escriba un programa de R que resuelva el problema de Super Frank dados unos 
# valores para los parámetros. 

graphics.off(); rm(list=ls());

# Específicamente

# Reemplace la restricción presupuestal de Frank en su función objetivo para
# reducir la dimensión del problema.

# Utilizamos C = wL como L = C/w y rempleazamos:

funMod = ((c)^(1/e)+a*(1-c/w)^(k/e))^e # Solo como ejemplo

# Escriba un programa de R que encuentre, de forma simbólica, la condición de 
# primer orden que caracteriza la solución del problema.

s_fun <- expression(((c)^(1/e)+a*(1-c/w)^(k/e))^e) 
s_fun[[1]]

# Las variables derivables son:
all.vars(s_fun)

# Derivamos en "C"
d_s_fun <- D(s_fun,'c')
d_s_fun

# Encuentre de forma numérica el nivel de consumo que resuelve la
# anterior ecuación

library(nleqslv)
fun_de <- function(c,a,e,k,w){return(eval(D(s_fun,'c')))}
resultados <- nleqslv(0.25,fun_de,a=2,e=3,k=0.8,w=1)
opt <- resultados$x
opt

################################################################################
#                           Optimización numérica                              #
################################################################################

# Escriba un programa de R que resuelva el problema de Super Frank dados unos
# valores para los parámetros. Esta vez, no solucione la condición de primer
# orden del problema de Frank. En su lugar, resuelva directamente y de forma
# numérica el problema de maximización de Lampard como un problema de
# optimización numérica.

# Creamos la función
fun <- function(c,a,e,k,w){
    a <- 2
    e <- 3
    k <- 0.8
    w <- 1
    return (((c)^(1/e)+a*(1-c/w)^(k/e))^e)
}

# Optimizamos directamente
optimize(fun, c(0,1), maximum = TRUE)

###############################################################################
#                           Simulación Montecarlo                             #
###############################################################################

# Frank a regresado. Esta vez, como entrenador para dirigir a su antiguo equipo
# y enfrentar al malvado Mourinho. Para Frank, el futbol es sencillo:

# El sabe que cada uno de los dos equipos solo puede estar a la ofensiva (O)
# o a la defensiva (D)

graphics.off(); rm(list=ls());

#Frank conoce además a su mentor Mou. El sabe que la probabilidad de que se 
#encierre y decida jugar a la defensiva en un minuto dado es de 0.95.

prob_1 = rep(NaN, 90)
prob_2 = rep(NaN, 90)

gol_1 = rep(NaN, 90)
gol_2 = rep(NaN, 90)

nIter = rep(NaN, 10000)

for (j in 1:10000){
    equipo_1 = sample(c(0,1), 90, replace=TRUE, prob = c(0.5,0.5))
    equipo_2 = sample(c(0,1), 90, replace=TRUE, prob = c(0.95,0.05))
    for (i in 1:90){
        # Si los dos equipos están a la defensiva, la probabilidad de que haya
        # gol es cero
        if (equipo_1[i] + equipo_2[i] == 0) {
            prob_1[i] = 0
            prob_2[i] = 0
            # Si ambos equipos están a la ofensiva, la probabilidad para cada
            # uno de anotar un gol es de 0:05
        } else if (equipo_1[i] + equipo_2[i] == 2){
            prob_1[i] = 0.05
            prob_2[i] = 0.05
            # Si el equipo de Frank esta a la ofensiva y el de Mou a la 
            # defensiva, la probabilidad de que cada uno anote gol es de 0:03
            # y 0:01, respectivamente.
        } else if (equipo_1[i] == 1 & equipo_2[i] == 0){
            prob_1[i] = 0.03
            prob_2[i] = 0.01
            #Si el equipo de Frank esta a la defensiva y el de Mou a la 
            # ofensiva, la probabilidad de que cada uno anote gol es de 0:01
            # y 0:03, respectivamente.
        } else if (equipo_1[i] == 0 & equipo_2[i] == 1){
            prob_1[i] = 0.01 
            prob_2[i] = 0.03}
    }
    
    #Probabilidad de goles
    for (i in 1:90){
        gol = runif(1,min=0,max=1)
        if (gol<=prob_1[i]){
            gol_1[i] = 1}
        else {gol_1[i] = 0}
        if (gol<=prob_2[i]){
            gol_2[i] = 1}
        else {gol_2[i] = 0}
    
    chelsea = sum(gol_1)
    spurs = sum(gol_2)
    }

# Contar las veces que gana Frank
if (chelsea>spurs){
    nIter[j] = 1}
    else {nIter[j] = 0}}

# 1. Cuál es la probabilidad de que Frank gane el partido?

proba = mean(nIter)
proba

# 2. Cuál es la probabilidad de jugar a la ofensiva que maximiza la 
# probabilidad de que Frank gane el partido?

# Ponemos como función el código utilizado anterior
fun = function(x) {
    
    prob_1 = rep(NaN, 90)
    prob_2 = rep(NaN, 90)
    
    gol_1 = rep(NaN, 90)
    gol_2 = rep(NaN, 90)
    
    nIter = rep(NaN, 10000)
    
    for (j in 1:10000){
        equipo_1 = sample(c(0,1), 90, replace=TRUE, prob = c(1-x,x))
        equipo_2 = sample(c(0,1), 90, replace=TRUE, prob = c(0.95,0.05))
        for (i in 1:90){
            if (equipo_1[i] + equipo_2[i] == 0) {
                prob_1[i] = 0
                prob_2[i] = 0
            } else if (equipo_1[i] + equipo_2[i] == 2){
                prob_1[i] = 0.05
                prob_2[i] = 0.05
            } else if (equipo_1[i] == 1 & equipo_2[i] == 0){
                prob_1[i] = 0.03
                prob_2[i] = 0.01
            } else if (equipo_1[i] == 0 & equipo_2[i] == 1){
                prob_1[i] = 0.01 
                prob_2[i] = 0.03}
        }
        for (i in 1:90){
            gol = runif(1,min=0,max=1)
            if (gol<=prob_1[i]){
                gol_1[i] = 1}
            else {gol_1[i] = 0}
            if (gol<=prob_2[i]){
                gol_2[i] = 1}
            else {gol_2[i] = 0}
            
            chelsea = sum(gol_1)
            spurs = sum(gol_2)
        }
        if (chelsea>spurs){
            nIter[j] = 1}
        else {nIter[j] = 0}}
    proba = mean(nIter)
    proba}

# Optimizamos
optimize(fun,c(0,1), maximum = TRUE)
