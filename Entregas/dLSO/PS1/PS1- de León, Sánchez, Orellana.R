# Lista de ejercicios 1
# Introduccion a R
#
# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala

# Integrantes: 
#José Domingo de León Miranda
#Hugo Leonel Orellana Alfaro
#Diego Ignacio Sánchez del Cid
################################################################################
# 1)  Control de Lectura
################################################################################
graphics.off(); rm(list=ls());
# Las siguientes preguntas estan relacionadas con la forma de realizar distintas
# operaciones en R

# Basado en lo mostrado en la clase y los resultados de los "scripts" usados,
# responda las siguientes preguntas:

# 1) ¿Que comando de R podemos usar para limpiar el escritorio?
# R. El comando que puede emplearse es "Ctrl + L" 

# 2) ¿Que comando de R podemos uar para cerrar las ventanas de graficas activas?
# R. El comando que puede emplearse es "graphics.off() "

# 3) ¿Como podemos realizar producto matricial?
# R. Para la multiplicación matricial puede utilizarse "%*%"
AA <- matrix(c(1,2),nrow=2,ncol=1)        
BB <- matrix(c(5,7),nrow=1,ncol=2) 
AA
BB
AA%*%BB
# 4) ¿Como podemos realizar producto punto?
# R. Para el producto punto entre dos matrices debe realizarse una 
#multiplicación "*" entre una matriz con la transpuesta de la segunda matriz
#Ejemplo con matrices de misma dimensión
CC <- matrix(c(1,2),nrow=1,ncol=2)        
DD <- matrix(c(5,7),nrow=1,ncol=2) 
CC
DD
CC%*%t(DD)
#Ejemplo de matrices con dimensiones contrarias
EE <- matrix(c(1,2),nrow=1,ncol=2)        
DD <- matrix(c(5,7),nrow=2,ncol=1) 
EE
DD
EE%*%DD
# 5) ¿Como podemos definir una matriz 10x10 llena de ceros? 
# R. Se debe utilizar la función "matrix", así como debe utilizarse el comando 
#de repetición, para colocar la cantidad de ceros deseados, indicando el 
#número de filas y columnas. Ver ejemplo a continuación:
XX <- matrix(rep(0,100), nrow=10, ncol=10)
XX
# 6) ¿Como podemos  crear un vector con cien numeros equidistantes en el 
#     intervalo [0,1]? 
# R. Puede emplearse el comando de secuencia "seq"
seq(0,1, len=100)
# 7) Mencione tres tipos de datos comunmente encontrados en R
# R. Se pueden mencionar los siguientes: numéricos, strings y booleanos
a <- 5 #Ejemplo de valor numérico
class(a)
b <- FALSE #Ejemplo de valor booleano
class(b)
c<- "Hola mundo" #Ejemplo de valor string
class(c)
# 8) ¿Que libreria nos permite cargar archivos de Excel en R?
# R. Se encuentras algunas como las siguientes: readxl, ezpickr, tablaxlsx, así
#como utilizar la interfaz de Rstudio.

# Instalemos la libreria "readxl" 
install.packages("readxl")
library(readxl)

# Archivo xls
datos.desde.xls  <- read_excel("PIB.xls") 
datos.desde.xls
x11(); plot(datos.desde.xls)

# Archivo xlsx
datos.desde.xlsx <- read_excel("PIB.xlsx",sheet="PIB") 
datos.desde.xlsx
x11(); plot(datos.desde.xlsx)

# 9) ¿Cual es el coeficiente de correlacion entre el numero de peliculas  en que
#     aparecio Nicolas Cage y el numero de mujeres editoras de la revista 
#     "Harvard Law Review" entre 2005 y 2009?

nc<-c(2,3,4,1,4) #se define la variable que contiene las películas de Nicolas C.
me<-c(9,14,19,12,19)#Contiene el número de editoras de Harvard
df<-data.frame(nc,me)#Convierte las variables en un data frame
df<-data.frame(Nicolas = nc, Harvard =me)#Se renombraron los vectores columna
df
años<-c(2005,2006,2007,2008,2009) #Contiene los años investigados
row.names(df)<-años #Sustitutye la numeración predeterminada por los años
df

df$Nicolas #Nos da los valores de la columna descrita
attach(df) #Sirve para convertir los datos del dataframe en variables.
Nicolas 
df[1,1] #Busca valores en la posición indicada

summary(df)
x11(); plot(df) 

reg<-lm(Harvard ~ Nicolas, data=df) #Regresión del dataframe generado
abline(reg) #Agrega lineas rectas a una gráfica
reg
summary(reg) #Nos da un resumen de la regresión.
# R.La correlación fue de 0.855447

# 10) Haga un grafico de barras ilustrando los balones de oro ganados por 
#     Cristiano, Messi, Cruyff, Iniesta y Ronaldinho.
# R. Se puede emplear el siguiente proceso
x <- c(5,6,3,0,1)
names(x) <- c("Cristiano","Messi","Cruyff", "Iniesta","Ronaldinho") #Asigna 
#valores a los nombres de la variable x
x
x11(); barplot(x)

# 11) ¿Si la probabilidad de que Falcao se lesione es 0.2, cuantos partidos 
#      podemos esperar que juegue antes de lesionarse?
# R. A través de una simulación Montecarlo, como se muestra a continuación:
num.simulaciones <- 2000
num.partidos     <- rep(0,num.simulaciones)

for (i in 1:num.simulaciones){
    partidos  <- 0 # Comencemos a contar partidos jugados
    lesion    <- 0 # Y empezemos la temporada sin lesiones
    while (lesion==0){ # Mientras no se lesione
        partidos <- partidos + 1        # Cuente el numero de partidos
        golpe   <- runif(1)            # Lance una moneda
        if (golpe <= 0.2) lesion <- 1  # Verifique si Falcao se lesiona
    }
    # Guarda el numero de partidos que Falcao jugo antes de lesionarse
    num.partidos[i] <- partidos 
}

print(mean(num.partidos)) 


################################################################################
# 2) Mi primera funcion 
################################################################################
graphics.off(); rm(list=ls());
# Adjunto encontrara el archivo "CPI.xlsx" con datos mensuales del indice de 
# precios al consumidor de Guatemala (El primer dato es inventado)

# A continuacion, escriba un codigo que haga lo siguiente:
# 1) Cargue los datos del archivo CPI.xlsx (incluya los codigos necesarios para 
#    descargar y cargar un paquete, si lo necesita)
install.packages("installr")
install.packages("readxl")
library(readxl)
#Código para abrir el documento en excel
setwd("C:/Users/in_cap02/Desktop") #Se recomienda que al momento de ejecutar
#este código se seleccione la ruta donde se encuentre el archivo excel y se
#establezca como directorio de trabajo
getwd()
datos.desde.xls  <- read_excel("CPI.xlsx") 
datos.desde.xls

# 2) Cree una variable inflacion.mensual que contenga la inflacion mensual de 
#    Guatemala calculada usando los datos del punto anterior.
attach(datos.desde.xls)
CPI <- matrix(c(CPI))

CPI
inflacion=c(rep(0,nrow(CPI)))

for (i in 2:301){
    inf=(CPI[i,]/CPI[i-1,]-1)
    inflacion[i]=inf
}
inflacion


# 3) Defina una funcion que calcule la inflacion trimestral usando el PROMEDIO 
#    de cada trimestre
nrow(Inflacion) #Determina el número de filas de la matriz Inflacion
trimes <- c(rep(0,100))
promtrim <- function(){
    pos=1
    cont = 2
    while (cont < 301){
        promedio = (((inflacion[cont] + inflacion[cont+1] + inflacion[cont+2])/3)*100)
        trimes[pos]=promedio
        cont <- cont + 3
        pos<-pos+1}
    return(trimes)
}
promtrim()



# 4) Defina otra funcion que calcula la inflacion trimestral usando el 
#    ULTIMO MES de cada trimestre
trimes <- c(rep(0,100))
promtrim2 <- function(){
    pos=1
    cont = 2
    while (cont < 301){
        promedio = (((inflacion[cont+2]))*100)
        trimes[pos]=promedio
        cont <- cont + 3
        pos<-pos+1}
    return(trimes)
}
promtrim2()
# 5) Use las anteriores funciones para calcular las variables 
#    "inflacion.trimestral.promedio" y "inflacion.trimestral.findemes" 
#    correspondientes a cada metodo
inflacion.trimetral.promedio = promtrim()
inflacion.trimestral.findemes = promtrim2()

inflacion.trimetral.promedio
inflacion.trimestral.findemes
# 6) En una misma figura, muestre la grafica de cada una de las dos variables
#    calculadas en el paso anterior para comparar los resultados de cada metodo
x11(); plot(inflacion.trimetral.promedio, col="blue",type="l",
xlab="Tiempo",ylab="Inflación Trimestral",
main="Inflación trimestral") 
lines(inflacion.trimestral.findemes, col = "dark green")
#
# Pista: Los resultados deven ser iguales a los de la hoja ".csv" en el 
# mismo archivo CPI


################################################################################
# 3) Github e intereses de ustedes
################################################################################

# 1) Lea esta breve introduccion a Github
# https://conociendogithub.readthedocs.io/en/latest/

# 2) Cree una cuenta de github y escriba aqui el usuario de cada integrante
# del grupo:
# -José Domingo de León Miranda - Jose-1993
# -Hugo Leonel Orellana Alfaro - hugoleoalf
# -Diego Ignación Sánchez del Cid - diegoignacio95
#
# 3) Escriba aca las areas de interes en economia de cada integrante
# (microeconomia teorica, macroeconomia aplicada, macroeconometria,
#  microeconometria, econometria, finanzas, etc... )
# -José Domingo de León Miranda - Finanzas y macroeconomía aplicada
# -Hugo Leonel Orellana Alfaro - Finanzas
# -Diego Ignacio Sánchez del Cid - Finanzas y series de tiempo
# 4) Escriba aca algun topico de interes que le llamaria la atencion aprender
#    durante el curso
# -José Domingo de León Miranda - Pronósticos
# -Hugo Leonel Orellana Alfaro - Dominar el uso de data frame
# -Diego Ignacio Sánchez del Cid - Pronósticos




