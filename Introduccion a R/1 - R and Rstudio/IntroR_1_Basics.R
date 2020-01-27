# Introduccion a R: 
# Parte 1: R + RStudio
#
# Angelo Gutierrez Daza
# 2020
#
# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala
#
# Codigo probado utilizando la version 3.6.2 de R

################################################################################
# 1) Archivos de R: Scripts                           
################################################################################

# Este archivo es un "script": Contiene una lista de comandos que pueden
# ejecutarse uno a uno o todos al mismo tiempo.
#
# Podemos usar el simbolo "#" para escribir comentarios 
# Todo lo que se escriba despues del "#" sera tomado por R como un comentario y 
# lo ignorara a la hora de compilar codigo
#
# Los comentarios pueden ir casi en cualquier parte del script
#
# En RStudio, podemos utilizar "CTRL+SHIFT+C" para comentar y descomentar una o
# varias lineas


################################################################################
# 2) Dar instrucciones a R
################################################################################

# Los comandos son instrucciones que damos a R
# Se pueden ingresar directamente al "command window" o correr desde este script
# En R-Studio, puede correr la linea donde se encuentra el cursor con CTRL+ENTER
# Se puede correr mas de una linea si las resaltamos y usamos CTRL+ENTER
# Tambien puede correr el archivo completo con CTRL+SHIFT+ENTER

# Antes de comenzar, revise las diferentes pestas, opciones y menus 
# desplegables del editor para conocerlo mejor

# Los comandos se separan por un ";" o por una nueva linea
# Si un comando queda incompleto al ingresarlo, el "command window" mostrara
# un "+"

# Primer comando: Imprimir en la pantalla "Hello World"
print("Hello World")

# Segundo comando: Crear la variable "a" cuyo valor es "1"
a <- 1

# Tercer comando: Crear el vector fila A = (1,2) 
A  <- cbind(1,2) 

# Podemos usar la tecla "flecha arriba" en el "command window" para ver los
# comandos recientemente utilizados

# En R-studio, podemos tambien usar CTRL+L para limpiar la pantalla

# Es importante acostumbrarnos a modificar y dar instrucciones desde scripts en 
# lugar de ingresar los comandos directamente al command window. Esto hara mucho
# mas facil modificar un analisis, volverlo a ejecutar, replicarlo y expandirlo

################################################################################
# 3) Workspace
################################################################################

# Podemos usar en cualquier momento el comando ls() para ver que variables 
# existen en el workspace
ls()  

# Ademas, podemos usar el comando rm() para eliminar una variable del workspace
rm(a) 
ls()

# Eliminar varias variables
a <- 1
b <- 2
c <- 3
rm(b,c) 
ls()

# O limpiar todo el workspace
rm(list=ls()) 
ls()

################################################################################
# 4) Directorio de Trabajo
################################################################################

# El computador corre R y cualquier otro proceso desde un directorio de trabajo
# R no es la exepcion y sera este directorio donde R busque de forma
# predeterminada cualquier archivo que se desee cargar y donde tambien guardara 
# cualquier archivo que se creee

# Podemos revisar explicitamente nuestro directorio de trabajo actual usando 
# el comando getwd()
getwd()

# Tambien podemos asignarlo a una variable temporal
tempDir <- getwd()
tempDir

# Si deseamos cambiar el directorio de trabajo actual, podemos usar setwd()
setwd("./OtroDirectorio") # Un subdirectorio del directorio actual
getwd()

# De forma alternativa, podemos dar el path completo
#setwd("C:/Users/agutieda/Desktop/") 
setwd(tempDir) 
getwd()

# De forma alternativa, podemos utilizar la interface de RStudio

################################################################################
# 5) Librerias
################################################################################

# Mas adelante veremos que R cuenta con una multitud de funciones que vienen 
# instaladas por defecto
#
# Uno de los mayores atractivos de R es la gran cantidad d funciones disponibles
# gratis en diferentes librerias y paquetes que se pueden descargar de internet

# A lo largo del curso descargaremos varias librerias que seran de utilidad para
# los objetivos del curso pero hay muchas mas que pueden ser utiles en algun 
# momento de sus carreras

# A continuacion se muestra como instalar librerias de dos formas diferentes:

### a) Descargar liberias disponibles en CRAN

# "The Comprehensive R Archive Network" es una red de repositorios donde se
# suele encontrar la version mas reciente de la gran mayoria de librerias para
# R, asi como la version mas actual del software
#
# La lista completa de funciones y su documentacion se puede consultar en:
# https://cran.r-project.org/web/packages/available_packages_by_name.html

# Tambien podemos utilizar el siguiente comando
a <- available.packages()
head(rownames(a), 3)  # Mostrar el nombre de los primeros tres paquetes

# A principios de 2017, CRAN contaba ya con 10.000 librerias!
# Podemos consultar una lista de librerias por topico en: 
# https://cran.r-project.org/web/views/

# Para descargar una libreria desde CRAN, basta con usar el install.packages()
install.packages("installr")

# Este paquete nos permite actualizar nuestra version de R en Windows usando 
# el comando updateR()
#
# Pero no basta con instalarlo. Hay que cargar la libreria usando library()
library(installr)
updateR()

# Tambien podemos instalar varias librerias al mismo tiempo
install.packages(c("dplyr", "purrr"))

### b) Descargar liberias disponibles en GitHub

# Tambien podemos descargar librerias desde GitHub
#
# Esta plataforma de desarrollo colaborativo es popular entre muchos 
# desarrolladores y algunas de las librerias disponibles en esta no se 
# encuentran disponibles en CRAN

# Para descargar librerias desde Github, debemos descargar primero "devtools"
install.packages("devtools")

# Ahora podemos usar install_githib() para descargar librerias 
# Para ilustrarlo, descargaremos la libreria "Quandl", la cual es bastante util
# para descargar informacion de variables macroeconomicas y financieras
library(devtools)
install_github("quandl/quandl-r")

# Ahora utilizamos esta libreria para descargar la serie del PIB de USA
library(Quandl)
gdpUS = Quandl("FRED/GDP")
plot(gdpUS)

# Podemos consultar los "tokens" de muchas otras series disponibles en:
# https://www.quandl.com/search

