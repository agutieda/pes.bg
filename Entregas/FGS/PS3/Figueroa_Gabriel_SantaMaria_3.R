# TAREA 3
# Integrantes:
# Polo Figueroa
# David Gabriel
# Pablo Santa Maria

graphics.off()
rm(list=ls())
library(numDeriv)
library(tseries)
library(forecast)
#parametros
mu = 1
rho = 0.4
sigma2 = 0.5

theta0 = c(mu,rho,sigma2)
pi = 3.141592653   


# PARTE 1 --------------------------------------------------------------------
# Problema 1 -----------------------------------------------------------------
# funciones AR(1) y  Log_L

simualar_AR1 = function(mu_sim,rho_sim,y0_sim,nT_sim,epsilon_sim){
    y = rep(NaN,1)
    y[1]= y0_sim
    for (t in 2:nT_sim){
        y[t]= mu_sim+rho_sim*y[t-1]+epsilon_sim[t]
    }
    return(y)
}

Log_L = function(theta){
    suma = 0
    for (t in 2:nT){
        suma = suma + (y[t]- theta[1] - theta[2]*y[t-1])^2/(2*theta[3])
    }
    
    termino1 = 0.5*log(2*pi)
    termino2 = 0.5*log((theta[3]/(1-theta[2]*theta[2])))
    termino3 = (y[1]-(theta[1]/(1-theta[2])))^2/((2*theta[3])/(1-(theta[2])^2))
    termino4 = ((nT-1)/2)*log(2*pi)
    termino5 = ((nT-1)/2)*log(theta[3])
    
    log_l = -termino1 -termino2 -termino3 -termino4 -termino5 -suma 

    return(log_l)
}

#Problema 2---------------------------------------------------------
#valores iniciales
nT = 100
set.seed(5)
y0=rnorm(1,mean=theta0[1]/(1-theta0[2]),sd=sqrt(theta0[3]/(1-(theta0[2])^2)))
epsilon = rnorm(nT,mean=0,sd=sqrt(theta0[3]))
y =simualar_AR1(theta0[1],theta0[2],y0,nT,epsilon)



#Problema 3 --------------------------------------------------------
#definimos una funcion auxiliar para la optimizacion
nT = 100
set.seed(5)
y0=rnorm(1,mean=theta0[1]/(1-theta0[2]),sd=sqrt(theta0[3]/(1-(theta0[2])^2)))
epsilon = rnorm(nT,mean=0,sd=sqrt(theta0[3]))
y =simualar_AR1(theta0[1],theta0[2],y0,nT,epsilon)
p0 = c(0.5,0.5,0.5)
OPTIMO = optim(P0, Log_L, control=list(fnscale=-1),hessian=TRUE)
OPTIMO

#Problema 4 ----------------------------------------------------------

MU = c()
RHO = c()
SIGMA2 = c()
HESSIAN = matrix(c(0,0,0,0,0,0,0,0,0),ncol=3,nrow = 3)

for (i in 1:1000){
    epsilon = rnorm(nT,mean=0,sd=sqrt(theta0[3]))
    nT = 100
    P0 = c(0.5,0.5,0.5)
    y0=rnorm(1,mean=theta0[1]/(1-theta0[2]),sd=sqrt(theta0[3]/(1-(theta0[2])^2)))
    y =simualar_AR1(theta0[1],theta0[2],y0,nT,epsilon)
    OPTIMO = optim(P0, Log_L, control=list(fnscale=-1),hessian=TRUE)
    Estimador = OPTIMO$par
    MU = c(MU,Estimador[1]) 
    RHO = c(RHO,Estimador[2])
    SIGMA2 = c(SIGMA2,Estimador[3])
    HESSIAN = HESSIAN + OPTIMO$hessian/1000
}
hist(MU,breaks=100, col = 'red')
hist(RHO, breaks=100, col = 'red')
hist(SIGMA2, breaks =100, col = 'red')
mean(MU); sqrt(var(MU))
mean(RHO); sqrt(var(RHO))
mean(SIGMA2);sqrt(var(SIGMA2))
##### PARTE 2 -----------------------------------------------------------------

#Problema 1
errores = function(p0){
    OPTIMO = optim(p0,Log_L,control=list(fnscale=-1),hessian=TRUE)
    hessiana = OPTIMO$hessian
    Q = -hessiana/nT
    P = solve(Q)
    return(sqrt(diag(P)))
}

set.seed(5)
epsilon = rnorm(nT,mean=0,sd=sqrt(theta0[3]))
y0=rnorm(1,mean=theta0[1]/(1-theta0[2]),sd=sqrt(theta0[3]/(1-(theta0[2])^2)))
nT = 100
p0 = c(0.5,0.5,0.5)
y =simualar_AR1(theta0[1],theta0[2],y0,nT,epsilon)
errores(P0)

# Problema 2
library(readxl)
inflacion <- read_excel("inflacion.xlsx")
nT = length(inflacion$inflacion)
p0 = c(0.25,0.8,0.6)
y0 = inflacion$inflacion[1]
y = inflacion$inflacion


optim(p0,Log_L,control=list(fnscale=-1),hessian=TRUE)$par
errores(p0)

