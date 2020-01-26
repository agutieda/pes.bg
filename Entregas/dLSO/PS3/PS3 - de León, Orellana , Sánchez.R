### Jose Domingo de Leon Miranda
### Hugo Leonel Orellana Alfaro
### Diego Ignacio Sanchez del Cid  



################################################################
#### Estimacion de un AR(1), Parte I
################################################################

graphics.off(); rm(list=ls());

# Fijemos la semilla del generador de numeros aleatorios
set.seed(5) # Esto permite que todos veamos las mismas graficas

# Nuestro proceso es:
# y(t) = mu + rho*y(t-1) + epsilon(t); epsilon(t)~N(0,sigma^2); y(1)~N(mu/(1-rho),sigma^2/(1-rho^2))

# Definir Parametros del modelo AR(1)
nT     <- 100         # Numero de observaciones a simular
mu    <- 1       # Constante del proceso
rho   <- 0.4        # Persistencia del proceso
sigma2 <- 0.5        # Desv. Est. de los choques del proceso
y0    <- 0          # Valor inicial del proceso      

# Procesos Exogenos modelo AR(1)
set.seed(5)
epsilon <- rnorm(nT, mean = 0, sd = sqrt(sigma2))
y1 = 0

# FUNCION que simule el proceso AR(1)
ar1_sim <- function(rho_sim,mu_sim,sigma_sim,y0_sim,nT_sim,epsilon_sim){         #Función que simula el proceso AR1 para cualquier valor de parámetros y choques dados 
    y = rep(NaN,1)
    y[1] <- y0_sim
    
    for(t in 2:nT_sim){
        y[t]=mu_sim+rho_sim*y[t-1]+epsilon_sim[t]  
    }
    return(y)
}
# Llamando la función
y_sim = ar1_sim(mu_sim=mu, sigma_sim=sqrt(sigma2), y0_sim=y0, nT_sim=nT, epsilon_sim=epsilon, rho_sim=rho)
y_sim


# Definiendo la funcion likelihood con los valores iniciales

ValoresInic=c(mu,rho,sigma2)

mlike<-function(theta){
    y = y_sim
    suma =rep(0,100)
    
    for (t in 2:nT){
        suma[t] = ((y[t] - theta[1] - theta[2]*y[t-1])^2/(2*theta[3]))
    }
    logl <- ((-(1/2)*(log(2*pi)))
             -((1/2)*(log(theta[3]/(1-theta[2]^2))))
             -(((y1-(theta[1]/(1-theta[2])))^2)/((2*theta[3])/(1-theta[2]^2)))
             -(((nT-1)/2)*log(2*pi))
             -(((nT-1)/2)*log(theta[3]))-sum(suma))
    return(logl)
}

L = mlike(ValoresInic)
L   

#########################
# Optimizacion numerica #
#########################

theta2 = c(0.5,0.5,0.5)

opt = optim(theta2, mlike, control=list(fnscale=-1))
opt

###############
# Histogramas #
###############

iteraciones = 1000
parametros = matrix(NA,nrow=iteraciones, ncol=3)      #Creación de matriz con el no. de filas y 3 columnas, una por cada parámetro
for (i in 1:iteraciones){
    y_sim = ar1_sim(mu_sim=mu, sigma_sim=sqrt(sigma2), y0_sim=y0, nT_sim=nT, epsilon_sim=epsilon, rho_sim=rho)
    epsilon <- rnorm(nT, mean = 0, sd = sqrt(sigma2))
    parametros[i,]=optim(theta2, mlike, control=list(fnscale=-1))$par
}
parametros

#Para mu
x11(); hist(parametros[,1], breaks=30, col="blue", main="Parametros Mu")

#Para rho
x11(); hist(parametros[,2], breaks=30, col="red", main="Parametros Rho")

#Para sigma2
x11(); hist(parametros[,3], breaks=30, col="darkgreen", main="Parametros Sigma2")

################################################################
#### Estimacion de un AR(1), Parte II
################################################################

graphics.off(); rm(list=ls());

set.seed(5) # Esto permite que todos veamos las mismas graficas

# Nuestro proceso es:
# y(t) = mu + rho*y(t-1) + epsilon(t); epsilon(t)~N(0,sigma^2); y(1)~N(mu/(1-rho),sigma^2/(1-rho^2))

# Definir Parametros del modelo AR(1)
nT     <- 100         # Numero de observaciones a simular
mu    <- 1       # Constante del proceso
rho   <- 0.4        # Persistencia del proceso
sigma2 <- 0.5        # Desv. Est. de los choques del proceso
y0    <- 0          # Valor inicial del proceso      

# Procesos Exogenos modelo AR(1)
set.seed(5)
epsilon <- rnorm(nT, mean = 0, sd = sqrt(sigma2))
y1 = 0

# FUNCION que simule el proceso AR(1)
ar1_sim <- function(rho_sim,mu_sim,sigma_sim,y0_sim,nT_sim,epsilon_sim){         #Función que simula el proceso AR1 para cualquier valor de parámetros y choques dados 
    y = rep(NaN,1)
    y[1] <- y0_sim
    
    for(t in 2:nT_sim){
        y[t]=mu_sim+rho_sim*y[t-1]+epsilon_sim[t]  
    }
    return(y)
}
# Llamando la función
y_sim = ar1_sim(mu_sim=mu, sigma_sim=sqrt(sigma2), y0_sim=y0, nT_sim=nT, epsilon_sim=epsilon, rho_sim=rho)
y_sim

ValoresInic=c(mu,rho,sigma2)

mlike<-function(theta){
    y = y_sim
    suma =rep(0,100)
    
    for (t in 2:nT){
        suma[t] = ((y[t] - theta[1] - theta[2]*y[t-1])^2/(2*theta[3]))
    }
    logl <- ((-(1/2)*(log(2*pi)))
             -((1/2)*(log(theta[3]/(1-theta[2]^2))))
             -(((y1-(theta[1]/(1-theta[2])))^2)/((2*theta[3])/(1-theta[2]^2)))
             -(((nT-1)/2)*log(2*pi))
             -(((nT-1)/2)*log(theta[3]))-sum(suma))
    return(logl)
}

L = mlike(ValoresInic)
L   

#########################
# Optimizacion numerica #
#########################

theta2 = c(0.5,0.5,0.5)

opt = optim(theta2, mlike, control=list(fnscale=-1))
opt

##############################################
####   Errores estandar del estimador    #####
##############################################

set.seed(5)
opt = optim(theta2, mlike, control=list(fnscale=-1), hessian=TRUE) #se genera la hessiana
opt

hessian= opt$hessian  # se obtienen los datos de la hessiana
hessian

Jacob = (-1/nT)*hessian   # se obtiene los datos de la Jacobiana
Jacob
    
inv_Jacob=solve(Jacob)     # se obtiene la inversa de la Jacobiana
inv_Jacob    

Diagonal=diag(inv_Jacob)    # se obtiene la diagonal de la inversa de la Jacobiana
Diagonal

std_errors=sqrt(Diagonal)   # se obtienen los errores estandares a partir de la digonal de la Jacobiana
std_errors


###############################################################
####  Estimador de Max verosimilitud y errores estandares  ####
###############################################################

graphics.off(); rm(list=ls());

setwd("C:\\Users\\in_cap02\\Desktop\\PS3")

# Instalemos la libreria "readxl" 
install.packages("readxl")
library(readxl)

# Archivo xlsx
datos.desde.xlsx <- read_excel("inflacion.xlsx",sheet="Main") 
datos.desde.xlsx


attach(datos.desde.xlsx)
inflation <- matrix(c(inflacion))  # se crea una nueva variable de inflacion que contiene la info del documento
inflation

ndatos = length(inflacion)

ValoresInic=c(0.5,0.5,0.5)


fverosimil<-function(z){
    w1=0
    w = inflacion
    suma =rep(0,ndatos)
    
    for (t in 2:ndatos){
        suma[t] = ((w[t] - z[1] - z[2]*w[t-1])^2/(2*z[3]))
    }
    logl <- ((-(1/2)*(log(2*pi)))
             -((1/2)*(log(z[3]/(1-z[2]^2))))
             -(((w1-(z[1]/(1-z[2])))^2)/((2*z[3])/(1-z[2]^2)))
             -(((ndatos-1)/2)*log(2*pi))
             -(((ndatos-1)/2)*log(z[3]))-sum(suma))
    return(logl)
}

L = fverosimil(ValoresInic)
L   


valores_optimos = optim(ValoresInic, fverosimil, control=list(fnscale=-1),hessian = TRUE)
valores_optimos

hesiana= valores_optimos$hessian  # se obtienen los datos de la hessiana
hesiana

Jacobi = (-1/ndatos)*hesiana   # se obtiene los datos de la Jacobiana
Jacobi

inv_Jacobi=solve(Jacobi)     # se obtiene la inversa de la Jacobiana
inv_Jacobi    

Diago=diag(inv_Jacobi)    # se obtiene la diagonal de la inversa de la Jacobiana
Diago

stnd_errors=sqrt(Diago)   # se obtienen los errores estandares a partir de la digonal de la Jacobiana
stnd_errors

###############################################################
####                BOOTSTRAPING                           ####
###############################################################
infl=inflation

vec_eps=rep(NaN,ndatos) #Creamos el vector de epsilons
serie_tiempo=rep(NaN,ndatos) #Creamos el vector que tiene la serie de tiempo con los choques simulados
num_sim
ValoresIni=c(0.5,0.5,0.5)


set.seed(5) #Generamos valores aleatorios
for (i in 1:ndatos){ #Ciclo que llena el vector de epsilon
    Epsilon <- rnorm(ndatos, mean = 0, sd = 1)
    vec_eps[i]=Epsilon
}
vec_eps

for (j in 1:num_sim){
    for (i in 1:ndatos){ #Vector que me llena la serie de tiempo.
        serie_tiempo[i]=infl[i]+vec_eps[i] 
    } 
    mvero<-function(theta){
        suma =rep(0,100)
        prueba=inflation
        y1=0
        
        for (t in 2:ndatos){
            suma[t] = ((prueba[t] - theta[1] - theta[2]*prueba[t-1])^2/(2*theta[3]))
        }
        logl <- ((-(1/2)*(log(2*pi)))
                 -((1/2)*(log(abs(theta[3]/(1-theta[2]^2)))))
                 -(((y1-(theta[1]/(1-theta[2])))^2)/((2*theta[3])/(1-theta[2]^2)))
                 -(((ndatos-1)/2)*log(2*pi))
                 -(((ndatos-1)/2)*log(theta[3]))-sum(suma))
        return(logl)
    }
    valores_optimos = optim(ValoresIni, mvero, control=list(fnscale=-1),hessian=TRUE)
    vec_eps=sample(vec_eps)
    
    hesiana= valores_optimos$hessian  # se obtienen los datos de la hessiana
    hesiana
    
    Jacobi = (-1/ndatos)*hesiana   # se obtiene los datos de la Jacobiana
    Jacobi
    
    inv_Jacobi=solve(Jacobi)     # se obtiene la inversa de la Jacobiana
    inv_Jacobi    
    
    Diago=diag(inv_Jacobi)    # se obtiene la diagonal de la inversa de la Jacobiana
    Diago
    
    stnd_errors=sqrt(Diago)   # se obtienen los errores estandares a partir de la digonal de la Jacobiana
    stnd_errors
}

stnd_errors
