# Jose Domingo de Leon
# Diego Ignacio Sanchez
# Hugo Leonel Orellana


# Limpiar el workspace
rm(list=ls(all=TRUE)) 

# Limpiar graficas
graphics.off()

# Fijar generador de numeros aleatorios
set.seed(1)

#install.packages("KFAS")
library(KFAS)

#################################################
###     Representacion de Estado-Espacio    #####
################################################

Datos <- read.csv("IPC_GASTO.csv")

# Obteniendo cada una de las series del IPC
y_obs_ali <- Datos$ï..date
y_obs_ali <- Datos$alimentos
y_obs_alc <- Datos$alcohol
y_obs_rop <- Datos$ropa
y_obs_viv <- Datos$vivienda
y_obs_mue <- Datos$muebles
y_obs_sal <- Datos$salud
y_obs_tra <- Datos$transporte
y_obs_com <- Datos$comunicaciones
y_obs_rec <- Datos$recreacion
y_obs_edu <- Datos$educacion
y_obs_res <- Datos$restaurantes
y_obs_otr <- Datos$otros

nObs <- length(Datos$ï..date)
nEst = ncol(Datos)-1     # Al total de las columnas se le resta la columna de fechas, para tener el # de estados

## Construimos la inflacion mensual para cada serie

yt_ali <- (y_obs_ali[2:nObs]/y_obs_ali[1:(nObs-1)]-1)*100
yt_alc <- (y_obs_alc[2:nObs]/y_obs_alc[1:(nObs-1)]-1)*100
yt_rop <- (y_obs_rop[2:nObs]/y_obs_rop[1:(nObs-1)]-1)*100
yt_viv <- (y_obs_viv[2:nObs]/y_obs_viv[1:(nObs-1)]-1)*100
yt_mue <- (y_obs_mue[2:nObs]/y_obs_mue[1:(nObs-1)]-1)*100
yt_sal <- (y_obs_sal[2:nObs]/y_obs_sal[1:(nObs-1)]-1)*100
yt_tra <- (y_obs_tra[2:nObs]/y_obs_tra[1:(nObs-1)]-1)*100
yt_com <- (y_obs_com[2:nObs]/y_obs_com[1:(nObs-1)]-1)*100
yt_rec <- (y_obs_rec[2:nObs]/y_obs_rec[1:(nObs-1)]-1)*100
yt_edu <- (y_obs_edu[2:nObs]/y_obs_edu[1:(nObs-1)]-1)*100
yt_res <- (y_obs_res[2:nObs]/y_obs_res[1:(nObs-1)]-1)*100
yt_otr <- (y_obs_otr[2:nObs]/y_obs_otr[1:(nObs-1)]-1)*100

# construyendo la matrix de las inflaciones de cada grupo de gasto

mat=cbind(yt_ali, yt_alc,yt_rop, yt_viv,yt_mue,yt_sal,yt_tra,yt_com,yt_rec,yt_edu,yt_res,yt_otr)

my_a1 <- matrix(0,nrow=nEst+1, ncol=1)  # inicialmente se considero 12, pero se debe agregar el componente no observado como un estado adicional
my_P1 <- diag(nEst+1)
my_P1inf <- diag(nEst+1)
######
myT <- rbind(diag(nEst),rep(0,12))  # Agregar un vector fila adicional para que la matriz sea cuadrada de dim 13x13
######
my_Tt <- cbind(myT,rep(1,13))   # Se debe agregar un vector columna por el componenten adicional no observado presente en cada serie de inflacion
my_Rt <- diag(nEst+1)        
my_Zt <- cbind(diag(nEst),rep(0,12))
my_Qt <- diag(rep(NA,nEst+1))   # Note los NA usados para epecificar
my_Ht <- diag(NA,nEst)  # que hay que estimar estos parametros

# Definamos el Modelo
modelo <- SSModel( mat ~ -1 + SSMcustom( 
    a1    = my_a1,
    P1    = my_P1,
    P1inf = my_P1inf,
    T     = my_Tt,
    R     = my_Rt,
    Z     = my_Zt,
    Q     = my_Qt
),
H     = my_Ht                        
)

#  Analisis del modelo
modelo

#  Revisando validez del modelo
is.SSModel(modelo)

# Ahora usamos el comando fitSSM para estimar el modelo
infl_est <- fitSSM(modelo, inits = c(runif(25,min=0, max=1)), method = "BFGS")

# Veamos los parametros estimados
exp(infl_est$optim.out$par)
sigma2_noise_hat = infl_est$model$H
sigma2_signal_hat = infl_est$model$Q
#signal2noise = sigma2_signal_hat/sigma2_noise_hat      
#signal2noise

#No coincide las dimensiones de sigma2_signal_hat y sigma2_noise_hat
dim(sigma2_signal_hat)
dim(sigma2_noise_hat)

# Usando el filtro de Kalman sobre los datos con el modelo estimado
KF_Results <- KFS(infl_est$model)

# Recuperando los datos filtrados y suavizados
af_hat <- KF_Results$att 
as_hat <- KF_Results$alphahat

# Grafica para comparar valor simulado vs el recuperado pronosticado
# por el filtro y el suavizador

xAxis <- seq(1,nObs-1)
x11(); matplot(xAxis, mat[xAxis,1:12], main ="infl mensual observado vs filtrado vs suavizado", type="l", xlab="Observaciones", col="gray1",lwd=1,lty=2, ylim=c(-5,7));
lines(xAxis , af_hat[xAxis,13]  , type="l" , col="red"  ,lwd=3,lty=1);
lines(xAxis , as_hat[xAxis,13]  , type="l" , col="blue" ,lwd=2,lty=1)

# Guardar como .pdf
pdf("Graficas Estado Espacio.pdf") 
matplot(xAxis, mat[xAxis,1:12], main ="infl mensual observado vs filtrado vs suavizado", type="l", xlab="Observaciones", col="gray1",lwd=1,lty=2, ylim=c(-5,7));
lines(xAxis , af_hat[xAxis,13]  , type="l" , col="red"  ,lwd=3,lty=1);
lines(xAxis , as_hat[xAxis,13]  , type="l" , col="blue" ,lwd=2,lty=1)
dev.off()
