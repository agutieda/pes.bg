
# Taller 2
#
# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala

# Integrantes: Mariela Benavides
#              Ernesto Monterroso
#              Allan Santizo


#############################################################################
# SOLUCIÓN NUMÉRICA DE ECUACIONES DE ECUACIONES NO LINEALES
rm(list=ls()); graphics.off()
library(nleqslv)

#Definiendo la función 
Franky_L <- expression(
    ((C^(1/e))+a*(1-(C/w))^(k/e))^e
)
Franky_L
Franky_L[[1]]

#Enconctrando primera derivada, condiciones de primer orden 
funD <- D(Franky_L,"C")
funD


#Devuelve en forma simbólica la condición de primer orden

new_fun <-function(C,w=1,a=2,e=3,k=0.8){return(eval(funD))}

vec = seq(0,1,length.out = 100)

prueba = new_fun(vec)
resultados <- nleqslv(0.2,new_fun)
resultados
C_opt <- resultados$x  # Sacamos el valor de x que resuelve la ecuacion
C_opt # Encontrando en forma númerica el nivel de consumo óptimo

x11()
plot(vec, prueba,type="l")

#############################################################################

# OPTIMIZACIÓN NUMÉRICA
rm(list=ls()); graphics.off()

library("nloptr")

superfrank <-function(C,w=1,a=2,e=3,k=0.8){
    return (((C^(1/e))+a*(1-(C/w))^(k/e))^e)
    }

resultados = optimize(superfrank,c(0,1), maximum = TRUE)
     
resultados$maximum # Devuelve el máximo de la función

#############################################################################

# ¿Cuál es la probabilidad que Frank gane el partido?
#SIMULACIÓN MONTECARLO

# Parámetros
PO_Frank = 0.5
PD_Frank = 0.5
PO_Mou= 0.05
PD_Mou = 0.95
nSim = 10000
G_M=rep(NaN,90)
G_F=rep(NaN,90)
R_Mou=rep(NaN,nSim)
R_Frank=rep(NaN,nSim)

for (j in 1:nSim){
    for (i in 1:90){
        
        
        decision_Mou = runif(1)
        decision_Frank = runif(1)
        
        if (decision_Frank >=0.5 & decision_Mou >=0.95){
            Gol_Mou=runif(1)
            Gol_Frank=runif(1)
            if (Gol_Mou>=0.95){
                G_M[i]=1}
            else {G_M[i]=0}
            if (Gol_Frank>=0.95){
                G_F[i]=1}
            else {G_F[i]=0}
        }
        
        
        
        if (decision_Frank >=0.5 & decision_Mou <0.95){
            Gol_Mou=runif(1)
            Gol_Frank=runif(1)
            if (Gol_Mou<=0.01){
                G_M[i]=1}
            else {G_M[i]=0}
            if (Gol_Frank<=0.03){
                G_F[i]=1}
            else {G_F[i]=0}
        }
        
        
        if (decision_Frank <0.5 & decision_Mou >=0.95){
            Gol_Mou=runif(1)
            Gol_Frank=runif(1)
            if (Gol_Mou<=0.03){
                G_M[i]=1}
            else {G_M[i]=0}
            if (Gol_Frank<=0.01){
                G_F[i]=1}
            else {G_F[i]=0}
        }
        
        
        if (decision_Frank <0.5 & decision_Mou <0.95){
            G_M[i]=0 ; G_F[i]=0}
    }
    
    
    Spurs = sum(G_M)
    Blues = sum(G_F)
    
    if (Spurs>Blues){
        #cat("Tottenham GANA", Spurs,"a", Blues,"a Chelsea")
        R_Mou[j]=1
        R_Frank[j]=0
    }
    
    if (Spurs==Blues){
        #cat("Empate", Spurs,"a", Blues,"entre Tottenham y Chelsea")
        R_Mou[j]=0
        R_Frank[j]=0
    }
    
    if (Spurs<Blues){
        #cat("Chelsea GANA", Blues,"a", Spurs,"a Tottenham")
        R_Mou[j]=0
        R_Frank[j]=1
    }
}

sum(R_Frank)/nSim #Esta es la probabilidad de que Frank gane el partido 
#considerando p=0.5 de jugar a la ofensiva.

                                #####################

#¿Cuál es la probabilidad de jugar a la ofensiva, que maximice la probabilidad
#que Frank gane?

# Parámetros



maxi = function(x){
    
    # Parámetros
    PO_Frank = 0.5
    PD_Frank = 0.5
    PO_Mou= 0.05
    PD_Mou = 0.95
    nSim = 1000
    G_M=rep(NaN,90)
    G_F=rep(NaN,90)
    R_Mou=rep(NaN,nSim)
    R_Frank=rep(NaN,nSim)
    
    for (j in 1:nSim){
        for (i in 1:90){
            
            
            decision_Mou = runif(1)
            decision_Frank = runif(1)
            
            if (decision_Frank >=x & decision_Mou >=0.95){
                Gol_Mou=runif(1)
                Gol_Frank=runif(1)
                if (Gol_Mou>=0.95){
                    G_M[i]=1}
                else {G_M[i]=0}
                if (Gol_Frank>=0.95){
                    G_F[i]=1}
                else {G_F[i]=0}
            }
            
            
            
            if (decision_Frank >=x & decision_Mou <0.95){
                Gol_Mou=runif(1)
                Gol_Frank=runif(1)
                if (Gol_Mou<=0.01){
                    G_M[i]=1}
                else {G_M[i]=0}
                if (Gol_Frank<=0.03){
                    G_F[i]=1}
                else {G_F[i]=0}
            }
            
            
            if (decision_Frank < x & decision_Mou >=0.95){
                Gol_Mou=runif(1)
                Gol_Frank=runif(1)
                if (Gol_Mou<=0.03){
                    G_M[i]=1}
                else {G_M[i]=0}
                if (Gol_Frank<=0.01){
                    G_F[i]=1}
                else {G_F[i]=0}
            }
            
            
            if (decision_Frank < x & decision_Mou <0.95){
                G_M[i]=0 ; G_F[i]=0}
        }
        
        
        Spurs = sum(G_M)
        Blues = sum(G_F)
        
        if (Spurs>Blues){
            #cat("Tottenham GANA", Spurs,"a", Blues,"a Chelsea")
            R_Mou[j]=1
            R_Frank[j]=0
        }
        
        if (Spurs==Blues){
            #cat("Empate", Spurs,"a", Blues,"entre Tottenham y Chelsea")
            R_Mou[j]=0
            R_Frank[j]=0
        }
        
        if (Spurs<Blues){
            #cat("Chelsea GANA", Blues,"a", Spurs,"a Tottenham")
            R_Mou[j]=0
            R_Frank[j]=1
        }
    }
    
    return(sum(R_Frank)/nSim)
    
    
}    


res = optimize(maxi,c(0,1))

res$minimum # Devuelve la probabilidad de jugar a la ofensiva
#que maximiza la probabilidad de que Frank gane el partido

