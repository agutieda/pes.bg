# Lista de ejercicios 2

#Programacion II
#Programa de Estudios Superiores
#Banco de Guatemala

#Integrantes:

#Marianna Guzmán
#Joaquín Gordillo Sajbín
#Luis Lemus Mackay

graphics.off(); rm(list=ls());
ls()

#LIBRERÍAS A UTILIZAR
#install.packages("nloptr")
library("nloptr")
#install.packages('nleqslv')
library(nleqslv)
#install.packages('numDeriv')
library(numDeriv)

###############################################################################################
#PROBLEMA 1. SOLUCIÓN NUMÉRICA DE ECUACIONES NO-LINEALES
###############################################################################################

##Matemática simbólica:

###############################################################################################
##INCISO A. En la expresión reemplazamos la restricción presupuestal de Frank
###############################################################################################

sym_max_frank=expression(((salario*L)^(1/epsilon)+alpha*(1-L)^(k/epsilon))^(epsilon))
sym_max_frank #Creamos una la función en mate simbólica
sym_max_frank[1]
sym_max_frank[[1]]

###############################################################################################
##INCISO B. De forma simbólica encontramos la condición de primer orden
###############################################################################################

D_sym_max_frank = D(sym_max_frank,"L")#Esta es la condición de primer orden.
D_sym_max_frank 

###############################################################################################
##INCISO C. De forma numérica el nivel de consumo
###############################################################################################

##Parámetros:
salario=1
epsilon=3
alpha=2
k=0.8
L0=0.25

##La función:
max_frank=function(L) return((((salario*L)^(1/epsilon))+alpha*((1-L)^(k/epsilon)))^(epsilon))
x11();plot(max_frank)

funcion_normal= function(L,salario=1,epsilon=3,alpha=2,k=0.8) {
    return(eval(sym_max_frank))
}

funcion_derivada = function(L,salario,epsilon,alpha,k) {
    return(eval(D_sym_max_frank))
}

solucion_CPO = nleqslv(L0,funcion_derivada,salario=1,epsilon=3,alpha=2,k=0.8)

L_opt=solucion_CPO$x 
C_opt=salario*L_opt
C_opt


#eval(sym_max_frank, envir=list(salario,epsilon,alpha,k,))

###############################################################################################
#PROBLEMA 2. OPTIMIZACIÓN NUMÉRICA
###############################################################################################

##Parámetros:
salario=1
epsilon=3
alpha=2
k=0.8
L0=0.25

##La función:
max_frank=function(L) return((((salario*L)^(1/epsilon))+alpha*((1-L)^(k/epsilon)))^(epsilon))

optimo=optimize(max_frank, interval= c(0,1), maximum=TRUE) #Se optimiza una variable (L)
optimo
l_opt2=optimo$maximum #Obtengo mi L óptimo
c_opt2=l_opt2*salario #A partir de mi L óptimo obtengo mi C óptimo

###############################################################################################
#PROBLEMA 3. SIMULACIÓN MONTECARLO
###############################################################################################

#rm(list=ls()) #Limpio todas mis variables
#graphics.off() #Limpio mis gráficas

##Probabilidades de Meter Gol
p_ambos_def=0 #Si ambos son defensivos
p_ambos_of=0.05 #Si ambos son ofensivos
p_of=0.03 #Prob de ser ofensivo dado que el otro es defensivo
p_def=0.01 #Prob de ser defensivo dado que el otro es ofensivo


##Probabilidades de ser defensivo u ofensivo Mou y Frank
p_Mou_def=0.95 #En un minuto dado, la probabilidad de ser defensivo de Mou
p_Frank_of=0.5 #Cada minuto, la probabilidad de ser ofensivo de Frank
nMinutos=90

nSim=10000 #Número de simulaciones
vec = c(0,1)

#0 = jugar al a defensiva
#1 = jugar a la ofesiva

#Mi vector de probabilidad de Frank que sea defensivo(0) o sea ofensivo(1)
vec_prob_Frank = c(0.5,0.5) 
#Mi vector de probabilidad de Mou que sea defensivo(0) o sea ofensivo(1)
vec_prob_Mou = c(0.95,0.05)

###############################################################################################
#INCISO A. Calcular probabilidad que Frank gane
###############################################################################################

Goles_totales = rep(NaN,nSim) #Creo una lista vacía con el número de simulaciones

for(j in 1:nSim){ #Para cada partido del total de número de simulaciones
    gol_F = rep(NaN,nMinutos) #Creo una lista de goles de Frank 
    gol_M = rep(NaN,nMinutos) #Creo una lista de goles de Mou
    #Elecciones de ser defensivo u ofensivo dependiendo de la probabilidad de cada uno
    eleccion_Mou = sample(vec, size=nMinutos, replace=TRUE, prob=vec_prob_Mou)
    eleccion_Frank = sample(vec, size=nMinutos, replace=TRUE, prob=vec_prob_Frank)
    
    for (i in 1:90){ #Para cada minuto del partido
        aleatorio = runif(1,0,1) #Creo un número aleatorio
        if (eleccion_Frank[i]+eleccion_Mou[i]==2) { #Si ambos son ofensivos
            #Si el número aleatorio cae sobre la probabilidad de meter gol, se le suma un gol
            gol_F[i]=(as.numeric(aleatorio<=p_ambos_of))
            gol_M[i]=(as.numeric(aleatorio<=p_ambos_of))
        }
        
        else if (eleccion_Frank[i]==1 & eleccion_Mou[i]==0) {#Si Frank es ofensivo y Mou defensivo
            #Si el número aleatorio cae sobre la probabilidad de meter gol, se le suma un gol
            gol_F[i]=(as.numeric(aleatorio<=p_of))
            gol_M[i]=(as.numeric(aleatorio<=p_def))
        }
        else if (eleccion_Frank[i]==0 & eleccion_Mou[i]==1) {#Si Frank es defensivo y Mou ofensivo
            #Si el número aleatorio cae sobre la probabilidad de meter gol, se le suma un gol
            gol_F[i]=(as.numeric(aleatorio<= p_def))
            gol_M[i]=(as.numeric(aleatorio<= p_of))
        }
        else if (eleccion_Frank[i]+ eleccion_Mou[i]==0){ #Si ambos son defensivos
            #No hay goles
            gol_F[i]=p_ambos_def
            gol_M[i]=p_ambos_def
        }
        #1er loop
    }
    #2do loop
    
    if(sum(gol_F)>sum(gol_M)){#si la suma de goles de Frank es mayor a la suma de Mou
        Goles_totales[j]= 1 #A la lista de victorias totales se le agrega un 1
    }
    else {
        Goles_totales[j]=0 #Sino se le agrega un cero
    }
}
Probabilidad_Frank_gane=mean(Goles_totales) 
#La probabilidad que Frank gane es la media del total de simulaciones
Probabilidad_Frank_gane

###############################################################################################
#INCISO B. Calcular probabilidad de jugar ofensivo que maximice la probabilidad que Frank gane
###############################################################################################

#Hacemos una función que tenga adentro toda la simulación de Montecarlo

jugar_ofensivo=function(x) {
    
    nSim=10000 #Número de simulaciones
    vec = c(0,1)
    #Mi vector de probabilidad de Frank que sea defensivo(0) o sea ofensivo(1)
    vec_prob_Frank = c(1-x,x) 
    #Mi vector de probabilidad de Mou que sea defensivo(0) o sea ofensivo(1)
    vec_prob_Mou = c(0.95,0.05)
    
    Goles_totales = rep(NaN,nSim) #Creo una lista vacía con el número de simulaciones
    
    for(j in 1:nSim){ #Para cada partido del total de número de simulaciones
        gol_F = rep(NaN,nMinutos) #Creo una lista de goles de Frank 
        gol_M = rep(NaN,nMinutos) #Creo una lista de goles de Mou
        #Elecciones de ser defensivo u ofensivo dependiendo de la probabilidad de cada uno
        eleccion_Mou = sample(vec, size=nMinutos, replace=TRUE, prob=vec_prob_Mou)
        eleccion_Frank = sample(vec, size=nMinutos, replace=TRUE, prob=vec_prob_Frank)
        
        for (i in 1:90){ #Para cada minuto del partido
            aleatorio = runif(1,0,1) #Creo un número aleatorio
            if (eleccion_Frank[i]+eleccion_Mou[i]==2) { #Si ambos son ofensivos
                #Si el número aleatorio cae sobre la probabilidad de meter gol, se le suma un gol
                gol_F[i]=(as.numeric(aleatorio<=p_ambos_of))
                gol_M[i]=(as.numeric(aleatorio<=p_ambos_of))
            }
            
            else if (eleccion_Frank[i]==1 & eleccion_Mou[i]==0) {#Si Frank es ofensivo y Mou defensivo
                #Si el número aleatorio cae sobre la probabilidad de meter gol, se le suma un gol
                gol_F[i]=(as.numeric(aleatorio<=p_of))
                gol_M[i]=(as.numeric(aleatorio<=p_def))
            }
            else if (eleccion_Frank[i]==0 & eleccion_Mou[i]==1) {#Si Frank es defensivo y Mou ofensivo
                #Si el número aleatorio cae sobre la probabilidad de meter gol, se le suma un gol
                gol_F[i]=(as.numeric(aleatorio<= p_def))
                gol_M[i]=(as.numeric(aleatorio<= p_of))
            }
            else if (eleccion_Frank[i]+ eleccion_Mou[i]==0){ #Si ambos son defensivos
                #No hay goles
                gol_F[i]=p_ambos_def
                gol_M[i]=p_ambos_def
            }
            #1er loop
        }
        #2do loop
        
        if(sum(gol_F)>sum(gol_M)){#si la suma de goles de Frank es mayor a la suma de Mou
            Goles_totales[j]= 1 #A la lista de victorias totales se le agrega un 1
        }
        else {
            Goles_totales[j]=0 #Sino se le agrega un cero
        }
    }
    Probabilidad_Frank_gane=mean(Goles_totales) #Esta es la probabilidad que Frank gane
}


#Optimizamos la función, en un intervalo de 0 a 1 en forma de maximizar
optimize(jugar_ofensivo,interval=c(0,1),maximum=TRUE)
#Nos da como resultado el máximo: es la probabilidad de jugar ofensivo que maximiza la probabilidad que Frank gane
#El objetivo es: la probabilidad máxima que Frank gane dada la probabilidad de jugar ofensivo



















