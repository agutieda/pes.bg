#INCISO 2
# Cálculo de desviación estándard de los estimadores por medio de Bootstrap

# Importar datos desde Archivo xls

graphics.off()
rm(list=ls())

library(readxl)
inflacion <- read_excel("inflacion.xlsx")

vec_y= inflacion$inflacion

vec_y

nT=length(vec_y)



#Función de sumatoria

sumatoria <- function(theta,y=vec_y){
    
    suma=rep(0,length.out= nT)
    
    for ( i in 2:nT){
        
        suma[i] = ((y[i] - theta[1]-theta[2]*y[i-1])^2)/ (2*theta[3])
    }
    
    return(sum(suma))
}

#Función máxima verosimilitud

log_lh <- function(theta,y=vec_y){
    
    a = (-1/2)*log(2*pi) 
    b = -(1/2)*log(theta[3]/(1-theta[2]^2))
    c = -((y[1]-(theta[1]/(1-theta[2])))^2)/((2*theta[3])/(1-theta[2]^2))
    d = -((nT-1)/2)*log(2*pi)-(((nT-1)/2)*log(theta[3])) - sumatoria(theta,y=vec_y)
    
    verosimilitud = a+b+c+d
    
    
    return(verosimilitud)
    }

##Errores estandar del estimador de máxima verosimilitud 


error_estandar <- function(v)
    
{J= optim(v,log_lh,control=list(fnscale=-1),hessian=TRUE)$hessian

J_1=J*(-1/nT)
J_1

sigma_gorro = sqrt(diag(solve(J_1)))

return(sigma_gorro)}


v=c(0.25,0.8,0.6)
#obtener estimadores
theta_gorro= optim(v,log_lh,control=list(fnscale=-1))$par
#obtener errores
errores = error_estandar(v)

theta_gorro
errores 

#generando y's estimados

simular_y <- function(theta_gorro,vec_y,nT){
    y=rep(NaN,1)
    
    y[1]=vec_y[1]
    
    for (t in 2:nT){
        y[t]=theta_gorro[1]+theta_gorro[2]*vec_y[t-1]
    }
    return(y)
}

y_estimado = simular_y(theta_gorro,vec_y,nT)

epsilon_estimado= vec_y - y_estimado
x11()
plot(epsilon_estimado, type="l")

var(epsilon_estimado)



#################################################################

#generando thetas para errores

simular_AR1loop <- function(theta_gorro, vec_y,  epsilon_estimado){
    y=rep(NaN,1)
    
    y[1]= rnorm(1,mean = theta_gorro[1], sd = sqrt(theta_gorro[3]))
    epsilon_shuffle = sample(epsilon_estimado,replace=FALSE)
    
    for (t in 2:nT){
        y[t]=theta_gorro[1]+theta_gorro[2]*y[t-1]+epsilon_shuffle[t]
    }
    return(y)
}



nSim=1000
resultados_mu=rep(NA,nSim)
resultados_rho=rep(NA,nSim)
resultados_sigma=rep(NA,nSim)


sumat <- function(theta,y=y_simul){
    
    suma=rep(0,length.out= nT)
    
    for ( i in 2:nT){
        
        suma[i] = ((y[i] - theta[1]-theta[2]*y[i-1])^2)/ (2*theta[3])
    }
    
    return(sum(suma))
}

#Función máxima verosimilitud

log_l <- function(theta,y=y_simul){
    
    a = (-1/2)*log(2*pi) 
    b = -(1/2)*log(theta[3]/(1-theta[2]^2))
    c = -((y[1]-(theta[1]/(1-theta[2])))^2)/((2*theta[3])/(1-theta[2]^2))
    d = -((nT-1)/2)*log(2*pi)-(((nT-1)/2)*log(theta[3])) - sumat(theta,y_simul)
    
    verosimilitud = a+b+c+d
    
    
    return(verosimilitud)
}


for (k in 1:nSim){
    
    #Parámetros
    theta = c(0,0,0)
    
    #Simulando yt
    y_simul = simular_AR1loop(theta_gorro,vec_y, epsilon_estimado )
    
    ##Optimizando la función
    v=c(0.3,0.9,0.5)
    
    resumen= optim(v,log_l,control=list(fnscale=-1))
    
    resultados_mu[k]=resumen$par[1]
    resultados_rho[k]=resumen$par[2]
    resultados_sigma[k]=resumen$par[3]
    
    
    
}

x11();hist(resultados_mu,breaks=50,col="skyblue")
x11()
hist(resultados_rho,breaks=50,col="darkred")
x11()
hist(resultados_sigma,breaks=50,col="midnightblue")

sqrt(var(resultados_mu))
sqrt(var(resultados_rho))
sqrt(var(resultados_sigma))
