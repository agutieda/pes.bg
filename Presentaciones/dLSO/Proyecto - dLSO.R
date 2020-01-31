# Manejando series de tiempo financieras con R

# Jose Domingo de Leon
# Hugo Leonel Orellana
# Diego Ignacio Sanchez

# Comencemos como siempre: limpiando el escritorio
graphics.off(); rm(list=ls());

#Instalamos y corremos 3 librerías
#install.packages("fBasics")
#install.packages("timeDate")
#install.packages("timeSeries")
#install.packages("parallel")
#install.packages("rugarch")
#install.packages("tseries")
#install.packages("zoo")
#install.packages("lmtest") 
#install.packages("forecast")

#Cargamos las librerías
library(timeDate)
library(timeSeries)
library(fBasics)
library(parallel)
library(rugarch)
library(tseries)
library(fBasics)
library(zoo)
library(lmtest) 
library(forecast)


################################################################################
###    Obteniendo los datos del precio al cierre con datos del CSV          ####  
################################################################################

setwd("C:/Users/IN_CAP02/Desktop/Proyecto")

apple = read.table("AAPL.csv", header=T, sep=',')

applets <- zoo(apple$Adj.Close, as.Date(as.character(apple$Date), format = c("%Y-%m-%d")))   
# se crea la serie temporal del precio de las acciones

#retornos logaritmicos de las acciones de la empresa
apple_retl <- log(applets/lag(applets,-1)) 

#retornos simples de las acciones de la empresa
apple_rets <- ((applets/lag(applets,-1))-1)

#Quitar las fechas y crear objetos númericos con una función de zoo
apple_retl_num <- coredata(apple_retl)

################################################################################
###   Analisis de la serie financiera de los precios de la accion de APPLE   ###
################################################################################

# Grafica precios de la accion
x11(); plot(applets, type='l', xlab = "Años", ylab = " Precio de cierre ajustado", main="Precios diarios APPL (2010-2020)", col = 'darkblue')
x11(); boxPlot(applets, col="darkblue", title = TRUE)
x11(); boxPercentilePlot(applets, col="darkblue", title = TRUE)

#Resumen de estadisticas basicas de los precios de la accion de APPL
basicStats(applets)

# Al observar las estadisticas basicas se observa que el promedio no es cero y la 
# varianza es alta, lo que indica que la serie de precios no es estacionaria
# Por lo tanto para estacionalizar el proceso se estudia el rendimiento logaritmico 
# del precio de la accion. Esto se refuerza con las siguientes 2 graficas.

################################################################################
###                        Graficos ACF y PACF                               ###
################################################################################

##################################
### Funcion de autocorrelacion ###
##################################
# es utilizada para identificar el proceso de media movil en un modelo ARIMA.
x11(); acf(coredata(applets), main="Grafica ACF precios diarios APPL (2010-2020)")  

# Se observa que el proceso decae a cero, lo que significa que un choque afecta 
#al proceso de forma permanente. Por lo que se debe realizar un análisis de series 
#temporales de los retornos logaritmicos diarios de los precios de las acciones.

##########################################
### Función de autocorrelacion parcial ###
##########################################
#es utilizada para identificar los valores de la parte del proceso autoregresivo AR.
x11(); pacf(coredata(applets), main="Grafica PACF precios diarios APPL (2010-2020)")  

#La función PACF calcula (y por defecto traza) una estimación de la función de 
#autocorrelación parcial de una serie de tiempo.En su primera fase (o fase inicial) 
#presenta correlaciones significativas.

# Por lo anterior se procede a realizar:

################################################################################
###   Análisis de los retornos logaritmicos de la accion de APPLE    ###
################################################################################

#Resumen de estadistsicas basicas retornos log
basicStats(apple_retl)

#Otras graficas descriptivas de los retornos logaritmicos
x11(); boxPlot(apple_retl, col="darkgreen", title = TRUE)
x11(); boxPercentilePlot(apple_retl, col="darkgreen", title = TRUE)

# Se observa que el promedio y la varianza son cercanos a cero y la distribucion 
# de los retornos logaritmicos tiene curtosis larga y colas pesadas.

###############################################
### Histograma de los retornos logarítmicos ###
###############################################

##NOTA: Correr las siguientes 4 líneas juntas
x11(); hist(apple_retl, xlab="Retornos log diarios", prob=TRUE, main="Histograma de los retornos log diarios de APPL");
xfit<-seq(min(apple_retl),max(apple_retl),length=30);
yfit<-dnorm(xfit,mean=mean(apple_retl),sd=sd(apple_retl));
lines(xfit, yfit, col="red", lwd=2)

# Por la gráfica anterior se puede concluir que los retornos presentan una 
# distribucion leptokurtica con una gran concentracion de puntos alrededor 
# de la media y la serie parece tener mas outliers que los los asociados a una 
# distribucion normal.

################
### QQ-Plot  ###
################

x11(); qqnorm(apple_retl, col ="steelblue")
qqline(apple_retl, col = "red") 

# La linea roja equivale a la distribucion normal, mientras mas distante los 
# puntos de la linea recta, menos normal se comporta la serie de retornos. 
# Las mayores diferencias se presentan en los valores extremos del retorno.
# Se evidencia que la distribución parece normal y tiene colas gruesas en ambos 
# extremos. Sin embargo se realiza las siguientes pruebas de normalidad para 
# validar el supuesto:

jarque.bera.test(apple_retl)   # Test de normalidad Jarque bera 

a= adTest(apple_retl, title = NULL, description = NULL)  
# Test de normalidad Anderson–Darling
a

# Por lo general, entre las pruebas que se basan en la funcion de distribucion 
# empirica, la prueba de Anderson-Darling tiende a ser mas efectiva para 
# detectar desviaciones en las colas de la distribución. En ambos test se 
# rechaza la normalidad de los retornos logaritmicos.


################################
### Prueba de Dickey Fuller  ###
################################

adf.test(apple_retl, k=13)
# Realiza la prueba de Dickey Fuller, donde "k" corresponde al numero de rezagos
# La hipotesis nula dice que la serie no es estacionaria dado que tiene una raiz 
# unitaria.

# La alternativa dice que la serie es estacionaria y esto concuerda con los 
# criterios de informacion negativos.

# La prueba dicta valores de prueba negativos para todos los rezagos, lo que 
# comprueba que las raíces del polinomio caen fuera del circulo unitario, 
# por lo que los retornos logaritmicos si son un proceso estacionario.

###########################################################
###    Homoscedasticidad de los retornos logaritmicos   ###
###########################################################
# Grafica retornos de la acción
x11(); plot(apple_retl, type='l', xlab = "Años", ylab = "Retornos log", main="Retornos logaritmicos APPL (2000-2020)", col = 'darkgreen')

# Grafica retornos de la acción al cuadrado
x11(); plot(apple_retl^2, type='l', xlab = "Años", ylab = "Retornos log al cuadrado", main="Retornos logaritmicos al cuadrado APPL (2000-2020)", col = 'darkgreen')

# Elevar al cuadrado elimina el signo e incrementa la dimensión lo que hace que 
# los retornos pequeños pierdan relevancia frente a los retornos de mayor tamaño 
# en la gráfica.

# Grafica retornos de la acción valor absoluto
x11(); plot(abs(apple_retl), type='l', xlab = "Años", ylab = "valor absoluto de los retornos log", main="Valor absoluto retornos logaritmicos APPL (2000-2020)", col = 'darkgreen')

# Importante notar que las graficas tienen escalas diferentes en el eje y, en 
# cada grafica se pueden ver periodos de alta volatilidad, sobre en los años 2013 
# y 2019. Esto indica que la serie de los retornos logaritmicos tiene varianza 
# condicional heteroscedastica. Esta alta volatilidad no dismiuye tan rápido 
# porque los choques negativos tienen un efecto en el proceso.

######################################################
### Autocorrelaciones de los retornos logaritmicos ###
######################################################

# Grafica ACF de los retornos log de los precios de las acciones de APPL
par(mfrow=c(2,1))
x11(); acf(apple_retl_num, main="Grafica ACF de los retornos logaritmicos APPL (2010-2020)", ylim=c(-0.05,0.05))

# Grafica ACF de los retornos log al cuadrado de los precios de las acciones de APPL
x11(); acf(apple_retl_num^2, main="Grafica ACF de los retornos log al cuadrado APPL (2010-2020)", ylim=c(-0.05,0.1))

# Grafica ACF del valor absoluto de los retornos log de los precios de las 
# acciones de APPL
x11(); acf(abs(apple_retl_num), main="Grafica ACF de los valores absolutos de los retornos log APPL (2010-2020)", ylim=c(-0.05,0.15))

# En los graficos anteriores las líneas horizontales que aparecen en los 
# gráficos muestran dos desviaciones estándar del error en el estimador, por 
# encima y por debajo de cero, constituyendo así un intervalo de confianza. 
# Si el coeficiente de autocorrelación está dentro del intervalo de confianza, 
# no se puede rechazar la hipótesis de que su valor sea estadísticamente 
# diferente de 0. Sin embargo los valores de los retornos al cuadrado y el valor 
# absoluto si presentan una correlación y por lo tanto el proceso de retornos 
# logaritmicos tiene una fuerte relación no lineal. 

#########################################################
### Prueba Ljung-Box-Pierce para coeficientes         ###
### de autocorrelación de los retornos logaritmicos   ###
#########################################################

# Prueba de Ljung Box, se utiliza para comprobar si una serie de observaciones en 
# un período de tiempo específico son aleatorias e independientes. 

# Si las observaciones no son independientes, una observación puede estar 
# correlacionada con otra observación k unidades de tiempo después, una relación 
# que se denomina autocorrelación. Esta puede reducir la exactitud de un modelo 
# predictivo basado en el tiempo, y conducir a una interpretación errónea de los 
# datos. 

# El estadistico Q de Ljung-Box (LBQ) prueba la hipótesis nula de que las 
# autocorrelaciones de hasta un desfase k son iguales a cero (es decir, no 
# existe autocorrelacion). Si el LBQ es mayor que un valor critico especificado, 
# se rechaza la H0, lo que indicaría que los valores no son aleatorios ni 
# independientes en el tiempo.

#Ljung Box test para los retornos logARITM
Box.test(apple_retl_num, lag=7, type="Ljung")
Box.test(apple_retl_num, lag=15, type="Ljung")
Box.test(apple_retl_num, lag=30, type="Ljung")

# De las pruebas de caja de Ljung anteriores, se observa que los retornos 
# logarítmicos no están correlacionados a muy corto plazo, pero sí a plazos 
# mayores a una semana tal y como ocurre al realizar el test para rezagos igual 
# a 15 y 30. 


################################################################################
###                            AJUSTE DEL MODELO                             ###
################################################################################

#########################################################################
###  Modelo 1: ARMA(0)-GARCH(1,1) con errores distribuidos normalmente  ###
#########################################################################

garch11.spec=ugarchspec(variance.model=list(garchOrder=c(1,1)), mean.model=list(armaOrder=c(0,0)))

# La funcion ugarchspec es el punto de partida del paquete rugarch, aqui se 
# define el modelo para la media condicional, la varianza y la distribucion, 
# ademas permite al usuario establecer cualquier parametro inicial o fijo.

# El objeto devuelto de clase uGARCHspec puede tomar un conjunto de parametros 
# iniciales o fijos, ya sea al inicio o posteriormente mediante el uso de los 
# metodos setstart y setfixed. Tambien se pueden establecer el limite inferior 
# y superior personalizado para la mayoria de los parametros. Ver modelo 4.


# Estimando el modelo
garch11.fit=ugarchfit(spec=garch11.spec, data=apple_retl)
garch11.fit

# Para estimar los parametros del modelo se utiliza el metodo uGARCHfit. 
# Esta estimacion toma como argumento la especificacion previamente definida, 
# y algunos argumentos adicionales como el tipo de solver utilizado, el control 
# de parametros y una lista adicional de opciones (fit.control) que se puede 
# utilizar para ajustar el proceso de estimacion en caso de que exista 
# dificultad para converger. 

# Diagnostico del residuo: Prueba de Ljung Box para evaluar el comportamiento 
# del ruido blanco en los residuos. Dado que los pvalues > 0.05, no se rechaza 
# la hipótesis nula, por lo que no hay evidencia de autocorrelacion en los 
# residuos. Por lo tanto, estos se comportan como ruido blanco.

# Prueba de comportamiento ARCH en los residuos: Los pvalue > 0.05, por lo que 
# no se puede rechazar la hipótesis nula, por lo que no hay evidencia de 
# correlación serial en los residuos al cuadrado. Por lo tanto estos se comportan
# como un proceso de ruido blanco.

# Al observar la salida de la prueba de bondad de ajuste, como los pvalue > 0.05, 
# se rechaza la hipotesis nula de distribucion normal.

######################################
### Extraccion de los coeficientes ###
######################################
#coeficientes estimados:
coef(garch11.fit)

#media no condicional en la ecuación de la media
uncmean(garch11.fit)

#varianza no condicional: omega/(alpha1+beta1)
uncvariance(garch11.fit)

# residuos del modelo estimado
residuals(garch11.fit)
x11(); plot(residuals(garch11.fit))

# Criterios de informacion del modelo GARCH
infocriteria(garch11.fit)

# Log-likelihood del optimo estimado
likelihood(garch11.fit)

###################################
### Seleccion de graficas GARCH ###
###################################

#creando una lista de seleccion de graficas de garch(1,1)
x11(); plot(garch11.fit, which = "all")


################################################################################
###                  Otras estimaciones de otros modelos                     ### 
################################################################################

##################################################################
###  Modelo 2: ARMA(0,0)-GARCH(1,1) modelo con distribucion t  ###
##################################################################
garch11.t.spec=ugarchspec(variance.model=list(garchOrder=c(1,1)), mean.model=list(armaOrder=c(0,0)), distribution.model = "std")

#estimando modelo 
garch11.t.fit=ugarchfit(spec=garch11.t.spec, data=apple_retl)
garch11.t.fit

#######################################################################
### Modelo 3:ARMA(0,0)-GARCH(1,1) modelo con distribucion t sesgada ###
#######################################################################
garch11.skt.spec=ugarchspec(variance.model=list(garchOrder=c(1,1)), mean.model=list(armaOrder=c(0,0)), distribution.model = "sstd")

#estimando modelo 
garch11.skt.fit=ugarchfit(spec=garch11.skt.spec, data=apple_retl)
garch11.skt.fit

#######################################################################
###  Modelo 4: Fit ARMA(0,0)-eGARCH(1,1) modelo con distribucion t  ###
#######################################################################

egarch11.t.spec=ugarchspec(variance.model=list(model = "eGARCH", garchOrder=c(1,1)), mean.model=list(armaOrder=c(0,0)), distribution.model = "std")
#setstart(egarch11.t.spec) <- list(shape = 5)
#setfixed(egarch11.t.spec) <- list(mu = 0.01, omega = 1e-05, alpha1 = 0.03, beta1 = 0.9, gamma1 = 0.01, shape = 5)

#estimando modelo 
egarch11.t.fit=ugarchfit(spec=egarch11.t.spec, data=apple_retl)
egarch11.t.fit


# La salida R anterior muestra un modelo medio AR (0) con el modelo estándar de 
# Egarch (1,1), para la varianza con distribución t. Es posible observar que el 
# valor del parametro alfa es menor a cero, por lo tanto, el efecto de 
# apalancamiento es significativo y es posible concluir que la volatilidad 
# reacciona más fuertemente a los choques negativos.

#######################################################################
###  Modelo 5: Fit ARMA(0,0)-fGARCH(1,1) modelo con distribucion t  ###
####################################################################### 
fgarch11.t.spec=ugarchspec(variance.model=list(model = "fGARCH", garchOrder=c(1,1), submodel = "APARCH"), mean.model=list(armaOrder=c(0,0)), distribution.model = "std")

#estimando modelo 
fgarch11.t.fit=ugarchfit(spec=fgarch11.t.spec, data=apple_retl)
fgarch11.t.fit

###############################
### Modelo 6: Modelo Igarch ###
###############################
igarch11.t.spec=ugarchspec(variance.model=list(model = "iGARCH", garchOrder=c(1,1)), mean.model=list(armaOrder=c(0 , 0 )), distribution.model = "std")

#estimando modelo 
igarch11.t.fit=ugarchfit(spec=igarch11.t.spec, data=apple_retl)
igarch11.t.fit

##################################################################
### Comparando los posibles modelos / Criterios de Informacion ###
##################################################################
# Se selecciona el modelo 4, al tener menor criterio de informacion de Bayes 
# de -5.6054

infocriteria(garch11.fit)
infocriteria(garch11.t.fit)
infocriteria(garch11.skt.fit)
infocriteria(egarch11.t.fit)    # seleccionado por criterio Bayes/Schawrz
infocriteria(fgarch11.t.fit)    # seleccionado por criterio Akaike
infocriteria(igarch11.t.fit)


#Genera los criterios de informacion del modelo
#El criterio de informacion de Bayes tambien es llamado criterio de informacion de
#Schwarz y se calcula de la siguiente manera:
#BIC = k * ln(n) - 2*Ln(L) en donde:
#k es el numero de parametros del modelo
#Ln(L) es la funcion de log verosimilitud del modelo.


################################################################################
###                   Pronostico y diagnostico del modelo                    ###
################################################################################

library(rugarch) 

# El pronostico  en rugarch permite realizar pronosticos no condicionales 
# n.ahead, asi como pronosticos continuos basados en el uso de la opcion out.sample. 
# Los datos se pueden introducir como objetos de clase uGARCHfit (en cuyo caso
# se ignora el argumento de datos) o como un objeto de clase uGARCHspec (en cuyo 
# caso si se requieren los datos) con parametros fijos. El pronostico en los 
# modelos GARCH depende del valor esperado de las innovaciones y, por lo tanto de
# la densidad elegida. Los pronosticos One step ahead, se basan en el valor de 
# los datos anteriores. La capacidad de realizar el pronostico 1 paso a la vez 
# se implementa con el argumento n.roll que controla cuantas veces se ejecuta el 
# pronostico n.ahead. El argumento predeterminado n.roll = 0 devuelve el 
# pronostico n.ahead estandar. Dado que n.roll depende de los datos disponibles 
# para basar el pronostico continuo, el metodo uGARCHfit debe llamarse con el 
# argumento out.sample mayor que el argumento n.roll. A continuacion un ejemplo:

egarch11.t.spec=ugarchspec(variance.model=list(model = "eGARCH", garchOrder=c(1,1)), mean.model=list(armaOrder=c(0,0)), distribution.model = "std")

# estableciendo out.sample modelo 
egarch11.t.fit=ugarchfit(spec=egarch11.t.spec, data=apple_retl, out.sample = 200)

### Pronosticos no condicionales
forc1 = ugarchforecast(egarch11.t.fit, n.ahead=100)
forc1
x11(); plot(forc1, which = 1)    # Al no tener n.roll no puedo graficar graficas de forecast rolling

### Pronosticos continuos
forc2 = ugarchforecast(egarch11.t.fit, n.ahead=100, n.roll=75)
forc2

x11(); plot(forc2, which=2)
x11(); plot(forc2, which="all")


# La sigma del pronostico es la volatilidad condicional pronosticada en el 
# tiempo t + h y la serie representa la media condicional en el tiempo t + h. 
# Se observa que la media prevista es constante. La volatilidad prevista 
# converge a la desviacion estandar general(incondicional) de las series de tiempo. 

######################################
### Pronostico y GARCH Bootstrap #####
######################################

# Hay 2 tipos de pronosticos disponibles con este paquete. Un metodo rolling, 
# donde 1-ahead pronosticos se crean en base a una opcion out.sample en la rutina 
# de ajuste, y un metodo no condicional para n>1  pronosticos hacia adelante.

bootf = ugarchboot(egarch11.t.fit, data = NULL, method = c("Partial", "Full")[1],
                   sampling = c("raw", "kernel", "spd"), spd.options = list(upper = 0.9,lower = 0.1, type = "pwm", kernel = "normal"), n.ahead = 500,
                   n.bootfit = 100, n.bootpred = 500, out.sample = 0, rseed = NA, solver = "solnp", solver.control = list(), fit.control = list())
show(bootf)
x11(); plot(bootf, which = 2)
x11(); plot(bootf, which = 3)


################################################################################
###  Incertidumbre de parametros y densidad simulada: distribucion de uGARCH ###
################################################################################

# Este metodo permite la generacion de la densidad de los parametros simulados 
# de un conjunto de parametros de un modelo, el error cuadratico medio (RMSE) 
# de parametros verdaderos vs estimados en relacion con el tamaño de los datos.
# El metodo toma un objeto clase uGARCHfit o uno de clase uGARCHspec con 
#parametros fijos. A continuacion un ejemplo: 

##########################
###  PAra el modelo 1  ###
##########################

library(parallel)
cl = makePSOCKcluster(10)

gd = ugarchdistribution(garch11.fit, n.sim = 500, recursive = TRUE, recursive.length = 6000, recursive.window = 500, m.sim = 100, solver = 'hybrid', cluster = cl)
stopCluster(cl)
show(gd)

x11(); plot(gd, which = 1, window = 12)
x11(); plot(gd, which = 3, window = 12)
x11(); plot(gd, which = 4, window = 12)

##########################
###  Para el modelo 4  ###
##########################

library(parallel)
cl4 = makePSOCKcluster(15)

gd4 = ugarchdistribution(egarch11.t.fit, n.sim = 500, recursive = TRUE, recursive.length = 6000, recursive.window = 500, m.sim = 100, solver = 'hybrid', cluster = cl4)
stopCluster(cl4)
show(gd4)

x11(); plot(gd4, which = 1, window = 12)
x11(); plot(gd4, which = 3, window = 12)
x11(); plot(gd4, which = 4, window = 12)

##################################################
###  Variacion modelo 4 que incluye ARMA(1,1)  ###
##################################################

egarch11.t.spec2=ugarchspec(variance.model=list(model = "eGARCH", garchOrder=c(1,1)), mean.model=list(armaOrder=c(1,1)), distribution.model = "std")

#estimando modelo 
egarch11.t.fit2=ugarchfit(spec=egarch11.t.spec2, data=apple_retl)
#setfixed(egarch11.t.spec2) <- list(mu = 0.01, ma1 = 0.2, ar1 = 0.5, omega = 1e-05, alpha1 = 0.03, beta1 = 0.9, gamma1 = 0.01, shape = 5)
egarch11.t.fit2

library(parallel)
cl42 = makePSOCKcluster(15)

gd42 = ugarchdistribution(egarch11.t.fit, n.sim = 500, recursive = TRUE, recursive.length = 6000, recursive.window = 500, m.sim = 100, solver = 'hybrid', cluster = cl42)
stopCluster(cl42)
show(gd42)

x11(); plot(gd42, which = 1, window = 12)
x11(); plot(gd42, which = 3, window = 12)
x11(); plot(gd42, which = 4, window = 12)

# El anterior modelo se incluyo unicamente para mostrar que la estimacion 
# tambien toma en cuenta los parametros asociados a los modelos autoregresivos 
# y de medias moviles. 

################################################################################
###                          Tip para la vida                                ###
################################################################################
COLOR = colorMatrix() #Genera una matriz con todos los colores disponibles en R, 
# para utilizarlos en las gráficas por ejemplo
print(COLOR)

x11()
colorLocator(locator = FALSE, cex.axis = 0.7)
#Gráfica/Matriz que despliega los colores