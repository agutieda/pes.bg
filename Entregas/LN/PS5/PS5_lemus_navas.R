# Lista de Ejercicios 5

# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala

# Integrantes:
#   Elmer Humberto Lémus Flores
#   Erwin Roberto Navas Solis

################################################################################
#       1. Escriba la representación Estado-Espacio de este modelo.            #
################################################################################

library(KFAS)

# Limpiamos la consola
graphics.off(); rm(list=ls()); shell("cls")

# Extraemos los datos
Datos = read.csv("IPC_GASTO.csv")
y_datos = Datos[,2:13]
y_obs = matrix(unlist(y_datos), nrow = 105, ncol = 12)

# Gráficas
plot(y_obs[,1],type="o")
nObs = length(y_obs[,1])
nVar = length(y_obs[1,])

# Construimos la inflacion mensual
yt_mat = matrix(0, nrow = 104, ncol = 12)
for (i in 1:nVar){
  yt_mat[,i] = (y_obs[2:nObs,i]/y_obs[1:(nObs-1),i]-1)*100  
}

# La inflación es:
xAxis <- seq(1,length(yt_mat[,1]))
x11(); matplot(xAxis, yt_mat[xAxis,1:12], type="l" , col="black",lwd=1,lty=3)

# Construimos el modelo
my_a1       = matrix(c(0),nVar+1,1)
my_P1       = diag(nVar+1)
my_P1inf    = diag(nVar+1)
my_Tt       = diag(nVar+1)
my_Tt[,nVar+1]=1
my_Rt       = diag(nVar+1)
my_Zt       = cbind(diag(nVar),0)
my_Qt       = diag(NA,nVar+1)+diag(nVar+1)
my_Ht       = diag(NA,nVar)+diag(nVar)

# Modelo
m_ipc <- SSModel( yt_mat ~ -1 + SSMcustom( 
  a1    = my_a1,
  P1    = my_P1,
  P1inf = my_P1inf,
  T     = my_Tt,
  R     = my_Rt,
  Z     = my_Zt,
  Q     = my_Qt
),
H       = my_Ht                        
)

# Verificación
m_ipc
set.seed(1)

# Ahora usamos el comando fitSSM para estimar el modelo
m_ipc_estimado <- fitSSM(m_ipc, inits = abs(rnorm(25)), method = "BFGS")

# Veamos los parametros estimados
exp(m_ipc_estimado$optim.out$par)
sigma2_noise_hat = m_ipc_estimado$model$H
sigma2_signal_hat = m_ipc_estimado$model$Q
#signal2noise = sigma2_signal_hat/sigma2_noise_hat
#signal2noise

################################################################################
#  2. Estime los parámetros del modelo utilizando los datos proporcionados.    #
################################################################################

# Usemos el filtor de Kalman sobre los datos con el modelo estimado
KF_Results <- KFS(m_ipc_estimado$model)
KF_Results

################################################################################
#  3. Utilice el Suavizador de Kalman para estimar el componente común t       #
#  dados los datos. Muéstrelo en una misma gráfica junto a las series de       #
#  inflación utilizadas.                                                       #
################################################################################

# Recuperemos los datos filtrados y suavizados
af_hat <- KF_Results$att 
as_hat <- KF_Results$alphahat

prom_as = rowMeans(as_hat[,1:12])

# Grafica para comparar valor simulado vs el recuperado pronosticado
# por el filtro y el suavizador

# Gráfica del promedio del suavizamiento
x11(); matplot(xAxis  , yt_mat[xAxis,1:12], type="l" , col="black",lwd=1,lty=3)
lines(xAxis , prom_as  , type="l" , col="red" ,lwd=3,lty=1)

# Gráfica de la serie 12
x11(); matplot(xAxis  , yt_mat[xAxis,1:12], type="l" , col="black",lwd=1,lty=3)
lines(xAxis , as_hat[xAxis,12]  , type="l" , col="red"  ,lwd=3,lty=1)

# Gráfica de af y as
x11(); matplot(xAxis  , yt_mat[xAxis,1:12], type="l" , col="black",lwd=1,lty=3)
lines(xAxis , as_hat[xAxis,13]  , type="l" , col="red"  ,lwd=3,lty=2)
lines(xAxis , af_hat[xAxis,13]  , type="l" , col="black"  ,lwd=3,lty=2)

#pdf(file="Grafica, numeral 3.pdf")

x11()
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
matplot(xAxis  , yt_mat[xAxis,1:12], type="l" , col="black",lwd=1,lty=3,xlab="Mes", ylab="Inflación");title(main="Componente común Suavizado (serie 13 del resultado)"); lines(xAxis , as_hat[xAxis,13]  , type="l" , col="red"  ,lwd=2,lty=1)
matplot(xAxis  , yt_mat[xAxis,1:12], type="l" , col="black",lwd=1,lty=3,xlab="Mes", ylab="Inflación");title(main="Promedio de series suavizadas"); lines(xAxis , prom_as  , type="l" , col="red" ,lwd=2,lty=1)
matplot(xAxis  , yt_mat[xAxis,1:12], type="l" , col="black",lwd=1,lty=3,xlab="Mes", ylab="Inflación");title(main="Componente Suavizado (solo serie 12 - Otros)"); lines(xAxis , as_hat[xAxis,12]  , type="l" , col="red"  ,lwd=2,lty=1)

#dev.off()