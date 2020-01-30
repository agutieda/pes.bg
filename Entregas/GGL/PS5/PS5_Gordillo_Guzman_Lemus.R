#PS5 
#Modelos de Estado Espacio y Filtro de Kalman:
# Local-Level Model
#
# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala
#
#Marianna Guzman 
#Joaquin Sajbin 
#Luis Lemus Mackay 

################################################################################
################################################################################
# Filtro de Kalman: Ilustracion usando un modelo de media local
################################################################################
################################################################################

# En este archivo estudiaremos como utilizar el paquete dlmodeler para definir y
# estimar modelos de Estado-Espacio

# Limpiar el workspace
rm(list=ls(all=TRUE)) 

# Limpiar graficas
graphics.off()

# Fijar generador de numeros aleatorios
set.seed(1)

#install.packages("KFAS")
library(KFAS)
library(readxl)

Datos = read.csv("IPC_GASTO.CSV")
y_obs = Datos[,-1]#jalamos todos los datos menos la primera columna del archivo de excel

#y_obs
nT = nrow(y_obs) #Este es el numero de observaciones de cada componente
nT


Datos
#Inflación mensual 
#Estimamos nuestro Yt que es el calculo de la inflacion por cada componente del gasto
#Usamos la formula 100*(log(pt)-log(pt-1))
Inflacion = data.matrix(log(y_obs[2:nT,]/y_obs[1:(nT-1),])*100)
#Inflacion

componentes=length(y_obs)#Este es el numero de componentes del gasto
componentes

#Construimos el modelo
#Matriz vector de ceros del tamaño de los componentes mas 1
my_a1    = data.matrix(rep(0,componentes+1))        
#Matriz identidad tamaño 13x13
my_P1    = diag(componentes+1)
#Matriz identidad tamaño 13x13
my_P1inf = diag(componentes+1)

#Componentes para calcular la matriz T
identidad=diag(componentes)#Matriz identidad 12x12
ceros=rep(0,componentes)#Vector de ceros 12x1
unos=rep(1,componentes+1)#Vector de unos 13x1
ceros_identidad=rbind(identidad,ceros) #Matriz identidad 12x12 con una fila de ceros agregados


my_Tt    = cbind(ceros_identidad,unos) #Mi matriz T: le agrego a la matriz anterior una columna de unos

my_Rt    = diag(componentes+1)#Mi matriz R: matriz identidad 13x13
my_Zt    = cbind(identidad,ceros)#Matriz z: matriz identidad con una columna de ceros extra
my_Qt    = diag(NA,componentes+1)#Matriz Q, la que quiero calcular, lo lleno con NA 13x13
my_Ht    = diag(NA, componentes)#Matriz H, la que quiero calcular, lo lleno con NA 12x12


m_ipc = SSModel( Inflacion ~ -1 + SSMcustom( 
    a1    = my_a1,
    P1    = my_P1,
    P1inf = my_P1inf,
    T     = my_Tt,
    R     = my_Rt,
    Z     = my_Zt,
    Q     = my_Qt
),
H = my_Ht                        
)
m_ipc 
#  Tambien podemos revisar si el modelo es valido
is.SSModel(m_ipc)
#length(m_ipc)

# Ahora usamos el comando fitSSM para estimar el modelo
vec_inicial= exp(rnorm(2*componentes+1))#Generamos un vector inicial del tamaño de los parametros a estimar
m_ipc_estimado = fitSSM(m_ipc, inits=vec_inicial, method = "L-BFGS-B")#Estimamos MV de un modelo de espacio
m_ipc_estimado


# Veamos los parametros estimados
#Matriz de varianzas y covarianzas de la ecuacion del error de estimacion de pi
#sigma2_noise_hat =m_ipc_estimado$model$H 
#sigma2_noise_hat
#Matriz de varianzas y covarianzas de la estimacion del error de estimacion de alpha
#sigma2_signal_hat= m_ipc_estimado$model$Q
#sigma2_signal_hat


#Filtro Kalman modelo estimado 
KF_Results = KFS(m_ipc_estimado$model) #Le aplicamos el filtro Kalman
KF_Results

help(KFS)


#Datos filtrados y suavizados 
af_hat = KF_Results$att #datos filtrados
as_hat = KF_Results$alphahat #datos suavizados
af_hat
as_hat


# Y grafiquemos
x11();
matplot(Inflacion     , type="l" , col="black",lwd=1,lty=3)
#lines(af_hat[,13]  , type="l" , col="red"  ,lwd=3,lty=2)
lines(as_hat[,13]  , type="l" , col="blue" ,lwd=3,lty=1)

#Guardar la grafica en pdf
pdf("Grafica Filtro Kalman IPC Gasto Componente Comun.pdf")  
matplot(Inflacion     , type="l" , col="black",lwd=1,lty=3)
#lines(af_hat[,13]  , type="l" , col="red"  ,lwd=3,lty=2)
lines(as_hat[,13]  , type="l" , col="blue" ,lwd=3,lty=1)
dev.off()

x11();
matplot(Inflacion     , type="l" , col="black",lwd=1,lty=3)
#lines(af_hat[,12]  , type="l" , col="red"  ,lwd=3,lty=2)
lines(as_hat[,12]  , type="l" , col="blue" ,lwd=3,lty=1)

#Guardar la grafica en pdf
pdf("Grafica Filtro Kalman IPC Gasto Componente Otros.pdf")  
matplot(Inflacion     , type="l" , col="black",lwd=1,lty=3)
#lines(af_hat[,12]  , type="l" , col="red"  ,lwd=3,lty=2)
lines(as_hat[,12]  , type="l" , col="blue" ,lwd=3,lty=1)
dev.off()
