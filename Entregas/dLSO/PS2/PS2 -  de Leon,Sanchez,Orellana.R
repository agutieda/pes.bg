graphics.off();rm(list=ls())

#TALLER 2
#INTEGRANTES:
#JOSÉ DOMINGO DE LEÓN
#HUGO LEONEL ORELLANA
#DIEGO IGNACIO SÁNCHEZ

install.packages("nloptr") #Instalamos el paquete para optimizar funciones bi-variadas
library("nloptr") #Llamamos al paquete para usar sus funciones


#SOLUCIÓN NUMÉRICA DE ECUACIONES NO LINEALES

k=runif(1) #Damos un valor aleatorio entre 0 y 1 para k
eps=runif(1,1,50) #Damos un valor aleatorio mayor que 1 para epsilon
alpha=runif(1,1,20) #Damos un valor aleatorio entre 0 y 1 para alpha
w=runif(1,1,50) #Un valor aleatorio entre 1 y 50 para el salario

#Encuentre de forma numérica el nivel de consumo que resuelve la anterior ecuación
funcion <-function(L) return(-((w*L)^(1/eps)+alpha*((1-L)^(k/eps)))^eps)
#Función que nos da la función de utilidad de Frank Lampard
L<-runif(1) #Asignamos un valor aleatorio para el trabajo de Frankie
optimizacion<-lbfgs(L,funcion)#Método que optimiza la función dados los valores anteriores.   
optimizacion

#Escriba un programa de R que encuentre, de forma simbólica, la condición de primer orden que caracteriza la solución del problema
simbolo <- expression(((w*L)^(1/eps)+alpha*((1-L)^(k/eps)))^eps) #Volvemos de forma simbólica a la expresión
simbolo
dsimbolo <- D(simbolo,"L") #Se deriva con respecto a "L"
dsimbolo

#OPTIMIZACIÓN NUMÉRICA
k=0.8 #Damos un valor aleatorio entre 0 y 1 para k
eps=3 #Damos un valor aleatorio mayor que 1 para epsilon
alpha=2 #Damos un valor aleatorio entre 0 y 1 para alpha
w=1 #Un valor aleatorio entre 1 y 50 para el salario

funcion <-function(L) return(-((w*L)^(1/eps)+alpha*((1-L)^(k/eps)))^eps)
L<-0.4
optimizacion<-lbfgs(L,funcion)
optimizacion


#Nota, como se tienen varios mínimos, y solo un máximo, esque se escribe el 
#negativo de la función.

#SIMULACIÓN MONTECARLO

num.simulaciones <- 100000
vmou=0
vfrank=0
empate=0

for (i in 1:num.simulaciones) {
    mf = 0
    mm = 0
    
    for (i in 1:90) {
       
        mou = runif(1)
        frank = runif(1)
        golf = runif(1)
        golm = runif(1)
        if (mou > 0.95 & frank > 0.5) {
            if (golf > 0.05 & golm > 0.05) {
                mf = mf + 0
                mm = mm + 0
            }
            if (golf < 0.05 & golm > 0.05) {
                mf = mf + 1
                mm = mm + 0
            }
            if (golf > 0.05 & golm < 0.05) {
                mf = mf + 0
                mm = mm + 1
            }
            if (golf < 0.05 & golm < 0.05) {
                mf = mf + 1
                mm = mm + 1
            }
        }
        if (mou > 0.95 & frank < 0.5) {
            if (golf > 0.01 & golm > 0.03) {
                mf = mf + 0
                mm = mm + 0
            }
            if (golf < 0.01 & golm > 0.03) {
                mf = mf + 1
                mm = mm + 0
            }
            if (golf > 0.01 & golm < 0.03) {
                mf = mf + 0
                mm = mm + 1
            }
            if (golf < 0.01 & golm < 0.03) {
                mf = mf + 1
                mm = mm + 1
            }
        }
        if (mou < 0.95 & frank > 0.5) {
            if (golf > 0.03 & golm > 0.01) {
                mf = mf + 0
                mm = mm + 0
            }
            if (golf < 0.03 & golm > 0.01) {
                mf = mf + 1
                mm = mm + 0
            }
            if (golf > 0.03 & golm < 0.01) {
                mf = mf + 0
                mm = mm + 1
            }
            if (golf < 0.03 & golm < 0.01) {
                mf = mf + 1
                mm = mm + 1
            }
        }
        if (mou < 0.95 & frank < 0.5) {
            mf = mf + 0
            mm = mm + 0
        }
    }
    if (mf > mm) {
        vfrank = vfrank + 1
    }
    if (mf < mm) {
        vmou = vmou + 1
    }
    if (mf == mm) {
        empate = empate + 1
    }
}
empate
vfrank
vmou
probfrank=vfrank/(num.simulaciones)
probfrank

## Prob de jugar a la ofensiva que max prob de ganar partido

funcionn<-function(p){
    num.simulaciones <-100
    vmou=0
    vfrank=0
    empate=0
    
    for (i in 1:num.simulaciones) {
        mf = 0
        mm = 0
        
        for (i in 1:90) {
            
            mou = runif(1)
            frank = runif(1)
            golf = runif(1)
            golm = runif(1)
            if (mou > 0.95 & frank > p) {
                if (golf > 0.05 & golm > 0.05) {
                    mf = mf + 0
                    mm = mm + 0
                }
                if (golf < 0.05 & golm > 0.05) {
                    mf = mf + 1
                    mm = mm + 0
                }
                if (golf > 0.05 & golm < 0.05) {
                    mf = mf + 0
                    mm = mm + 1
                }
                if (golf < 0.05 & golm < 0.05) {
                    mf = mf + 1
                    mm = mm + 1
                }
            }
            if (mou > 0.95 & frank < p) {
                if (golf > 0.01 & golm > 0.03) {
                    mf = mf + 0
                    mm = mm + 0
                }
                if (golf < 0.01 & golm > 0.03) {
                    mf = mf + 1
                    mm = mm + 0
                }
                if (golf > 0.01 & golm < 0.03) {
                    mf = mf + 0
                    mm = mm + 1
                }
                if (golf < 0.01 & golm < 0.03) {
                    mf = mf + 1
                    mm = mm + 1
                }
            }
            if (mou < 0.95 & frank > p) {
                if (golf > 0.03 & golm > 0.01) {
                    mf = mf + 0
                    mm = mm + 0
                }
                if (golf < 0.03 & golm > 0.01) {
                    mf = mf + 1
                    mm = mm + 0
                }
                if (golf > 0.03 & golm < 0.01) {
                    mf = mf + 0
                    mm = mm + 1
                }
                if (golf < 0.03 & golm < 0.01) {
                    mf = mf + 1
                    mm = mm + 1
                }
            }
            if (mou < 0.95 & frank < p) {
                mf = mf + 0
                mm = mm + 0
            }
        }
        if (mf > mm) {
            vfrank = vfrank + 1
        }
        if (mf < mm) {
            vmou = vmou + 1
        }
        if (mf == mm) {
            empate = empate + 1
        }
    }
    probfrank=vfrank/(num.simulaciones)
    probfrank
    return(probfrank)    
}

funcionn(0.5)
optimize(funcionn,c(0,1))
