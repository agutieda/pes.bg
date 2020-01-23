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
    
    y[1] = rnorm(1, mean=1, sd=sqrt(0.5))
    
    for (t in 2:nT){
        y[t]=mu+rho*y[t-1]+epsilon[t]
    }
    return(y)
}


vec_y = simular_AR1(rho,y1,nT,epsilon)


#función de sumatoria

sumatoria <- function(theta,y=y_simul){
    
    suma=rep(0,length.out= nT)
    
    for ( i in 2:nT){
        
        suma[i] = ((y[i] - theta[1]-theta[2]*y[i-1])^2)/ (2*theta[3])
    }
    
    return(sum(suma))
}

#función máxima verosimilitud

log_lh <- function(theta,y=y_simul){
    
    a = (-1/2)*log(2*pi) 
    b = -(1/2)*log(theta[3]/(1-theta[2]^2))
    c = -((y[1]-(theta[1]/(1-theta[2])))^2)/((2*theta[3])/(1-theta[2]^2))
    d = -((nT-1)/2)*log(2*pi)-(((nT-1)/2)*log(theta[3])) - sumatoria(theta,y=y_simul)
    
    verosimilitud = a+b+c+d
    
    
    return(verosimilitud)
    }

simular_AR1loop <- function(theta,  epsilon){
    y=rep(NaN,1)
    
    y[1]= rnorm(1,mean = theta[1], sd = sqrt(theta[3]))
    epsilon_shuffle = sample(epsilon,replace=FALSE)
    
    for (t in 2:nT){
        y[t]=theta[1]+theta[2]*y[t-1]+epsilon_shuffle[t]
    }
    return(y)
}


nSim=1000
resultados_mu=rep(NA,nSim)
resultados_rho=rep(NA,nSim)
resultados_sigma=rep(NA,nSim)

for (k in 1:nSim){
    
    #Simulando yt
    y_simul = simular_AR1loop(theta, epsilon)
    
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

sqrt(var(resultados_mu))
sqrt(var(resultados_rho))
sqrt(var(resultados_sigma))