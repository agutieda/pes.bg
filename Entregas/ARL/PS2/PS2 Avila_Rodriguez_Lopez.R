rm(list=ls())
graphics.off()

install.packages("nloptr")
library(nloptr)

#Parametros
epsilon = 3
k = 0.8
w = 1
a = 2
 
# Solución en forma simbólica
sym_fun = expression(((w*L)^(1/epsilon) + a*(1 - L)^(k/epsilon))^epsilon)
sym_fun
sym_fun[1]
sym_fun[[1]]

D_sym_fun = D(sym_fun, "L")
D_sym_fun

f1 = function(L, a,k,w,epsilon){return(eval(D(sym_fun, "L")))}

#El nivel de consumo en forma numérica

# Se resuelve un sistema de ecuaciones no lineales, mediante la libreria "nleqslv", con el fin de 
# encontrar L óptimo. 

install.packages('nleqslv')
library(nleqslv)
L0 = 0.20
resultados= nleqslv(L0, f1,a=2,epsilon=3,k=0.8,w=1)
resultados
L_opt = resultados$x
L_opt
C_opt = w*L_opt
C_opt

#Optimización numérica

funOpt <- function(L,w=1,epsilon=3,a=2,k=0.8) return(((w*L)^(1/epsilon) + a*(1 - L)^(k/epsilon))^epsilon) 

# Nombrando como funOpt el problema de optimización se hace uso del comando de "optimize" para encontrar
# el valor de L que maximiza dicha función. 

resultado1 = optimize(funOpt, c(0, 1), maximum =TRUE )
resultado1  

#Simulación MonteCarlo

#PARTE 1: Probabilidad de que Frank gane el partido 

golMou = 0
golFrank = 0
goles = 0
num.simulaciones = 1000
minutos = 90

# Se realizo un loop para las simulaciones de partidos jugados y luego se realizo un loop
# para cada minuto de un partido. Se crearon aleatorios tanto como para la probabilidad de 
# jugar ofensivo/defensivo para Frank y Mourinho por lo que se crearon condicionales para las 
# posibles tecnicas (DD, DO, OD, OO). Así mismo se crearon aleatorios para la probabilidad de gol
# las cuales, dentro de los condicionales de las técnicas se realizaron así mismo condicionales para 
# determinar si se sumaba o no goles. Por lo que al finalizar el loop de simulaciones se tuviera una 
# sumaTotal de goles, la cual funciona para calcular la probabilidad de que gane Frank. 

for (i in 1:num.simulaciones){
    for (i in 1:minutos){ 
    
    al_Mou=runif(1, min=0, max=1)
    al_Frank = runif(1, min=0, max=1)
    al_golFrank = runif(1, min=0, max=1)
    al_golFrank
    al_golMou = runif(1, min=0, max=1)
    al_golMou
    if (al_Mou > 0.05 & al_Frank>=0.5){
        Tec = "DD"
        golFrank = golFrank+0
        golMou = golMou+0
       
    }
        
    if (al_Mou>0.05 & al_Frank<0.5){
        Tec = "DO"
     
        if(al_golFrank ==0.01 ){
            golFrank = golFrank+1
        }
        if (al_golMou == 0.03){
            golMou = golMou+1
        }
    }
            
    if (al_Mou <= 0.05 & al_Frank >=0.5){
        Tec = "OD"
       
        if(al_golFrank ==0.03 ){
            golFrank = golFrank+1
        }
        if (al_golMou == 0.01){
            golMou = golMou+1
        }
    }
                
    if(al_Mou <= 0.05 & al_Frank < 0.5){
        Tec = "OO"
        
        if(al_golFrank <=0.05 ){
            golFrank = golFrank+1
        }
        if (al_golMou <= 0.05){
            golMou = golMou+1
        }
    }
            
    }
goles = golFrank + golMou
ProbFrankwin = (golFrank/goles)*100 #Respuesta 
Tec
}

# PARTE 2: Probabilidad que maximiza la probabilidad de que Frank gane el partido 

# Tomando como fundamento el inciso 1, se convirtio el inciso en función, en el cual se convirtió
# en una variable x la probabilidad de jugar ofensivo y (1-x) la probabilidad de jugar defensivo. 

funmax = function(x){
    golMou = 0
    golFrank = 0
    goles = 0
    num.simulaciones = 5000
    minutos = 90
    for (i in 1:num.simulaciones){
        for (i in 1:minutos){
            
            al_Mou=runif(1, min=0, max=1)
            al_Frank = runif(1, min=0, max=1)
            al_golFrank = runif(1, min=0, max=1)
            al_golFrank
            al_golMou = runif(1, min=0, max=1)
            al_golMou
            if (al_Mou > 0.05 & al_Frank>=x){
                Tec = "DD"
                golFrank = golFrank+0
                golMou = golMou+0
              
            }
            
            if (al_Mou>0.05 & al_Frank < 1-x){
                Tec = "DO"
                
                if(al_golFrank ==0.01 ){
                    golFrank = golFrank+1
                }
                if (al_golMou == 0.03){
                    golMou = golMou+1
                }
            }
            
            if (al_Mou <= 0.05 & al_Frank >= x){
                Tec = "OD"
         
                if(al_golFrank ==0.03 ){
                    golFrank = golFrank+1
                }
                if (al_golMou == 0.01){
                    golMou = golMou+1
                }
            }
            
            if(al_Mou <= 0.05 & al_Frank < 1-x){
                Tec = "OO"
                
                if(al_golFrank <=0.05 ){
                    golFrank = golFrank+1
                }
                if (al_golMou <= 0.05){
                    golMou = golMou+1
                }
            }
            
        }
        goles = golFrank + golMou
        ProbFrankwin = (golFrank/goles)*100
        
    }
    return (ProbFrankwin)
}

# La función retorna la probabilidad de que Frank gane, por lo que se procede a 
# realizar la optimización mediante el comando de "optimize".

valor = optimize(funmax, interval=c(0, 1), maximum =TRUE)
valor







