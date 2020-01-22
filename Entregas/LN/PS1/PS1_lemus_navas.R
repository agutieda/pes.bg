# Lista de ejercicios 1
# Introduccion a R
#
# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala

# Integrantes: 
    # Elmer Humberto Lémus Flores
    # Erwin Roberto Navas Solis

################################################################################
# 1)  Control de Lectura
################################################################################

# Las siguientes preguntas estan relacionadas con la forma de realizar distintas
# operaciones en R

# Basado en lo mostrado en la clase y los resultados de los "scripts" usados,
# responda las siguientes preguntas:

# 1) ¿Que comando de R podemos usar para limpiar el escritorio?
    # R. Para limpiar el espacio de trabajo de las variables ya ingresadas
    # Utilizamos el siguiente comando:

rm(list=ls())

    # Este comando lo que hace es tomar los valores de ls() y los toma como una
    # Lista, posteriormente los borra.

# 2) ¿Que comando de R podemos uar para cerrar las ventanas de graficas activas?
    # R. Para cerrar todas las graficas en el escritorio usamos:

graphics.off()

# 3) ¿Como podemos realizar producto matricial?
    # R. La multiplicación de matrices es:

Matriz_1 %*% Matriz_2

# 4) ¿Como podemos realizar producto punto?
    # R. Dado que es la multiplicación de elemento por elemento:

Matriz_1 * Matriz_2

# 5) ¿Como podemos definir una matriz 10x10 llena de ceros? 
    # R. 

A <- matrix(0,nrow=10,ncol=10)

# 6) ¿Como podemos  crear un vector con cien numeros equidistantes en el 
#     intervalo [0,1]? 
    # R. 

seq(0,1,len=100)

# 7) Mencione tres tipos de datos comunmente encontrados en R
    # R. 

### Tipo 1: Numerico 
a <- c(1,15)
mode(a)
class(a)

### Tipo 2: Texto
b <- "Programación 2"
mode(b)
class(b)

### Tipo 3: Valores Logicos
# Los cuales pueden ser verdadero o Falso
x <- TRUE
y <- FALSE
mode(x)   
class(x)

# 8) ¿Que libreria nos permite cargar archivos de Excel en R?
    # R. 

# Instalemos la libreria "readxl" 
install.packages("readxl")
library(readxl)

# Archivo xls
datos.desde.xls  <- read_excel("CPI.xls") 
datos.desde.xls
x11(); plot(datos.desde.xls)

# Archivo xlsx
datos.desde.xlsx <- read_excel("CPI.xlsx",sheet="Main") 
datos.desde.xlsx
x11(); plot(datos.desde.xlsx)

# 9) ¿Cual es el coeficiente de correlacion entre el numero de peliculas  en que
#     aparecio Nicolas Cage y el numero de muejeres editoras de la revista 
#     "Harvard Law Review" entre 2005 y 2009?
# R.

# No. de peliculas en que aparecio Nicolas Cage entre 2005 y 2009
NC <- c(2,3,4,1,4)     

# No. de muejeres editoras en "Harvard Law Review" entre 2005 y 2009
ME <- c(9,14,19,12,19) 

# Utilizando MASS, sacamos el coeficiente de correlación.
library(MASS)
cor(x=NC, y=ME)

# 10) Haga un grafico de barras ilustrando los balones de oro ganados por 
#     Cristiano, Messi, Cruyff, Iniesta y Ronaldinho.
    # R. 

x <- c(5,6,3,0,1)
names(x) <- c("Cristiano","Messi","Cruiyff","Iniesta","Ronaldinho") 
x
x11(); barplot(x)

# 11) ¿Si la probabilidad de que Falcao se lesione es 0.2, cuantos partidos 
#      podemos esperar que juegue antes de lesionarse?
    # R. 

num.simulaciones <- 10000
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

rm(list=ls())
graphics.off()

# A continuacion, escriba un codigo que haga lo siguiente:
# 1) Cargue los datos del archivo CPI.xlsx (incluya los codigos necesarios para 
#    descargar y cargar un paquete, si lo necesita)

library(readxl)
datos <- read_excel(path = "CPI.xlsx", sheet = "Main")
datos

# 2) Cree una variable inflacion.mensual que contenga la inflacion mensual de 
#    Guatemala calculada usando los datos del punto anterior.

infla.mensual = rep(datos[2],1)
inflacion.mensual = rep(NaN,300,1)

for (i in 2:301){ 
    mensual = infla.mensual$CPI[i]/ infla.mensual$CPI[i-1]*100-100
    inflacion.mensual[i-1] <- mensual
    }

inflacion.mensual

# 3) Defina una funcion que calcule la inflacion trimestral usando el PROMEDIO 
#    de cada trimestre

f_prom <- function(x) {
    infla.prom = rep(NaN,100,1) 
    for (i in 1:100){infla.prom[i] <- mean(inflacion.mensual[(i*3-2):(i*3)])}
    return(infla.prom)}
    
f_prom(inflacion.mensual)

# 4) Defina otra funcion que calcula la inflacion trimestral usando el 
#    ULTIMO MES de cada trimestre

f_trim <- function(x) {
    infla.trim = rep(NaN,100,1) 
    for (i in 1:100){infla.trim[i] <- (inflacion.mensual[(i*3)])}
    return(infla.trim)}

f_trim(inflacion.mensual)



# 5) Use las anteriores funciones para calcular las variables 
#    "inflacion.trimestral.promedio" y "inflacion.trimestral.findemes" 
#    correspondientes a cada metodo

inflacion.trimestral.promedio = f_prom(inflacion.mensual)
inflacion.trimestral.promedio

inflacion.trimestral.findemes = f_trim(inflacion.mensual)
inflacion.trimestral.findemes

# 6) En una misma figura, muestre la grafica de cada una de las dos variables
#    calculadas en el paso anterior para comparar los resultados de cada metodo
#

x11(); plot(inflacion.trimestral.promedio, type="l", 
            main="Inflación intermensual", xlab="Trimestre",
            ylab="Tasa de variación", xlim=c(0,100), ylim=c(-2,8))
lines(inflacion.trimestral.findemes,col="blue")
legend(x="topright", legend = c("Serie promedio", "Serie último mes"), 
       fill = c("black","blue"))

jpeg("lemus_navas.jpg") 

plot(inflacion.trimestral.promedio, type="l", 
            main="Inflación intermensual", xlab="Trimestre",
            ylab="Tasa de variación", xlim=c(0,100), ylim=c(-2,8))
lines(inflacion.trimestral.findemes,col="blue")
legend(x="topright", legend = c("Serie promedio", "Serie último mes"), 
       fill = c("black","blue"))

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
# - Elmer Humberto Lémus Flores     /   Usuario:    elmer204
# - Erwin Roberto Navas Solis       /   Usuario:    erwinnavas
#
# 3) Escriba aca las areas de interes en economia de cada integrante
# (microeconomia teorica, macroeconomia aplicada, macroeconometria,
#  microeconometria, econometria, finanzas, etc... )
# - Elmer Humberto Lémus Flores
#       Modelos macroeconómicos
#       Pronósticos
#       Econometría
#       Simulaciones
#
# - Erwin Roberto Navas Solis
#       Estadisticas macroeconómicas
#       Cuentas Nacionales
#       Pronósticos
#
# 4) Escriba aca algun topico de interes que le llamaria la atencion aprender
#    durante el curso
#       Econometría
#       Simulación
#       Estimación