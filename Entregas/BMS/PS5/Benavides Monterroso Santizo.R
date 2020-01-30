# Taller No. 5
# Integrantes: Mariela Lizeth Benavides Lázaro
#              Ernesto René Monterroso Zamora
#              Allan Fernando Santizo Flores

################################################################################
# Estimacion usando datos de inflacion mensual de Guatemala
################################################################################
rm(list=ls())
graphics.off()
library(KFAS)

# Cargar datos
Datos <- read.csv("IPC_GASTO.csv")
largo <- length(Datos$alimentos)

# Construimos la inflacion mensual por sector
yt = data.matrix(100*(log(Datos[2:largo,2:13])-log(Datos[1:(largo-1),2:13])))
xt = matrix(as.numeric(yt),ncol=12)

# pi_i,t  = (1 0)* (pi*_i,t-1 pi_t)' + epsilon_t
# pi_i,t  = (1 0)* (pi*_i,t-1 pi_t)' + epsilon_t

# Creación de matrices para construir el modelo
inicios <- c(xt[1:1,1:12],0)
MA13 <- diag(x=1,nrow=13,ncol=13)
Matriz_NA13 <- MA13*diag(NA,nrow=13,ncol=13)
MA12 <- diag(x=1,nrow=12,ncol=12)
Matriz_NA12 <- MA12*diag(NA,nrow=12,ncol=12)
unos <- rep(1,13)
ceros <- rep(0,12)
cbind(rbind(diag(x=1,12,12),ceros),unos)


# Construimos el modelo
my_a1    <- inicios
my_P1    <- diag(x=1,13,13)
my_P1inf <- diag(x=1,13,13)
my_Zt    <- cbind(diag(x=1,12,12),ceros)
my_Tt    <- cbind(rbind(diag(x=1,12,12),ceros),unos)
my_Rt    <- diag(x=1,13,13)
my_Qt    <- Matriz_NA13         # Note los NA usados para especificar
my_Ht    <- Matriz_NA12      # que hay que estimar estos parametros

m_inflacion <- SSModel( yt ~ -1 + SSMcustom( 
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
is.SSModel(m_inflacion)

# Ahora usamos el comando fitSSM para estimar el modelo
m_inflacion_estimado <- fitSSM(m_inflacion, inits = rep(1,25), method = "BFGS")
KF_Results <- KFS(m_inflacion_estimado$model)
dim(KF_Results$P)

# Veamos los parametros estimados
exp(m_inflacion_estimado$optim.out$par)
sigma2_noise_hat = m_inflacion_estimado$model$H
sigma2_signal_hat = m_inflacion_estimado$model$Q
signal2noise = sigma2_signal_hat[1:12,1:12,1]/sigma2_noise_hat[,,1]
signal2noise

# Usemos el filtor de Kalman sobre los datos con el modelo estimado
KF_Results <- KFS(m_inflacion_estimado$model)

# Recuperemos los datos filtrados y suavizados
af_hat <- KF_Results$att 
as_hat <- KF_Results$alphahat

componente_comun=as_hat[,13]#custom del 1-12 corresponden a las categorias, custom 13 corresponde a Pi_t

suavizado= as_hat[,1]+as_hat[,2]+as_hat[,3]+as_hat[,4]+as_hat[,5]+as_hat[,6]+as_hat[,7]+as_hat[,8]+as_hat[,9]+as_hat[,10]+as_hat[,11]+as_hat[,12]
promedio_suav= suavizado/12 #asumiendo que todas las categorías tienen el mismo peso

filtrado=af_hat[,1]+af_hat[,2]+af_hat[,3]+af_hat[,4]+af_hat[,5]+af_hat[,6]+af_hat[,7]+af_hat[,8]+af_hat[,9]+af_hat[,10]+af_hat[,11]+af_hat[,12]
promedio_fil=filtrado/12
    
# Grafica para comparar valor simulado vs el recuperado pronosticado
# por el filtro y el suavizador
pdf("PS5_FIG.pdf")
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE), widths=c(3,3), heights=c(2,2))
matplot(xt, type="l", col ="black",xlab="t", lty=1, ylab="Series de inflacion", main="Suavizador de Kalman - Componente Común")
lines(componente_comun,type="l",col="darkgreen",lwd=1.5,lty=1)
matplot(xt, type="l", col ="black",xlab="t", lty=1, ylab="Series de inflacion", main="Suavizador de Kalman - Serie Otros")
lines(as_hat[,12],type="l",col="darkgreen",lwd=1.5,lty=1)
matplot(xt, type="l", col ="black",xlab="t", lty=1, ylab="Series de inflacion", main="Suavizador de Kalman - Promedios")
lines(promedio_fil, type="l" , col="magenta",lwd=1.5,lty=1)
lines(promedio_suav, type="l" , col="blue" ,lwd=1.5,lty=1)
dev.off()
