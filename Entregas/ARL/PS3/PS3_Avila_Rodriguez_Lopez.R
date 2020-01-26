##################################################################################
#                                    TAREA NO. 3                                 #
##################################################################################



##################################################################################
#                                    PARTE 1                                     #
##################################################################################

                                ##### INCISO I #####

log_ver = function(Theta,y,y1){
    
    suma = rep(0, 1)
    y[1] = y1
    for (t in 2:nT){
       
        suma[t] = (((y[t]-Theta[2]-Theta[1]*y[t-1])^2)/(2*Theta[3]))
        
    }
    sumatoria= sum(suma)
    
    loglike= -(1/2)*log(2*pi) - (1/2)*log(Theta[3]/(1-(Theta[1]^2))) - ((y[1]-(Theta[2]/(1-Theta[1])))^2)/((2*Theta[3])/(1-Theta[1]^2)) - ((nT-1)/2)*log(2*pi) - ((nT-1)/2)*log(Theta[3]) - sumatoria
    return (loglike)
}

                                ##### INCISO II #####

Theta = c(rho, mu, sigma)
set.seed(5)

#Parametros
rho = 0.4
mu = 1
sigma = 0.5
nT = 100
y0 = 0

#Generar valor inicial y1
y_uno = rnorm(1, mean = mu/(1-rho), sd = sqrt(sigma/(1-rho^2)))

#Generando vector de errores (choques) 
epsilon = rnorm(nT, mean = 0, sd = sqrt(sigma))


#Simulación yt
simular_AR1 = function(rho_sim,mu_sim,sigma_sim,y0_sim,nT_sim,epsilon_sim){
    y_sim = rep(NaN, 1)
    y_sim[1] = y0_sim
    
    for (t in 2:nT){
        y_sim[t] = mu_sim + rho_sim*y_sim[t-1] + epsilon_sim[t]
    }
    return(y_sim)
}



#Simulacion yt
y_simulada <- simular_AR1(mu_sim=mu,sigma_sim=sigma,y0_sim=y0,nT_sim=nT,epsilon_sim=epsilon,rho_sim=rho)


log_ver(Theta,y_simulada,y_uno) #Probando la función del Inciso I (log_ver)


                            ##### INCISO III #####

obj_fun <-function(Theta) return(log_ver(Theta,y_simulada,y_uno))

ThetaIni = c(0.5,0.5,0.5)

Estimador_semilla = (optim(ThetaIni,obj_fun,control=list(fnscale=-1)))$par
Estimador_semilla
###PENDIENTE Y1

                            ##### INCISO IV #####

Thetarho = rep(NaN,1)
Thetamu = rep(NaN,1)
Thetasigma = rep(NaN,1)

for (i in 1:1000){
    
    #simulacion de choques 
    epsilon = rnorm(nT, mean = 0, sd = sqrt(sigma))
    
    #Simulacion yt
    y_simulada <- simular_AR1(mu_sim=mu,sigma_sim=sigma,y0_sim=y0,nT_sim=nT,epsilon_sim=epsilon,rho_sim=rho)
    
    #Busqueda del vector Theta Optimo
    obj_fun <-function(Theta) return(log_ver(Theta,y_simulada,y_uno))
    
    ThetaIni = c(0.5,0.5,0.5)
    
    Estimador = (optim(ThetaIni,obj_fun,control=list(fnscale=-1)))$par
    
    #Adquisición de cada parametro
    
    Thetarho[i] = (optim(ThetaIni,obj_fun,control=list(fnscale=-1)))$par[1]
    Thetamu[i] = (optim(ThetaIni,obj_fun,control=list(fnscale=-1)))$par[2]
    Thetasigma[i] = (optim(ThetaIni,obj_fun,control=list(fnscale=-1)))$par[3]
    
}

x11(); hist(Thetarho,breaks=100,col="purple")
x11(); hist(Thetamu,breaks=100,col="blue")
x11(); hist(Thetasigma,breaks=100,col="green")

##################################################################################
#                                    PARTE 2                                     #
##################################################################################

                            ##### INCISO I #####

set.seed(5)
erroresEst <- function(cond_in,y,y1){
    
    funcion_objetivo <-function(Theta) return(log_ver(Theta,y,y1))
    
    J_1 = optim(cond_in,funcion_objetivo,control=list(fnscale=-1),hessian=TRUE)
    
    J_muestral = (-1/nT)*J_1$hessian
    
    J_inversa = solve(J_muestral)
    
    error_rho = sqrt(J_inversa[1,1])
    error_mu = sqrt(J_inversa[2,2])
    error_sigma = sqrt(J_inversa[3,3])
    
    errores=c(error_rho,error_mu,error_sigma)
    
    return (errores)
}

ThetaIni = c(0.5,0.5,0.5)


errores_y_sim = erroresEst(ThetaIni,y_simulada,y_uno)
errores_y_sim #Errores estandar de la y simulada. 

                            ##### INCISO II #####


#install.packages("readxl") #Para poder abrir archivos desde Excel se necesita instalar la libreria "readxl".

library(readxl)
inflacion <- read_excel("C:/Users/in_cap02/Desktop/Programacion II/ProblemSets/PS3/inflacion.xlsx")


inf_men_y<- inflacion$inflacion
nT =length(inf_men_y)
y0 = inf_men_y[1]

y_inflacion <- inf_men_y

log_ver(Theta,y_inflacion,y0)


#Busqueda del vector Theta Optimo

funcion_y_opt <-function(Theta) return(log_ver(Theta,y_inflacion,y0))

ThetaIni = c(0.5,0.5,0.5)

Estimador_optimo = (optim(ThetaIni,funcion_y_opt,control=list(fnscale=-1)))$par
Estimador_optimo

errores_y_sim = erroresEst(ThetaIni,y_inflacion,y0)
errores_y_sim 
