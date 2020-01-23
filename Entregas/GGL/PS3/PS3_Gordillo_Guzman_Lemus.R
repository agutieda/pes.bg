# Lista de ejercicios 3

#Programacion II
#Programa de Estudios Superiores
#Banco de Guatemala

#Integrantes:

#Marianna Guzman
#Joaquinn Gordillo Sajbin
#Luis Lemus Mackay

graphics.off(); rm(list=ls());
ls()

###############################################################################
#ESTIMACION DE UN AR(1) PARTE 1.
###############################################################################


# Nuestro proceso es:
# y(t) = mu + rho*y(t-1) + epsilon(t); epsilon(t)~N(0,sigma^2); y(0) dado.



###############################################################################
#INCISO A. Funcion Log Verosimilitud
###############################################################################
set.seed(5) #Es la semilla que genera los mismos valores aleatorios

#La función para que nos devuelva la log_verosimilitud

log_verosimilitud=function(theta) { #En la funcion se debe ingresar un vector theta

    sumatoria=0 #Definos un contador para la sumatoria dentro de la funcion logMV
    for (t in 2:nT){ #Acá estamos definiendo la sumatoria a partir del periodo 2
        sumatoria=sumatoria+((y[t]-theta[1]-theta[2]*y[t-1])^2)/(2*theta[3])
    }
    funcion=((-1/2)*log(2*pi))+((-1/2)*log(theta[3]/(1-theta[2]^(2))))-(((y[1]-(theta[1]/(1-theta[2])))^2)/((2*theta[3])/(1-theta[2]^2)))-
        ((nT-1)/2)*log(2*pi)-((nT-1)/2)*log(theta[3]) - sumatoria #Definimos la función logMV
    return(funcion)#Nos devuelve la función logMV
}


###############################################################################
#INCISO B. Simulacion proceso yt
###############################################################################

#Parametros
nT=100 # Numero de observaciones a simular
rho=0.4 # Persistencia del proceso
mu=1    # Constante del proceso
sigma_sq=0.5 # Varianza de los choques del proceso
theta=c(mu,rho,sigma_sq) #El vector de parámetros


#Simulacion
set.seed(5) #Es la semilla que genera los mismos valores aleatorios
epsilon=rnorm(nT,mean=0,sd=sqrt(theta[3])) #Simulamos epsilon

#Funcion simular AR(1)

##Acá defino una función para simular mi Yt
simular_AR1=function(mu,rho,y0_sim,nT_sim,sigma_sq_sim,epsilon_sim){
    
    y=rep(NaN,1)
    y[1]=rnorm(1,mean=(mu/(1-rho)),sd=sqrt(sigma_sq_sim/(1-rho^2)))
    
    for (t in 2:nT){
        y[t]=mu+rho*y[t-1]+epsilon_sim[t]
    }
    return(y)
}

#Simulo mi Yt con los mismos valores mu, rho, y0, nT, epsilon
y0 = rnorm(1,mean=(mu/(1-rho)),sd=sqrt(sigma_sq/(1-rho^2)))
y=simular_AR1(mu=theta[1],rho=theta[2],y0_sim=y0,nT_sim=nT,epsilon_sim=epsilon,sigma_sq_sim=sigma_sq)

log_verosimilitud(theta) #Le aplicamos a la función el vector theta

#x11(); plot(epsilon, type="l") #Graficamos las simulaciones de los choques estocasticos

###############################################################################
#INCISO C. Estimación estimador de máxima verosimilitud
###############################################################################


#Optimización
set.seed(5)

theta_0=c(0.5,0.5,0.5) #Defino mi vector de valores iniciales
max_verosimilitud=optim(theta_0,log_verosimilitud,control=list(fnscale=-1)) 
#Le pedimos que la optimice dado ese vector inicial, pero a una escala de -1 para que maximice.
max_verosimilitud

#Definimos el nuevo vector theta óptimo
theta_optim=c(max_verosimilitud$par[1],max_verosimilitud$par[2],max_verosimilitud$par[3])

#Evaluamos en logMV el theta optimo para verificar que nos de el valor máximo
log_verosimilitud(theta_optim)


###############################################################################
#INCISO D. Histograma de frecuencias de distribución del estimador
###############################################################################

nSim=1000 #Definimos el numero de simulaciones

#Definimos una matriz llena de NaNs, del tamaño de las simulaciones
#Definimos las filas como nSim y las columnas con el numero de parametros, que es 3.
vector_theta=matrix(NaN,nSim,nrow=nSim,ncol=3)

#Creamos el loop
 for(i in 1:nSim){
     nT=100 # Numero de observaciones a simular
     rho=0.4 # Persistencia del proceso
     mu=1    # Constante del proceso
     sigma_sq=0.5 # Varianza de los choques del proceso
     theta=c(mu,rho,sigma_sq) #El vector de parametros
     theta_0=c(0.5,0.5,0.5) #El vector inicial para maximizar
     epsilon=rnorm(nT,mean=0,sd=sqrt(theta[3])) #Simulamos epsilon
     y=simular_AR1(mu=theta[1],rho=theta[2],y0_sim=y0,nT_sim=nT,epsilon_sim=epsilon,sigma_sq_sim=sigma_sq) #simulamos y
     
     #Que maximice la función dado el tetha inicial.
     max_verosimilitud=optim(theta_0,log_verosimilitud,control=list(fnscale=-1))
     
     #En el vector de parámetros almacena en cada fila, los 3 parámetros hasta nSim
     vector_theta[i,]=max_verosimilitud$par
    
}

vector_theta #Nos regresa la matriz con los parámetros simulados.

#Definimos las variables simuladas, es decir, con base a las filas.
mu_simulacion=vector_theta[,1]
rho_simulacion=vector_theta[,2]
sigmasq_simulacion=vector_theta[,3]


#Graficamos los histogramas de cada parámetro de simulación.
x11(); hist(mu_simulacion, col="#00aebc")
x11();hist(rho_simulacion, col="#f39200")
x11();hist(sigmasq_simulacion, col="darkred")



###############################################################################
#ESTIMACION DE UN AR(1) PARTE 2.
###############################################################################



###############################################################################
#INCISO A. Funcion que calcule errores estandar del estimador MV
###############################################################################


set.seed(5) #Es la semilla que genera los mismos valores aleatorios
epsilon=rnorm(nT,mean=0,sd=sqrt(theta[3])) #Simulamos epsilon
y=simular_AR1(mu=theta[1],rho=theta[2],y0_sim=y0,nT_sim=nT,epsilon_sim=epsilon,sigma_sq_sim=sigma_sq)
nT=100

errores_estandar=function(theta_0) {
    #max_verosimilitud=optim(theta_0,log_verosimilitud,control=list(fnscale=-1))
    
    #set.seed(5) #Es la semilla que genera los mismos valores aleatorios
    #epsilon=rnorm(nT,mean=0,sd=sqrt(theta[3])) #Simulamos epsilon
    #y=simular_AR1(mu=theta[1],rho=theta[2],y0=0,nT_sim=nT,epsilon_sim=epsilon)
    #nT=100
    
    resultados =optim(theta_0,log_verosimilitud,control=list(fnscale=-1),hessian = TRUE) 
    h=resultados$hessian
    
    j=h*(-1/nT)
    
    inv_j=solve(j)
    
    diagonal_j=diag(inv_j)

    errorest=sqrt(diagonal_j)
    return(errorest)
}


theta_0=c(0.5,0.5,0.5)

errores_estandar(theta_0)


###############################################################################
#INCISO B. Encontrar estimador de máxima verosimilitud y errores estándar
#          Hoja de excel: Inflación Mensual
###############################################################################

#Cambiamos el working directory
setwd("C:/Users/IN_CAP02/Desktop/P2/Miércoles 22/PS3")

#Cargamos la libreria
#install.packages("readxl")
library(readxl)

#Cargamos todos los datos de inflacion de la hoja de excel
datos_desde = read_excel("inflacion.xlsx")
datos_desde

#Definimos la inflacion como la matriz de los datos del doc de excel (la columna 2)
inflacion=as.matrix(datos_desde[2])
inflacion

#Mi nuevo numero de observaciones es la longitud de mi vector de inflación
nT = length(inflacion)

#Ahora mi nueva y es mi inflacion
y = inflacion

#Defino mi theta inicial
theta_0=c(0.25,0.8,0.5)


#Le pido que me optimice mi log verosimilitud para que me de los parametros
max_vero_inf=optim(theta_0,log_verosimilitud,control=list(fnscale=-1)) 
max_vero_inf

#Mis parámetros estimados de la inflacion
theta_inflacion=max_vero_inf$par
theta_inflacion

#Me devuelve mis errores estandar de cada parametro
errores_estandar(theta_0)    




