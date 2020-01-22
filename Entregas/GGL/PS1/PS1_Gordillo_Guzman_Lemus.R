# Lista de ejercicios 1
# Introduccion a R
#
# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala

# Integrantes: 

#Marianna Guzmán 
#Joaquín Gordillo Sajbin 
#Luis Lemus Mackay

################################################################################
# 1)  Control de Lectura
################################################################################

# Las siguientes preguntas estan relacionadas con la forma de realizar distintas
# operaciones en R

# Basado en lo mostrado en la clase y los resultados de los "scripts" usados,
# responda las siguientes preguntas:

# 1) ¿Que comando de R podemos usar para limpiar el escritorio?
# R.

rm(list=ls())

# 2) ¿Que comando de R podemos uar para cerrar las ventanas de graficas activas?
# R. 

graphics.off()

# 3) ¿Como podemos realizar producto matricial?
# R. 

AA <- matrix(c(1,2),nrow=2,ncol=1)         # Matriz 2x1
BB <- matrix(c(1,2),nrow=1,ncol=2)         # Matriz 1x2
CC <- matrix(c(2,2),nrow=2,ncol=1)
AA%*%BB         # Multiplicacion de matrices

# 4) ¿Como podemos realizar producto punto?
# R.

AA*CC #Producto punto 

# 5) ¿Como podemos definir una matriz 10x10 llena de ceros? 
# R. 

DD <- matrix(c(0),ncol=10,nrow=10)     # Matriz 10x10 ordenada por columnas
DD

# 6) ¿Como podemos  crear un vector con cien numeros equidistantes en el 
#     intervalo [0,1]? 
# R.

seq(0,1,len=100)  # P un vector con 100 elementos equidistantes entre 0 y 1

# 7) Mencione tres tipos de datos comunmente encontrados en R
# R. 

### Tipo 1: Numerico (Numeric)
a <- c(1,2)  # El mas sencillo de todos, utilizado para "floating point numbers"
mode(a)      # La funcion mode() se refiere al tipo primitivo del dato
class(a)     # La funcion class() es un poco mas especifica

### Tipo 2: Texto (String)
b <- "FC"    # En R, los textos van entre doble comilla
mode(b)      # Los textos tienen modo y clase "character"
class(b)     # Tambien tienen clase "character"

### Tipo 3: Valores Logicos (Booleans)
c <- TRUE
mode(c)   
class(c)


# 8) ¿Que libreria nos permite cargar archivos de Excel en R?
# R. 

# Para abrir archivos de otros programas como Excel, necesitamos instalar 
# librerias adicionales

### Archivo de Excel

# Instalemos la libreria "readxl" 
install.packages("readxl")
library(readxl)

# 9) ¿Cual es el coeficiente de correlacion entre el numero de peliculas  en que
#     aparecio Nicolas Cage y el numero de muejeres editoras de la revista 
#     "Harvard Law Review" entre 2005 y 2009?
# R.

#Trabajar con Datos
################################################################################

# Necesitamos saber leer datos, guardarlos, seleccionar subconjuntos de estos,
# cambiarlos, etc 

# En R, la manipulacion de datos gira en torno a "data frames"

# Los dataframes son una especie de lista que guarda "columnas" de datos 
# relacionados. Por lo general, cada columna corresponde a una variable pero 
# cada columna puede contener un tipo diferente de dato

# Para ilustrar su uso, utilizaremos una correlacion interesante que hay entre 
# el numero de peliculas en que ha aparecido Nicolas Cage cada 12 meses con el 
# numero de editoras mujeres de la revista "Harvard Law Review", disponible en:
# http://tylervigen.com/view_correlation?id=9224

# Primero, organizamos los vectores de datos

# No. de peliculas en que aparecio Nicolas Cage entre 2005 y 2009
NC <- c(2,3,4,1,4)     

# No. de muejeres editoras en "Harvard Law Review" entre 2005 y 2009
ME <- c(9,14,19,12,19) 

# Ahora construimos un data frame.
Correlacion.Espurea <- data.frame(NC,ME)

# Podemos ver que los data frames son una clase particular de lista
mode(Correlacion.Espurea)  # El data frame tiene modo "list"
class(Correlacion.Espurea) # y clase "data.frame"

# Veamos como luce un data frame
Correlacion.Espurea 

# R da un numero a las filas y usa el nombre de la variable como columna

# Podemos dar nombres mas descriptivos a las columnas como sigue:
Correlacion.Espurea <- data.frame(nicolas.cage=NC,mujeres.editoras=ME)
Correlacion.Espurea

# Tambien podemos reemplazar los numeros de fila por letras o otros numeros
# La funcion row.names() permite saber el nombre de las filas
row.names(Correlacion.Espurea) 

# Creemos un vector de textos para reemplazar el nombre de las filas
fechas <- c("Year 2005","Year 2006","Year 2007","Year 2008","Year 2009")

# La funcion row.names() tambien permite modificar el nombre de las filas
row.names(Correlacion.Espurea) <- fechas 
row.names(Correlacion.Espurea)
Correlacion.Espurea

# Un data frame es una lista: podemos acceder a las columnas con el simbolo "$"
Correlacion.Espurea$nicolas.cage
Correlacion.Espurea$mujeres.editoras

# Sin embargo, los nombres no funcionaran directamente
nicolas.cage

# Para poder usar las columnas existentes en un data frame como si fueran 
# variables, podemos usar el comando attach()
attach(Correlacion.Espurea)
nicolas.cage

# Tambien podemos acceder a las variables de un dataframe usando la misma 
# notacion que para matrices
Correlacion.Espurea[1,2]  # Primera fila, segunda columna
Correlacion.Espurea[,2]   # Toda la segunda columna
Correlacion.Espurea[2,]   # Toda la segunda fila

# Muchas funciones de R pueden interactuar directamente con data frames

# La funcion summary() arroja estadisticas descriptivas de los datos
summary(Correlacion.Espurea)          

# Por su parte, la funcion plot() tambien recibe data frames
x11(); plot(Correlacion.Espurea) 

pdf("CorrEspurea.pdf")  
plot(Correlacion.Espurea) 
dev.off()

# Finalmente, podemos usar lm() para correr una regresion usando el data frame
# y anadimos una linea a la grafica de los datos usando la funcion abline()
mi.regresion <- lm(mujeres.editoras ~ nicolas.cage, data=Correlacion.Espurea)
abline(mi.regresion)

# Note que la funcion lm devuelve una lista como output
mi.regresion

# Podemos usar summary() sobre esta lista para obtener una tabla de resultados
summary(mi.regresion)

Coeficiente<- summary(mi.regresion)[8]
CoeficienteD <- as.numeric(Coeficiente)
CoeficienteD
CoeficienteCorr<-sqrt(CoeficienteD)
CoeficienteCorr

# 10) Haga un grafico de barras ilustrando los balones de oro ganados por 
#     Cristiano, Messi, Cruyff, Iniesta y Ronaldinho.
# R. 

x <- c(5,6,3,0,1)
names(x) <- c("Cristiano","Messi","Cruiyff","Iniesta","Ronaldinho") 
x
x11(); barplot(x, col="gold")

pdf("BalonOro.pdf")  
barplot(x, col="gold")
dev.off()

# 11) ¿Si la probabilidad de que Falcao se lesione es 0.2, cuantos partidos 
#      podemos esperar que juegue antes de lesionarse?
# R. 

# Uno de los grandes usos de los loops es la simulacion montecarlo

# Como ejemplo vamos a usar un loop para calcular el numero de juegos en 
# promedio que puede jugar Falcao antes de lesionarse a partir de simulaciones

# Suponemos que la probabilidad de que Falcao se lesione en un juego es del 20%
# Repetimos el experimento 1000 veces y promediamos para obtener una 
# aproximacion al valor esperado de juegos antes de lesionarse

num.simulaciones <- 1000
num.partidos     <- rep(0,num.simulaciones)

for (i in 1:num.simulaciones){
    partidos  <- 0 # Comencemos a contar partidos jugados
    lesion    <- 0 # Y empezemos la temporada sin lesiones
    while (lesion==0){ # Mientras no se lesione
        partidos <- partidos + 1        # Cuente el numero de partidos
        moneda   <- runif(1)            # Lance una moneda
        if (moneda <= 0.2) lesion <- 1  # Verifique si Falcao se lesiona
    }
    # Guarda el numero de partidos que Falcao jugo antes de lesionarse
    num.partidos[i] <- partidos 
}

# Promedio de partidos seguidos que podemos que juega Falcao antes de lesionarse
print(mean(num.partidos))

################################################################################
# 2) Mi primera funcion 
################################################################################

# Adjunto encontrara el archivo "CPI.xlsx" con datos mensuales del indice de 
# precios al consumidor de Guatemala (El primer dato es inventado)

# A continuacion, escriba un codigo que haga lo siguiente:
# 1) Cargue los datos del archivo CPI.xlsx (incluya los codigos necesarios para 
#    descargar y cargar un paquete, si lo necesita)

# Instalemos la libreria "readxl" 
install.packages("readxl")
library(readxl)

datos_desde <- read_excel("CPI.xlsx")
datos_desde

Mes<- datos_desde[1]
Mes

CPI <- datos_desde[1:300,2]
CPI

CPI_pres <- datos_desde[2:301 ,2]
CPI_pres



# 2) Cree una variable inflacion.mensual que contenga la inflacion mensual de 
#    Guatemala calculada usando los datos del punto anterior.
inflacion.intermensual<- ((CPI_pres-CPI)/CPI)*100
inflacion.intermensual
colnames(inflacion.intermensual) = c("inflacion.mensual")
inflacion.intermensual
inflacion.mensual <- as.matrix(inflacion.intermensual)
inflacion.mensual
#length(monthly.inflation)
#mean(inflacion.mensual[1:3])
#mode(monthly.inflation)

# 3) Defina una funcion que calcule la inflacion trimestral usando el PROMEDIO 
#    de cada trimestre

fun_mean_tri<-function(Y){
    X <- rep(NaN,1,length(Y))
    for (i in seq(1,length(Y),3)){
        X[i]<- (Y[i]+Y[i+1]+Y[i+2])/3
    }
    X = X[!is.na(X)]
    X<-as.matrix(X)
    X
}


#fun_mean_tri(inflacion.mensual)



# 4) Defina otra funcion que calcula la inflacion trimestral usando el 
#    ULTIMO MES de cada trimestre
fun_last_tri<-function(Y){
X <- rep(NaN,1,length(Y))
for (i in seq(1,length(Y),3)){
    X[i]<- Y[i+2]
}
X = X[!is.na(X)]
X<-as.matrix(X)
X}

# 5) Use las anteriores funciones para calcular las variables 
#    "inflacion.trimestral.promedio" y "inflacion.trimestral.findemes" 
#    correspondientes a cada metodo

fun_mean_tri(inflacion.mensual)
fun_last_tri(inflacion.mensual)

# 6) En una misma figura, muestre la grafica de cada una de las dos variables
#    calculadas en el paso anterior para comparar los resultados de cada metodo
#

y<-fun_mean_tri(inflacion.mensual)
z<-fun_last_tri(inflacion.mensual)

x11(); plot(fun_mean_tri(inflacion.mensual),col="red",
            type="l",
            xlab="Tiempo",ylab="PIB",
            main="Grafica PIB Trimestral")  
points(z,type="l",col="blue")

pdf("pib_tri.pdf")  
plot(fun_mean_tri(inflacion.mensual),col="red",
     type="l",
     xlab="Tiempo",ylab="PIB",
     main="Grafica PIB Trimestral")  
points(z,type="l",col="blue")
dev.off()
# Pista: Los resultados deven ser iguales a los de la hoja ".csv" en el 
# mismo archivo CPI

################################################################################
# 3) Github e intereses de ustedes
################################################################################

# 1) Lea esta breve introduccion a Github
# https://conociendogithub.readthedocs.io/en/latest/

# 2) Cree una cuenta de github y escriba aqui el usuario de cada integrante
# del grupo:

# -mariannaguzman
# -JoaquinSajbin
# -luisfermck95

# 3) Escriba aca las areas de interes en economia de cada integrante
# (microeconomia teorica, macroeconomia aplicada, macroeconometria,
#  microeconometria, econometria, finanzas, etc... )

#Marianna Guzman: finanzas
#Joaquin Sajbin: macroeconomia aplicada
#Luis Lemus: finanzas; econometria

# 4) Escriba aca algun topico de interes que le llamaria la atencion aprender
#    durante el curso
#
#Machine Learning in R
#R for Data Science
#Hypothesis Testing 
#Regression Predictions and Confidence Intervals 
#Time Series Analysis 




