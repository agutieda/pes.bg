# Modelos de Estado Espacio y Filtro de Kalman:
# PS4
#
# Byron Ajanel Gonzalez
# Andres M.Ortiz Flores

rm(list=ls(all=TRUE)) 
graphics.off()

set.seed(1)

library(KFAS)

setwd("C:/Users/in_cap02/Desktop/Programacion II/ProblemSets/PS5")

datos = read.csv("IPC_GASTO.csv")
y_obs = datos[,-1]
n = nrow(y_obs)

yt=data.matrix((y_obs[2:n,]/y_obs[1:(n-1),]-1)*100)
n_series=ncol(yt)

my_a1    <- matrix(c(0),n_series+1,1)            
my_P1    <- diag(rep(1,n_series+1))
my_P1inf <- diag(rep(1,n_series+1))
my_Tt    <- cbind(rbind(diag(n_series),rep(0,n_series)),rep(1,n_series+1))
my_Rt    <- diag(n_series+1)
my_Zt    <- cbind(diag(n_series),rep(0,n_series))
my_Qt    <- diag(rep(NA,n_series+1))
my_Ht    <- diag(rep(NA,n_series))


IPC <- SSModel( yt ~ -1 + SSMcustom( 
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

IPC
is.SSModel(IPC)

val_inic =exp(rnorm(2*n_series+1))

# Ahora usamos el comando fitSSM para estimar el modelo
IPC_estimado <- fitSSM(IPC, inits = val_inic, method = "L-BFGS-B")

# Usemos el filtor de Kalman sobre los datos con el modelo estimado
KF_Results <- KFS(IPC_estimado$model)

# Recuperemos los datos filtrados y suavizados
af_hat <- KF_Results$att 
as_hat <- KF_Results$alphahat

com_trend = as_hat[,12]

x11(title="Inflacion Mensual: Observada, filtrada y suavizada");
matplot(yt  , type="l" , col="black",lwd=1,lty=1)
lines(com_trend , type="l" , col="blue" ,lwd=3,lty=1)










