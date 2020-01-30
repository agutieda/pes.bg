################################################################################
#                           PRACTICA 4                                         #
################################################################################

############################ INCISO 1 ##########################################

################################################################################
# Local-Level Model: Representacion de Estado-Espacio
################################################################################

rm(list=ls(all=TRUE)) 
graphics.off()

set.seed(1)

#install.packages("KFAS")
library(KFAS)

library(readr)
IPC_GASTO <- read_csv("C:/Users/in_cap02/Desktop/PS5/IPC_GASTO.csv")
datos = IPC_GASTO[,-1]
nObs = nrow(datos)

matrizIPC = data.matrix(log(datos[2:nObs,]/datos[1:(nObs-1),])*100)
matrizIPC
nSeries = ncol(matrizIPC)


my_a1    <- matrix(c(0),nSeries+1,1)
my_P1    <- diag(rep(1,nSeries+1))
my_P1inf <- diag(rep(1,nSeries+1))
my_Tt    <- cbind(rbind(diag(nSeries),rep(0,nSeries)),rep(1,nSeries+1))
my_Rt    <- diag(nSeries+1)
my_Zt    <- cbind(diag(nSeries),rep(0,nSeries))
my_Qt    <- diag(rep(NA,nSeries+1))
my_HT    <- diag(rep(NA,nSeries))



IPC_MODEL <- SSModel( matrizIPC ~ -1 + SSMcustom(
    a1    = my_a1,
    P1    = my_P1,
    P1inf = my_P1inf,
    T     = my_Tt,
    R     = my_Rt,
    Z     = my_Zt,
    Q     = my_Qt
),
H = my_HT
)

IPC_MODEL

is.SSModel(IPC_MODEL) # Revisando si el modelo es valido

############################ INCISO 2 ##########################################

################################################################################
# Estimación de los parametros del modelo 
################################################################################

# Se determina un valor inicial para el método de estimacion
valor_inicial = exp(rnorm(2*nSeries+1))


# Se realiza la estimación del modelo 
ipc_estimado =  fitSSM(IPC_MODEL, inits = valor_inicial, method = "L-BFGS-B")

############################ INCISO 3 ##########################################

################################################################################
# Suavizador de Kalman 
################################################################################

# Llamemos el filtro
KF_Results <- KFS(ipc_estimado$model)

# Recuperemos los datos filtrados y suavizados

af_hat <- KF_Results$att  # Recuperemos el filtro contemporaneo: E[alpha(t)|Y(t)]
as_hat <- KF_Results$alphahat # Recuperamos los valores suavizados E[a(t)|Y(T)]

com_trend = as_hat[,12]

length(matrizIPC)

pdf("Inflación_1.pdf")
matplot(matrizIPC, type = "l", col = "purple", lwd = 1, lty =1)
lines(com_trend, type = "l", col="pink", lwd=5, lty=1)
dev.off()

x11(title = "Inflación");
matplot(matrizIPC, type = "l", col = "purple", lwd = 1, lty =1)
lines(com_trend, type = "l", col="pink", lwd=5, lty=1)

