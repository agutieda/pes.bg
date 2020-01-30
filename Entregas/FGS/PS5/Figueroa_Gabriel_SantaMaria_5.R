# TAREA 5
# Integrantes:
# Polo Figueroa
# David Gabriel
# Pablo Santa Maria

graphics.off()
rm(list=ls(all=TRUE)) 
set.seed(1)
library(KFAS)



Datos <- read.csv("IPC_GASTO.csv")

#transformamos los datos en una matriz
M = as.numeric(as.matrix(Datos)[,2:13])
M = matrix(data =M,ncol=12)
p = 12
m = 12
r = 12
n = 104
PI=(log(M[2:105,])-log(M[1:(105-1),]))*100


#1 Basandonos en la seccion 3.2 del documento SS_Models.pdf , reescribimos n
#  nuestras variables 

yt = PI
my_a1    <- c(yt[1,],0)       
my_P1    <- diag(13)
my_P1inf <- diag(13)
my_Tt    <- cbind(rbind(diag(1,12),rep(0,12)),rep(1,13))
my_Rt    <- diag(nrow=13,ncol=13)
my_Zt    <- cbind(diag(12),rep(0,12))
my_Qt    <- matrix(as.numeric(diag(NA,13)),nrow = 13)  
my_Ht    <- matrix(as.numeric(diag(NA,12)),nrow = 12)



# 2 estimamos el modelo


m_ipc <- SSModel( yt ~ -1 + SSMcustom( 
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

is.SSModel(m_ipc)


m_ipc_estimado <- fitSSM(m_ipc, inits = rep(1,25), method = "BFGS")

#estos son los parametros optimizados

exp(m_ipc_estimado$optim.out$par)


sigma2_noise_hat = m_ipc_estimado$model$H
sigma2_signal_hat = m_ipc_estimado$model$Q
signal2noise = sigma2_signal_hat[1:12,1:12,1] %*% solve(sigma2_noise_hat[,,1])
#signal2noise




#3 GRAFICA 

KF_Results <- KFS(m_ipc_estimado$model)
af_hat <- KF_Results$att[,13] 
as_hat <- KF_Results$alphahat[,13]

x11(title="pronostico inf mensual");
xAxis <- seq(1,n)
matplot(xAxis,yt,type='l')
#lines(xAxis , af_hat[xAxis]  , type="l" , col="red"  ,lwd=7)
lines(xAxis , as_hat[xAxis]  , type="l" , col="red" ,lwd=4,lty=1)


