rm(list=ls())
graphics.off()

#Solucion Numerica de Ecuaciones No-Lineales

#Reemplace la restricción presupuestal en la función objetivo para reducir la dimensión del problema.
#Escriba un programa de R que encuentre, de forma simbólica, la condición de primer orden que caracteriza la solución del problema 
library(nleqslv)
funcion <- expression(((w^(1/E))*(L^(1/E))+a*(1-L)^(k/E))^E)

D_funcion <- D(funcion,"L")
D_funcion

#Encuentre de forma numérica el nivel de consumo que resuelve la anterior ecuación 
a <- 2
E <- 3
k <- 0.8
w <- 1

f=function(L,a,k,w,E){return(eval(D(funcion,"L")))}

L0=0.1

result=nleqslv(L0,f,a=2,E=3,k=0.8,w=1)
result
L_optimo=result$x
L_optimo
C_optimo=w*L_optimo
C_optimo

#Optimizacion Numerica

# Vamos a resolver el siguiente problema de optimizacion
# max{C,L} [C^(1/E)+a*(1-L)^(k/E)]^E
# s.t.
# C=wL

library("nloptr")
a <- 2
E <- 3
k <- 0.8
w <- 1

#C <- x[1]
#L <- x[2]

#Se obtiene el gradiente de la funcion objetivo
funcion2 <- expression(((C^(1/E))+a*(1-L)^(k/E))^E)

#Gradiente para Consumo (C)
G_funcC <- D(funcion2,"C")
G_funcC

#Gradiente para Trabajo (L)
G_funcL <- D(funcion2,"L")
G_funcL

# Primero, definimos la funcion
eval_f <- function(x) {
    return( 
        list("objective" = ((x[1]^(1/E))+a*(1-x[2])^(k/E))^E,
              "gradient"  = c(((x[1]^(1/E)) + a*(1 - x[2])^(k/E))^(E - 1)*(E*(x[1]^((1/E) - 1)*(1/E))),
                              -(((x[1]^(1/E)) + a*(1 - x[2])^(k/E))^(E - 1)*(E *(a *((1 - x[2])^((k/E)-1)*(k/E)))))))
           )                                                                      
}


# Ahora definimos las restricciones del problema de optimizacion como funciones
# Restricciones de Igualdad
eval_g_eq <- function(x) {
    constr <- c( x[1] - w*x[2] )
    grad <- c( 1,
               w
                   )
    return( list( "constraints"=constr, "jacobian"=grad ) )
}

# Ahora definimos los valores iniciales
x0 <- c(0.1,0.1)

# Y unos valores minimos y maximos que sirvan para acotar la solucion
lb <- c(0,0)  # Valores minimos
ub <- c(100,50)  # Valores maximos

# Especifiquemos el tipo de algoritmo y otras opciones
local_opts <- list(
    "algorithm" = "NLOPT_LD_MMA",
    "xtol_rel" = 1.0e-7
)

opts <- list(
    "algorithm" = "NLOPT_LD_AUGLAG",
    "xtol_rel" = 1.0e-7,
    "maxeval" = 1000,
    "local_opts" = local_opts
)

# Ahora si, invoquemos la funcion de optimizacion
res <- nloptr( 
    x0=x0,
    eval_f=eval_f,
    lb=lb,
    ub=ub,
    eval_g_eq=eval_g_eq,
    opts=opts
)

print(res)

#Simulacion de Montecarlo
#Probabilidad que Frank gane el partido

probAmbosDef=0
probAmbosOf=0.05
probDf=0.01
probOf=0.03
nMin=90
nSimu=1000 
vec = c(0,1)

#0 = jugar al a defensiva
#1 = jugar a la ofesiva


probFrank = c(0.5,0.5) 

probMou = c(0.95,0.05)


totalGoles= rep(NaN,nSimu) 

for(j in 1:nSimu){ 
    golesFrank = rep(NaN,nMin) 
    golesMou = rep(NaN,nMin) 
    
    tecMou = sample(vec, size=nMin, replace=TRUE, prob=probMou)
    tecFrank = sample(vec, size=nMin, replace=TRUE, prob=probFrank)
    
    for (i in 1:90){ 
        moneda = runif(1,0,1) 
        if (tecFrank[i]+tecMou[i]==2) { 
            golesFrank[i]=(as.numeric(moneda<=probAmbosOf))
            golesMou[i]=(as.numeric(moneda<=probAmbosOf))
        }
        
        else if (tecFrank[i]==1 & tecMou[i]==0) {
            golesFrank[i]=(as.numeric(moneda<=probOf))
            golesMou[i]=(as.numeric(moneda<=probDf))
        }
        else if (tecFrank[i]==0 & tecMou[i]==1) {
            golesFrank[i]=(as.numeric(moneda<= probDf))
            golesMou[i]=(as.numeric(moneda<= probOf))
        }
        else if (tecFrank[i]+ tecMou[i]==0){ 
            golesFrank[i]=probAmbosDef
            golesMou[i]=probAmbosDef
        }
    }
    
    if(sum(golesFrank)>sum(golesMou)){
        totalGoles[j]= 1 
    }
    else {
        totalGoles[j]=0 
    }
}
probFrank_Ganar=mean(totalGoles) 

probFrank_Ganar


#probabilidad de jugar a la ofensiva que maximiza la probabilidad de que Frank gane el partido
maxProbFrank=function(x) {
    probAmbosDef=0
    probAmbosOf=0.05
    probDf=0.01
    probOf=0.03
    nMin=90
    nSimu=1000 
    vec = c(0,1)
    
    #0 = jugar al a defensiva
    #1 = jugar a la ofesiva
    
    
    probFrank = c(0.5,0.5) 
    
    probMou = c(0.95,0.05)
    
    
    totalGoles= rep(NaN,nSimu) 
    
    for(j in 1:nSimu){ 
        golesFrank = rep(NaN,nMin) 
        golesMou = rep(NaN,nMin) 
        
        tecMou = sample(vec, size=nMin, replace=TRUE, prob=probMou)
        tecFrank = sample(vec, size=nMin, replace=TRUE, prob=probFrank)
        
        for (i in 1:90){ 
            moneda = runif(1,0,1) 
            if (tecFrank[i]+tecMou[i]==2) { 
                golesFrank[i]=(as.numeric(moneda<=probAmbosOf))
                golesMou[i]=(as.numeric(moneda<=probAmbosOf))
            }
            
            else if (tecFrank[i]==1 & tecMou[i]==0) {
                golesFrank[i]=(as.numeric(moneda<=probOf))
                golesMou[i]=(as.numeric(moneda<=probDf))
            }
            else if (tecFrank[i]==0 & tecMou[i]==1) {
                golesFrank[i]=(as.numeric(moneda<= probDf))
                golesMou[i]=(as.numeric(moneda<= probOf))
            }
            else if (tecFrank[i]+ tecMou[i]==0){ 
                golesFrank[i]=probAmbosDef
                golesMou[i]=probAmbosDef
            }
        }
        
        if(sum(golesFrank)>sum(golesMou)){
            totalGoles[j]= 1 
        }
        else {
            totalGoles[j]=0 
        }
    }
    probFrank_Ganar=mean(totalGoles) 
    probFrank_Ganar
    
}

optimize(maxProbFrank,interval=c(0,1),maximum=TRUE)






