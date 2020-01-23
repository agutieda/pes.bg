# Taller 3
#
# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala

# Integrantes: Mariela Benavides
#              Ernesto Monterroso
#              Allan Santizo


#############################################################################
#PARTE 1
#INCISO 1
graphics.off()
rm(list=ls())
set.seed(5) 

#Parámetros

mu=1
rho=0.4
sigma=0.5
nT=100
theta = c(mu,rho,sigma)

epsilon =rnorm(nT, mean = 0, sd =sqrt(sigma))


#Simulando yt

simular_AR1 <- function(rho, nT, epsilon){
    y=rep(NaN,1)
    
    y[1]= rnorm(1,mean=(1/0.6),sd=sqrt(0.5/0.84))
    
    for (t in 2:nT){
        y[t]=mu+rho*y[t-1]+epsilon[t]
    }
    return(y)
}


vec_y = simular_AR1(rho,nT,epsilon)


#función de sumatoria

sumatoria <- function(theta,y){
    
    suma=rep(0,length.out= nT)
    
    for ( i in 2:nT){
    
        suma[i] = ((y[i] - theta[1]-theta[2]*y[i-1])^2)/ (2*theta[3])
            }
    
    return(sum(suma))
}

#función máxima verosimilitud

log_lh <- function(theta,y){
    
    a = (-1/2)*log(2*pi) 
    b = -(1/2)*log(theta[3]/(1-theta[2]^2))
    c = -((y[1]-(theta[1]/(1-theta[2])))^2)/((2*theta[3])/(1-theta[2]^2))
    d = -((nT-1)/2)*log(2*pi)-(((nT-1)/2)*log(theta[3])) - sumatoria(theta,y=vec_y)
 
    verosimilitud = a+b+c+d
    
        
return(verosimilitud)}


##Evaluando la función 
log_lh(theta,y=vec_y)

sumatoria(theta,y=vec_y)

x11()
plot(vec_y,type="l")
x11()
plot(epsilon,type="l")


########################################################################

#INCISO 2 Y 3


#Parámetros

nT=100
theta = c(mu,rho,sigma)


#función de sumatoria

sumatoria <- function(theta,y=vec_y){
    suma=rep(0,length.out= nT)
    for ( i in 2:nT){
        suma[i] = ((y[i] - theta[1]-theta[2]*y[i-1])^2)/ (2*theta[3])
    }
    return(sum(suma))
}

#función máxima verosimilitud

log_lh <- function(theta){
    
    a = (-1/2)*log(2*pi) 
    b = -(1/2)*log(theta[3]/(1-theta[2]^2))
    c = -((vec_y[1]-(theta[1]/(1-theta[2])))^2)/((2*theta[3])/(1-theta[2]^2))
    d = -((nT-1)/2)*log(2*pi)-(((nT-1)/2)*log(theta[3])) - sumatoria(theta,y=vec_y)
    
    verosimilitud = a+b+c+d
    
    
    return(verosimilitud)}


##Optimizando la función
v=c(0.5,0.5,0.5)

log_lh(v)

optim(v,log_lh,control=list(fnscale=-1))


###################################################################

#INCISO 4
#FUNCIONES #############
graphics.off()
rm(list=ls())

sumatoria <- function(theta,y=vec_y){
    
    suma=rep(0,length.out= nT)
    
    for ( i in 2:nT){
        
        suma[i] = ((y[i] - theta[1]-theta[2]*y[i-1])^2)/ (2*theta[3])
    }
    
    return(sum(suma))
}


log_lh <- function(theta,y=vec_y){
    
    a = (-1/2)*log(2*pi) 
    b = -(1/2)*log(theta[3]/(1-theta[2]^2))
    c = -((y[1]-(theta[1]/(1-theta[2])))^2)/((2*theta[3])/(1-theta[2]^2))
    d = -((nT-1)/2)*log(2*pi)-(((nT-1)/2)*log(theta[3])) - sumatoria(theta,y=vec_y)
    
    verosimilitud = a+b+c+d
    
    
    return(verosimilitud)}

simular_AR1 <- function(rho, y1, nT, epsilon){
    y=rep(NaN,1)
    
    y[1]=rnorm(1,mean=(1/0.6),sd=sqrt(0.5/0.84))
    
    for (t in 2:nT){
        y[t]=mu+rho*y[t-1]+epsilon[t]
    }
    return(y)
}



##LOOP#################

nSim=1000
mu=1
rho=0.4
sigma=0.5
resultados_mu=rep(NA,nSim)
resultados_rho=rep(NA,nSim)
resultados_sigma=rep(NA,nSim)

for (k in 1:nSim){
    
    #Parámetros
    nT=100
    theta = c(mu,rho,sigma)
    y1=0
    
    #Generando epsilon
    epsilon =rnorm(nT, mean = 0, sd =sqrt(sigma))
    
    
    #Simulando yt
    vec_y = simular_AR1(rho,y1,nT,epsilon)
    
    
    ##Optimizando la función
    v=c(0.5,0.5,0.5)
    
    resumen= optim(v,log_lh,control=list(fnscale=-1))
    
    resultados_mu[k]=resumen$par[1]
    resultados_rho[k]=resumen$par[2]
    resultados_sigma[k]=resumen$par[3]
    
    
    
}

x11();hist(resultados_mu,breaks=50,col="skyblue")
x11()
hist(resultados_rho,breaks=50,col="darkred")
x11()
hist(resultados_sigma,breaks=50,col="midnightblue")


####################################################################

#PARTE 2
#INCISO 1

graphics.off()
rm(list=ls())
set.seed(5) 

#Parámetros

mu=1
rho=0.4
sigma=0.5
nT=100
theta = c(mu,rho,sigma)
y1=0

epsilon =rnorm(nT, mean = 0, sd =sqrt(sigma))


#Simulando yt

simular_AR1 <- function(rho, y1, nT, epsilon){
    y=rep(NaN,1)
    
    y[1]=rnorm(1,mean=(1/0.6),sd=sqrt(0.5/0.84))
    
    for (t in 2:nT){
        y[t]=mu+rho*y[t-1]+epsilon[t]
    }
    return(y)
}


vec_y = simular_AR1(rho,y1,nT,epsilon)


#función de sumatoria

sumatoria <- function(theta,y){
    
    suma=rep(0,length.out= nT)
    
    for ( i in 2:nT){
        
        suma[i] = ((y[i] - theta[1]-theta[2]*y[i-1])^2)/ (2*theta[3])
    }
    
    return(sum(suma))
}

#función máxima verosimilitud

log_lh <- function(theta,y){
    
    a = (-1/2)*log(2*pi) 
    b = -(1/2)*log(theta[3]/(1-theta[2]^2))
    c = -((y[1]-(theta[1]/(1-theta[2])))^2)/((2*theta[3])/(1-theta[2]^2))
    d = -((nT-1)/2)*log(2*pi)-(((nT-1)/2)*log(theta[3])) - sumatoria(theta,y=vec_y)
    
    verosimilitud = a+b+c+d
    
    
    return(verosimilitud)}

#Parámetros

nT=100
theta = c(mu,rho,sigma)


#función de sumatoria

sumatoria <- function(theta,y=vec_y){
    suma=rep(0,length.out= nT)
    for ( i in 2:nT){
        suma[i] = ((y[i] - theta[1]-theta[2]*y[i-1])^2)/ (2*theta[3])
    }
    return(sum(suma))
}

#función máxima verosimilitud

log_lh <- function(theta){
    
    a = (-1/2)*log(2*pi) 
    b = -(1/2)*log(theta[3]/(1-theta[2]^2))
    c = -((vec_y[1]-(theta[1]/(1-theta[2])))^2)/((2*theta[3])/(1-theta[2]^2))
    d = -((nT-1)/2)*log(2*pi)-(((nT-1)/2)*log(theta[3])) - sumatoria(theta,y=vec_y)
    
    verosimilitud = a+b+c+d
    
    
    return(verosimilitud)}


##Errores estandar del estimador de máxima verosimilitud 


error_estandar <- function(v)

{J= optim(v,log_lh,control=list(fnscale=-1),hessian=TRUE)$hessian

J_1=J*(-1/nT)
J_1

sigma_gorro = sqrt(diag(solve(J_1)))

return(sigma_gorro)}

v=c(0.5,0.5,0.5)

error_estandar(v)

#####################################################


#INCISO 2

# Importar datos desde Archivo xls

graphics.off()
rm(list=ls())

library(readxl)
inflacion <- read_excel("inflacion.xlsx")

vec_y= inflacion$inflacion

vec_y

nT=length(vec_y)

nT

theta = c(mu,rho,sigma)

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
    
    
    return(verosimilitud)}

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
