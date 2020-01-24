# Lista de ejercicios 3

# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala

# Integrantes: 
# Elmer Humberto Lémus Flores
# Erwin Roberto Navas Solis

rm(list = ls()); graphics.off()

###############################################################################
# Cree una función que evalúe la log-verosimilitud del proceso en el punto    #
# theta dadas las observaciones yt simuladas.                                 #
###############################################################################

log_vero <- function(theta, y = y_valores, y0 = inicial){
    
    mi = theta[1]
    rho = theta[2]
    sigma = theta[3]
    nT = length(y)
    parcial = rep(NaN,(nT-1)) # Para sumatoria
    
    for (t in 2:nT) {
        parcial[t-1] = ((y[t]-mi-rho*y[t-1])^2)/(2*sigma)
    }
    
    # Log-verosimilitud
    log_salida = ((-1/2)*log(2*pi))-((1/2)*log(sigma/(1-rho^2)))-
        ((y0-(mi/(1-rho)))^2)/((2*sigma)/(1-rho^2))-((nT-1)/2)*log(2*pi)-
        ((nT-1)/2)*log(sigma)-sum(parcial)
    
    return(log_salida)
}

###############################################################################
# Genere el vector eps y el valor inicial y1 y simule T = 100 observaciones   #
# del proceso yt con los parámetros.                                          #
###############################################################################

# Definición de parámetros
rho = 0.4
sigma = 0.5
mi = 1
nT = 100
# Semilla
set.seed(5)

# Valor inicial aleatorio
y0 = rnorm(1, mean = (mi/(1-rho)), sd = sqrt(sigma/(1-rho^2)))
eps = rnorm(nT, mean = 0, sd = sqrt(sigma)) # Simulación de eps
inicial = y0

# Construcción de serie AR(1)
y = rep(NaN,nT)
y[1] = y0

for (t in 2:nT){
    y[t] = mi + rho*y[t-1] + eps[t]}

# vector theta
theta =c(mi, rho, sigma)
y_valores = y 

# Evaluación
log_vero(theta,y)

###############################################################################
# Use una función de optimización numérica para encontrar el estimador de     #
# máxima verosimilitud, definido como el vector de parámetros que maximiza    #
# la función de log-verosimilitud dados los datos simulados en el punto       #
# anterior (Use como valores iniciales el vector theta = [0:5; 0:5; 0:5].     #
###############################################################################

# Valores Iniciales
theta =c(0.5, 0.5, 0.5)

# Optimización
respuesta = optim(theta, log_vero, control=list(fnscale=-1))
respuesta

theta_optim = respuesta$par
theta_optim

###############################################################################
# Cree un ciclo que repita 1000 veces los pasos en los puntos (2) a (3) y     #
# guarde los valores de theta obtenidos en cada iteración. Grafique el        #
# histograma de frecuencias de la distribución de el estimador de cada uno de #
# estos parámetros.                                                           #
###############################################################################

# Listas para los resultados simulados
result_mi = rep(NaN,1000)
result_rho = rep(NaN,1000)
result_sigma = rep(NaN,1000)

# Para simulación
for (i in 1:1000){
    
    # Definición de parámetros
    rho = 0.4
    sigma = 0.5
    mi = 1
    nT = 100
    y0 = rnorm(1, mean = (mi/(1-rho)), sd = (sigma/(1-rho^2)))
    inicial = y0
    eps = rnorm(nT, mean = 0, sd = sqrt(sigma)) # Simulación de eps
    
    # Construcción de serie AR(1)
    y_sim = rep(NaN,1)
    y_sim[1] = y0
    
    for (t in 2:nT){
        y_sim[t] = mi + rho*y_sim[t-1] + eps[t]}
    
    # vector theta
    theta =c(0.5, 0.5, 0.5)
    y_valores = y_sim
    optimos = optim(theta, log_vero, control=list(fnscale=-1))
    result_mi[i] = optimos$par[1]
    result_rho[i] = optimos$par[2]
    result_sigma[i] = optimos$par[3]
}

# Gráficos
x11(); hist(result_mi, breaks = 20, col = "blue")
x11(); hist(result_rho, breaks = 20, col = "red")
x11(); hist(result_sigma, breaks = 20, col = "brown")

###############################################################################
# Estimación de un AR(1), Parte II                                            #
###############################################################################


###############################################################################
# Escriba una función que calcule los errores estándar del estimador de       #
# máxima verosimilitud                                                        #
###############################################################################

# Argumentos para encontrar el error estandar
a = theta_optim
b = y

# Opción 1, estimación por simulación
eestandar = function(theta_optim, y) {
    
    # Función auxiliar para la optimización
    log_veros <- function(theta, y = y_valor, y0 = inicial){
        
        mi = theta[1]
        rho = theta[2]
        sigma = theta[3]
        nT = length(y)
        parcial = rep(NaN,(nT-1)) # Para sumatoria
        
        for (t in 2:nT) {
            parcial[t-1] = ((y[t]-mi-rho*y[t-1])^2)/(2*sigma)
        }
        
        # Log-verosimilitud
        log_salida = ((-1/2)*log(2*pi))-((1/2)*log(sigma/(1-rho^2)))-
            ((y0-(mi/(1-rho)))^2)/((2*sigma)/(1-rho^2))-((nT-1)/2)*log(2*pi)-
            ((nT-1)/2)*log(sigma)-sum(parcial)
        
        return(log_salida)
    }
    
    
    # Listas para los resultados simulados
    result_mi_b = rep(NaN, 1000)
    result_rho_b = rep(NaN, 1000)
    result_sigma_b = rep(NaN, 1000)
    nT = length(y)
    
    # Valores de theta
    mi = theta_optim[1]
    rho = theta_optim[2]
    sigma = theta_optim[3]
    
    # Valores simulados
    y_est = rep(NaN, nT)
    y_est[1] = y[1]
    
    for (t in 2:nT) {
        y_est[t] = mi + rho * y[t - 1]
    }
    
    error = y - y_est
    
    # Para simulación
    for (i in 1:1000) {
        # Definición de parámetros
        error_aleatorio = sample(error, nT, replace = FALSE)
        
        # Simulación
        y_simulado = rep(NaN, nT)
        y_simulado[1] = y[1]
        
        for (t in 2:nT) {
            y_simulado[t] = mi + rho * y_simulado[t - 1] + error_aleatorio[t]
        }
        
        y_valor = y_simulado
        
        # vector theta
        theta = c(0.5, 0.5, 0.5)
        optimos = optim(theta, log_veros, control = list(fnscale = -1))
        result_mi_b[i] = optimos$par[1]
        result_rho_b[i] = optimos$par[2]
        result_sigma_b[i] = optimos$par[3]
    }
    
    # Error estandar
    ee = c(sqrt(var(result_mi_b)), 
           sqrt(var(result_rho_b)), 
           sqrt(var(result_sigma_b)))
    
    # Valor medio
    eem = c(mean(result_mi_b),
            mean(result_rho_b),
            mean(result_sigma_b))
    
    return(ee)
}

eestandar(a, b)

# Opción 2, estimación según matemática (hoja de trabajo)

# Función de error estándar
eestandar_2 = function(theta,y = y_valores){
    nT = length(y)
    resul = optim(theta, log_vero, control=list(fnscale=-1), hessian = TRUE)
    hess = resul$hessian
    jacob = (-1/nT)*hess
    jacob_inversa = solve(jacob)
    ee_mi = sqrt(jacob_inversa[1,1])
    ee_rho = sqrt(jacob_inversa[2,2])
    ee_sigma = sqrt(jacob_inversa[3,3])
    ee = c(ee_mi,ee_rho,ee_sigma)
    return(ee)
}

eestandar_2(a, b)

###############################################################################
# Utilice el código anterior para encontrar el estimador de máxima            #
# verosimilitud de un AR(1) y sus errores estándar asociados para la serie    #
# de inflación mensual en la hoja de Excel adjunta a este taller.             #
###############################################################################

# Extraemos datos
library(readxl)
datos <- read_excel(path = "inflacion.xlsx", sheet = "Main")
data = datos$inflacion
y = data
y_valores = y 

# Valores iniciales
y0 = y[1]
inicial = y0

theta = c(0.25, 0.8, 0.6)

# Estimación
respuesta2 = optim(theta, log_vero, control=list(fnscale=-1))

# Valores óptimos de theta, de la nueva serie
theta_optim = respuesta2$par
theta_optim

# Maxima verisimilitud
log_vero(theta_optim,y,y0)

# Con opción 1, principal
eestandar(theta_optim,y)

# Con opción 2, con hessiana
eestandar_2(theta_optim,y)

# Comparación
arima(y,c(1,0,0))