# Lista de ejercicios 1
# Introduccion a R
#
# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala

# Integrantes:  Mariela Benavides
#               Ernesto Monterroso
#               Allan Santizo


################################################################################
# 1)  Control de Lectura
################################################################################

# Las siguientes preguntas estan relacionadas con la forma de realizar distintas
# operaciones en R

# Basado en lo mostrado en la clase y los resultados de los "scripts" usados,
# responda las siguientes preguntas:

# 1) ¿Que comando de R podemos usar para limpiar el escritorio?
# R. Se utiliza el comando: rm(list=ls())

# 2) ¿Que comando de R podemos uar para cerrar las ventanas de graficas activas?
# R. Se utiliza el comando: graphics.off()

# 3) ¿Como podemos realizar producto matricial?
# R. Se puede utilizar el comando AA%*%BB suponiendo que nuestras matrices son
# AA y BB 

# 4) ¿Como podemos realizar producto punto?
# R. Se puede utilizar el comando AA*BB suponiendo que nuestras matrices son
# AA y BB 

# 5) ¿Como podemos definir una matriz 10x10 llena de ceros? 
# R. y <- matrix(c(0,0),nrow = 10, ncol=10)

# 6) ¿Como podemos  crear un vector con cien numeros equidistantes en el 
#     intervalo [0,1]? 
# R. seq(0,1,len=100)

# 7) Mencione tres tipos de datos comunmente encontrados en R
# R. character, logical, numeric

# 8) ¿Que libreria nos permite cargar archivos de Excel en R?
# R. la librería se llama "readxl"

# 9) ¿Cual es el coeficiente de correlacion entre el numero de peliculas  en que
#     aparecio Nicolas Cage y el numero de muejeres editoras de la revista 
#     "Harvard Law Review" entre 2005 y 2009?
# R.  El coeficiente de correlación es 0.8554467
NC <- c(2,3,4,1,4)     
ME <- c(9,14,19,12,19) 

library(MASS)
coeficiente = cor(x=NC, y=ME)
print(coeficiente)

# 10) Haga un grafico de barras ilustrando los balones de oro ganados por 
#     Cristiano, Messi, Cruyff, Iniesta y Ronaldinho.
# R. 
x <- c(5,6,3,0,1)
names(x) <- c("Cristiano","Messi","Cruiyff","Iniesta","Ronaldinho") 
x
x11(); barplot(x)

# 11) ¿Si la probabilidad de que Falcao se lesione es 0.2, cuantos partidos 
#      podemos esperar que juegue antes de lesionarse?
# R. La media de partidos es 5 antes que Falcao se lesione.

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
install.packages("readxl")
library(readxl)

CPI_Guatemala  <- read_excel("CPI.xlsx")
N <- length((CPI_Guatemala$CPI))

# 2) Cree una variable inflacion.mensual que contenga la inflacion mensual de 
#    Guatemala calculada usando los datos del punto anterior.

inflacion_mensual <- vector(mode="numeric", length=(N-1)) 
                       
for (i in 1:length(CPI_Guatemala$CPI)){
    inflacion_mensual[i] <- (CPI_Guatemala$CPI[(i+1)]/CPI_Guatemala$CPI[i])*100-100
}

print(inflacion_mensual)

# 3) Defina una funcion que calcule la inflacion trimestral usando el PROMEDIO 
#    de cada trimestre

func_1 <- function(x){

    infl_trimestral <- vector(mode="numeric", length=((length(x)-1)/3))
    
    for (i in seq(1,100)){
        infl_trimestral[i] <- mean(x[(i*3-2):(i*3)])
    }
    return(infl_trimestral)
}

# 4) Defina otra funcion que calcula la inflacion trimestral usando el 
#    ULTIMO MES de cada trimestre

func_2 <- function(x){

    ult_trim <- vector(mode="numeric", length=((length(x)-1)/3)) 

    for (i in seq(1,100)){
        ult_trim[i] <- (x[i*3])
    
    }
    return(ult_trim)
}



# 5) Use las anteriores funciones para calcular las variables 
#    "inflacion.trimestral.promedio" y "inflacion.trimestral.findemes" 
#    correspondientes a cada metodo

inflacion_trimestral_promedio <- func_1(inflacion_mensual)
inflacion_trimestral_findemes <- func_2(inflacion_mensual)

# 6) En una misma figura, muestre la grafica de cada una de las dos variables
#    calculadas en el paso anterior para comparar los resultados de cada metodo

x11(); plot(inflacion_trimestral_promedio,type="l",col="magenta",
            xlab="Trimestres desde 1990 hasta 2015",
            ylab="Variación trimestral",
            main="CPI Guatemala")
lines(inflacion_trimestral_findemes,col="blue") 

pdf("comparacion.pdf") 
plot(inflacion_trimestral_promedio,type="l",col="magenta",
     xlab="Trimestres desde 1990 hasta 2015",
     ylab="Variación trimestral",
     main="CPI Guatemala")
lines(inflacion_trimestral_findemes,col="blue")
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
# -BenavidesM
# -Montzamora
# -Asantizo
#
# 3) Escriba aca las areas de interes en economia de cada integrante
# (microeconomia teorica, macroeconomia aplicada, macroeconometria,
#  microeconometria, econometria, finanzas, etc... )
#  finanzas
#  macroeconomia aplicada
#  econometria - series de tiempo
#
# 4) Escriba aca algun topico de interes que le llamaria la atencion aprender
#    durante el curso
#   GGplot2
#




