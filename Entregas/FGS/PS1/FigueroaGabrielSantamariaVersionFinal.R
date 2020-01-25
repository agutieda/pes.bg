# Lista de ejercicios 1
# Introduccion a R
#
# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala

# Integrantes: 
# Polo Figueroa
# David Gabriel
# Pablo Santa Maria


################################################################################
# 1)  Control de Lectura
################################################################################

# Las siguientes preguntas estan relacionadas con la forma de realizar distintas
# operaciones en R

# Basado en lo mostrado en la clase y los resultados de los "scripts" usados,
# responda las siguientes preguntas:

# 1) ¿Que comando de R podemos usar para limpiar el escritorio?
rm(list=ls())

# 2) ¿Que comando de R podemos uar para cerrar las ventanas de graficas activas?
graphics.off() 

# 3) ¿Como podemos realizar producto matricial?
AA <- matrix(c(1,2),nrow=2,ncol=1)         # Matriz 2x1
BB <- matrix(c(1,2),nrow=1,ncol=2)
AA%*%BB

# 4) ¿Como podemos realizar producto punto?
BB%*%AA

# 5) ¿Como podemos definir una matriz 10x10 llena de ceros? 
matrix(0,10,10)

# 6) ¿Como podemos  crear un vector con cien numeros equidistantes en el 
#     intervalo [0,1]? 
seq(0,1,len=100) 

# 7) Mencione tres tipos de datos comunmente encontrados en R
#  "numeric", "character" , "logical"

# 8) ¿Que libreria nos permite cargar archivos de Excel en R?
# readxl

# 9) ¿Cual es el coeficiente de correlacion entre el numero de peliculas  en que
#     aparecio Nicolas Cage y el numero de muejeres editoras de la revista 
#     "Harvard Law Review" entre 2005 y 2009?
NC <- c(2,3,4,1,4)
ME <- c(9,14,19,12,19) 
Correlacion.Espurea <- data.frame(NC,ME)
Correlacion.Espurea <- data.frame(nicolas.cage=NC,mujeres.editoras=ME)
mi.regresion <- lm(mujeres.editoras ~ nicolas.cage, data=Correlacion.Espurea)
R = sqrt(summary(mi.regresion)$r.squared)
R

# 10) Haga un grafico de barras ilustrando los balones de oro ganados por 
#     Cristiano, Messi, Cruyff, Iniesta y Ronaldinho.
x <- c(5,6,3,0,1)
names(x) <- c("Cristiano","Messi","Cruiyff","Iniesta","Ronaldinho") 
barplot(x)

# 11) ¿Si la probabilidad de que Falcao se lesione es 0.2, cuantos partidos 
#      podemos esperar que juegue antes de lesionarse?
num.simulaciones <- 10000
num.partidos     <- rep(0,num.simulaciones)

for (i in 1:num.simulaciones){
    partidos  <- 0 
    lesion    <- 0 
    while (lesion==0){ 
        partidos <- partidos + 1        
        moneda   <- runif(1)            
        if (moneda <= 0.2) lesion <- 1  
    }
    num.partidos[i] <- partidos 
}
mean(num.partidos)

################################################################################
# 2) Mi primera funcion 
################################################################################

# Adjunto encontrara el archivo "CPI.xlsx" con datos mensuales del indice de 
# precios al consumidor de Guatemala (El primer dato es inventado)

# A continuacion, escriba un codigo que haga lo siguiente:
# 1) Cargue los datos del archivo CPI.xlsx (incluya los codigos necesarios para 
#    descargar y cargar un paquete, si lo necesita)
library(readxl)

# 2) Cree una variable inflacion.mensual que contenga la inflacion mensual de 
#    Guatemala calculada usando los datos del punto anterior.
CPI <- read_excel('CPI.xlsx')$CPI
inflacion.mensual<-rep(0,length(CPI)-1)
for (i in 1:length(CPI)-1){
    inflacion.mensual[i]<-(CPI[i+1]-CPI[i])/CPI[i]
}


# 3) Defina una funcion que calcule la inflacion trimestral usando el PROMEDIO 
#    de cada trimestre
trimestral <- function(x){
    inflacion.trimestral = rep(0,100)
    for (i in seq(1,100)){
        inflacion.trimestral[(i)]<-mean(x[(i*3-2):(i*3)])
    }
  return(inflacion.trimestral)  
} 





# 4) Defina otra funcion que calcula la inflacion trimestral usando el 
#    ULTIMO MES de cada trimestre
fin_de_mes <- function(x){
    inflacion.fin_de_mes = rep(0,100)
    for (i in seq){
        inflacion.fin_de_mes[i]<-x[i*3]
    }
    return(inflacion.fin_de_mes)  
} 


# 5) Use las anteriores funciones para calcular las variables 
#    "inflacion.trimestral.promedio" y "inflacion.trimestral.findemes" 
#    correspondientes a cada metodo

inflacion.trimestral.promedio <- trimestral(inflacion.mensual)
inflacion.trimestral.findemes <- fin_de_mes(inflacion.mensual)


# 6) En una misma figura, muestre la grafica de cada una de las dos variables
#    calculadas en el paso anterior para comparar los resultados de cada metodo
plot(inflacion.trimestral.promedio, type = "l", col = "red")
lines(inflacion.trimestral.findemes, type = "l", col = "green")
#
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
# -roolzpolo
# -djgabrielm
# -pablosmr
#
# 3) Escriba aca las areas de interes en economia de cada integrante
# (microeconomia teorica, macroeconomia aplicada, macroeconometria,
#  microeconometria, econometria, finanzas, etc... )
# 
# Polo: high frequency data, econometria
# David: Microeconometria, ciclos economicos
# Pablo: econometria
#
#
# 4) Escriba aca algun topico de interes que le llamaria la atencion aprender
#    durante el curso
#
# Polo: Webscrapping de twitter 
# David: aplicaciones de scikit-learn en procesamiento de imágenes
# Pablo: econometria en R y Python 
#
#
