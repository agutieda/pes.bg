#Byron Ajanel Gonzalez
#Andres Ortiz Flores

###############################################################
#Estimacion de un AR(1): Parte 1
###############################################################
#1) Cree una función que evalúe la log-verosimilitud del proceso en el punto 
#θ =[µ,ρ,σ2], dadas las observaciones yt simuladas. 

Theta=c(mu,rho,sigmasq)

Log_Vero= function(x){
    sumatoria <- vector(mode="numeric", length=T)
    
    for(t in 2:T){
        sumatoria[t]=(y[t]-x[1]-x[2]*y[t-1])^2/(2*x[3])
    }
    suma=sum(sumatoria)
    
    logLamd= -(0.5)*log(2*pi)-(0.5)*log(x[3]/(1-x[2]^2))
    logLamd=logLamd -((y0-(x[1]/(1-x[2])))^2/((2*x[3])/(1-x[2]^2)))
    logLamd=logLamd-((T-1)/2)*log(2*pi)-((T-1)/2)*log(x[3])
    logLamd=logLamd-suma
    
    return(logLamd)
}

Log_Vero(Theta)


####2)Genere el vector εt y el valor inicial y1 y simule T = 100 observaciones 
#del proceso yt con los parámetros µ = 1, ρ = 0.4 y σ2 = 0.5. 

# El proceso es:
# y(t) = mu + rho*y(t-1) + epsilon(t); epsilon(t)~N(0,sigma^2); y(0) dado.

rm(list=ls())
graphics.off()

#set.seed(5)
####Parametros del modelo ####
T     <- 100         # Numero de observaciones a simular
rho   <- 0.4        # Persistencia del proceso
mu    <- 1      # Constante del proceso
sigmasq <- 0.5 
sigma <- sqrt(sigmasq)      # Desv. Est. de los choques del proceso
y0    <- 0          # Valor inicial del proceso  



####Esribimos una funcion que simule el proceso ###
ar1_sim <- function(rho_sim,mu_sim,sigma_sim,y0_sim,T_sim,epsilon_sim){
    y_sim <- vector(mode="numeric", length=T) 
    y_sim[1] <- y0_sim
   
    
    for(t in 2:T_sim){
        y_sim[t]=mu_sim+rho_sim*y_sim[t-1]+epsilon_sim[t]
    }
    
    return(y_sim)
    
}

####Procesos Exogenos ####
epsilon <- rnorm(T, mean = 0, sd = sigma)

# Llamar la funcion
y <- ar1_sim(mu_sim=mu,sigma_sim=sigma,y0_sim=y0,T_sim=T,epsilon_sim=epsilon,rho_sim=rho)


####Funcion Log-Verosimilitud
Theta=c(mu,rho,sigmasq)


Log_Vero= function(x){
    sumatoria <- vector(mode="numeric", length=T)
    
    for(t in 2:T){
        sumatoria[t]=(y[t]-x[1]-x[2]*y[t-1])^2/(2*x[3])
    }
    suma=sum(sumatoria)
    
    logLamd= -(0.5)*log(2*pi)-(0.5)*log(x[3]/(1-x[2]^2))-((y0-(x[1]/(1-x[2])))^2/((2*x[3])/(1-x[2]^2)))-((T-1)/2)*log(2*pi)-((T-1)/2)*log(x[3])-suma
    
    return(logLamd)
}

Log_Vero(Theta)

####3)Use una función de optimización numérica para encontrar el estimador de máxima verosimilitud
#θ =[µ,ρ,σ2], deﬁnido como el vector de parámetros que maximiza la función de 
#log-verosimilitud dados los datos simulados en el punto anterior 
#(Use como valores iniciales el vector θ = [0.5, 0.5, 0.5]) 


Theta_Inic=c(0.5,0.5,0.5)
optim(Theta_Inic, Log_Vero, control=list(fnscale=-1))


####4)Cree un ciclo que repita 1000 veces los pasos en los puntos (2) a (3) y 
#guarde los valores de θ =[µ,ρ,σ2] obtenidos en cada iteración. 
#Graﬁque el histograma de frecuencias de la distribución de el estimador de cada uno de estos parámetros.

ciclo=1000
estimadores=matrix(NA, nrow =ciclo, ncol =3)
for (i in 1:ciclo){
    y <- ar1_sim(mu_sim=mu,sigma_sim=sigma,y0_sim=y0,T_sim=T,epsilon_sim=epsilon,rho_sim=rho)
    epsilon <- rnorm(T, mean = 0, sd = sigma)
    estimadores[i,]=optim(Theta_Inic, Log_Vero, control=list(fnscale=-1))$par

    }
    
estimadores

###Histogramas
x11(); hist(estimadores[,1],col="blue",main = paste( "Estimadores Mu"),xlab ="Mu")
x11(); hist(estimadores[,2],col="green",main = paste("Estimadores Rho"),xlab = "Rho")
x11(); hist(estimadores[,3],col="purple",main = paste("Estimadores Sigmasq"),xlab = "Sigmasq")

###############################################################
#Estimacion de un AR(1): Parte 2
###############################################################

####1) Escriba una función que calcule los errores estándar del estimador de máxima verosimilitud θ.

ErroresSTD=function(Theta_Inic){
    opt=optim(Theta_Inic, Log_Vero, control=list(fnscale=-1),hessian = TRUE)
    #opt
    
    Hess=opt$hessian
    #Hess
    
    Jacobiana=-(1/T)*Hess
    #Jacobiana
    
    Invers_Jacobiana=solve(Jacobiana)
    #Invers_Jacobiana
    
    Diag_Inv_Jacobiana=diag(Invers_Jacobiana)
    #Diag_Inv_Jacobiana
    
    Errores_STD=sqrt(Diag_Inv_Jacobiana)
    #Errores_STD
    
    return(Errores_STD)
}   
    
ErroresSTD(Theta_Inic)    

####2) Utilice el código anterior para encontrar el estimador de máxima verosimilitud de un AR(1) 
#y sus errores estándar asociados para la serie de inﬂación mensual en la hoja de Excel adjunta a este taller.

library(readxl)
setwd("C:/Users/Andres/Desktop/Programacion II/Problemsets/PS3")
inflacion=read_excel("inflacion.xlsx")$inflacion
inflacion

#Transformacion de parametros iniciales a los dados por archivo .xlsx
T=180 #No. de observaciones en archivo "inflacion.xlsx"
y=inflacion
y0=y[1]
Theta_Inic=c(0.2,0.8,0.5)

Opt_Inflacion=optim(Theta_Inic, Log_Vero, control=list(fnscale=-1))
Opt_Inflacion

ErroresSTD(Theta_Inic) 







    