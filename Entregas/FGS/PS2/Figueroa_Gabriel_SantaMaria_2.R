# TAREA 2
# Integrantes:
# Polo FIgueroa
# David Gabriel
# Pablo Santa Maria


graphics.off()
rm(list=ls())

library(nleqslv)


#PROBLEMA 1 --------------------------------------------------------------------

# Creamos nuestra expresion inicial
sym <- expression((C^(1/e)+a*(1-L)^(k/e))^e)
sym

# esta funcion recibe una expresion y reemplaza un término en ella por otro
repl <- function(expr,a,b){
    A = deparse(expr[[1]])
    B = sub(a,b,A)
    C = parse(text=B)
    return(C)
}

# reemplazamos L por C/w
sym <- repl(sym,'L','C/w')
sym

# hallamos la derivada de la funcion
# La condicion de primer orden es cuando igualamos esta derivada a cero
sym2 <- D(sym,'C')
sym2

# esta funcion devualeve la expresion evaluada

f1 <- function(C,a=2,e=3,k=0.8,w=1){
    return((C^(1/e)+a*(1-C/w)^(k/e))^e)
}

f2 <- function(C,a,e,k,w){return(eval(sym2))}


# se encuentra el punto en donde la derivada es igual a cero con las restricciones
# a=2, e=3, k=0.8, w=1
nleqslv(0.25,f2,a=2,e=3,k=0.8,w=1)$x 

# a continuacion, optimizamos, pero sin derivar. 

optimize(f1,c(0,1), maximum = TRUE)$maximum


#PROBLEMA 2 --------------------------------------------------------------------
N_partidos = 5000
victorias_f = 0


for (j in 1:N_partidos){
    gol_f=0
    gol_m=0
    for (i in 1:90){
        #probabilidad que vayan a la ofensiva
        OM = runif(1)>0.95
        OF = runif(1)>0.5
        
        # si ambos equipos van a la ofensiva
        if (OM & OF){ 
            gol_f = gol_f + as.numeric(runif(1)<0.05)
            gol_m = gol_m + as.numeric(runif(1)<0.05)
        }
        
        # si frank es defensivo y mou ofensivo
        if (!OF & OM){
            gol_f = gol_f + as.numeric(runif(1)<0.01)
            gol_m = gol_m + as.numeric(runif(1)<0.03)
        }
        
        # si frank es ofensivo y mou defensivo
        if (OF & !OM){
            gol_f = gol_f + as.numeric(runif(1)<0.03)
            gol_m = gol_m + as.numeric(runif(1)<0.01)
        }
    } 
    # se agrega una victoria si frank tiene mas goles
    if (gol_f>gol_m){victorias_f = victorias_f +1}
}

# se calcula la probabilidad de ganar como victorias/partidos totales
P_v = victorias_f/N_partidos
P_v



# se repite el procedimiento de arriba, pero con la variable libre x ,
# la cual corresponde a la probabilidad de ir ofensivos
P = function(x){

N_partidos = 5000
victorias_f = 0

for (j in 1:N_partidos){
    gol_f=0
    gol_m=0
    for (i in 1:90){
        OM = runif(1)>0.95
        OF = runif(1)>1-x
        
        if (OM & OF){
            gol_f = gol_f + as.numeric(runif(1)<0.05)
            gol_m = gol_m + as.numeric(runif(1)<0.05)
        }
        
        if (!OF & OM){
            gol_f = gol_f + as.numeric(runif(1)<0.01)
            gol_m = gol_m + as.numeric(runif(1)<0.03)
        }
        
        if (OF & !OM){
            gol_f = gol_f + as.numeric(runif(1)<0.03)
            gol_m = gol_m + as.numeric(runif(1)<0.01)
        }
    } 
    if (gol_f>gol_m){victorias_f = victorias_f +1}
}

P_v = victorias_f/N_partidos
return(P_v)
}

# se optimiza la funcion, con resticcion 0<x<1
optimize(P,c(0,1),maximum = TRUE)$maximum