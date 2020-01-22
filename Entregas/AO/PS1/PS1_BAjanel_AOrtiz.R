# Lista de ejercicios 1
# Introduccion a R
#
# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala

# Integrantes: Byeron Ajanel Gonzales
#              Andres M. Ortiz Flores


################################################################################
# 1)  Control de Lectura
################################################################################

# Las siguientes preguntas estan relacionadas con la forma de realizar distintas
# operaciones en R

# Basado en lo mostrado en la clase y los resultados de los "scripts" usados,
# responda las siguientes preguntas:

# 1) ¿Que comando de R podemos usar para limpiar el escritorio?

  # R.      Ctrl + L

# 2) ¿Que comando de R podemos uar para cerrar las ventanas de graficas activas?

  # R.      graphics.off()

# 3) ¿Como podemos realizar producto matricial?

  # R.      AA%*%BB donde AA es una matriz de m*n y BB una matriz de n*p

# 4) ¿Como podemos realizar producto punto?
  
  # R.      Se utiliza el comando AA*t(BB) donde AA es una matriz de 1*n 
  #         y t(BB) una matriz de n*1 

# 5) ¿Como podemos definir una matriz 10x10 llena de ceros? 

  # R.      AA <- matrix(c(0:0),nrow=10,ncol=10)

# 6) ¿Como podemos  crear un vector con cien numeros equidistantes en el 
#     intervalo [0,1]? 
    
  # R.      seq(0,1,len=100) 

# 7) Mencione tres tipos de datos comunmente encontrados en R

  # R.      Numéricos, texto (Que son los strings) y valores lógicos

# 8) ¿Que libreria nos permite cargar archivos de Excel en R?

  # R.      Primero se debe descargar la libreria 
            # Instalemos la libreria "readxl" con el comando 
                      install.packages("readxl")
            # luego se activa con el comando 
                      library(readxl)
            # Luego se abre el Archivo xls
                      datos.desde.xls  <- read_excel("CPI.xlsx") 
                      datos.desde.xls

# 9) ¿Cual es el coeficiente de correlacion entre el numero de peliculas  en que
#     aparecio Nicolas Cage y el numero de muejeres editoras de la revista 
#     "Harvard Law Review" entre 2005 y 2009?
  # R.

Nicolas_Cage<-c(2,3,4,1,4)
Mujeres_Editoras<-c(9,14,19,12,19)
corr_espuria<-data.frame(Nicolas_Cage,Mujeres_Editoras)
mode(corr_espuria)
cor(corr_espuria)

              # R. 0.8554467

# 10) Haga un grafico de barras ilustrando los balones de oro ganados por 
#     Cristiano, Messi, Cruyff, Iniesta y Ronaldinho.
  
  # R. 

x11()
plot(x,y)

x<-c(5,6,3,0,1)
names(x)<- c("Cristiano","Messi","Cryuff","Iniesta","Ronaldinho")
x
x11(); barplot(x)


# 11) ¿Si la probabilidad de que Falcao se lesione es 0.2, cuantos partidos 
#      podemos esperar que juegue antes de lesionarse?

  # R. 5.235

num.simulaciones <- 1000
num.partidos     <- rep(0,num.simulaciones)
 
for (i in 1:num.simulaciones){
   partidos  <- 0 
   lesion    <- 0 
   while (lesion==0){ 
     partidos <- partidos + 1        
     lesion   <- runif(1)           
     if (lesion <= 0.2) lesion <- 1 
   }
   num.partidos[i] <- partidos 
 }
 
print(mean(num.partidos))
[1] 5.235
 

################################################################################
# 2) Mi primera funcion 
################################################################################

# Adjunto encontrara el archivo "CPI.xlsx" con datos mensuales del indice de 
# precios al consumidor de Guatemala (El primer dato es inventado)

# A continuacion, escriba un codigo que haga lo siguiente:
# 1) Cargue los datos del archivo CPI.xlsx (incluya los codigos necesarios para 
#    descargar y cargar un paquete, si lo necesita)
graphics.off(); rm(list=ls())
install.packages("readxl")
library(readxl)

setwd("C:/Users/Andres/Desktop/Programacion II/Problemsets/PS1")
datosCPI  <- read_excel("CPI.xlsx") 
datosCPI

# 2) Cree una variable inflacion.mensual que contenga la inflacion mensual de 
#    Guatemala calculada usando los datos del punto anterior.

inflacion.mensual =c(rep(0,nrow(300)))

for(i in datosCPI[2:301,2]){
  inflacion=((datosCPI[i,2]-datosCPI[i-1,2])/datosCPI[i-1,2])*100
  inflacion.mensual[i]=inflacion
}
inflacion.mensual

# 3) Defina una funcion que calcule la inflacion trimestral usando el PROMEDIO 
#    de cada trimestre
inflacion.trimestral <- function(datosCPI)
inflacion.trimestral =c(rep(0,nrow(100)))  
for(i in datosCPI[1:301,2]){
  inflacion=(datosCPI[i,2]+datosCPI[i+1,2]+datosCPI[i+2,2])/3])*100
  i=i+3
  inflacion.trimestral[i]=inflacion
}
return inflacion.trimestral
# 4) Defina otra funcion que calcula la inflacion trimestral usando el 
#    ULTIMO MES de cada trimestre

inflacion.trimultimo.mes <- function(datosCPI)
  trimultimo.mes =c(rep(0,nrow(100))) 
  for(i in datosCPI[3:301,2]){
    inflacion=((datosCPI[i,2]-datosCPI[i-1,2])/datosCPI[i-1,2])*100
    i=i+3
    inflacion.trimultimo.mes[i]=inflacion
  }

return inflacion.trimultimo.mes
# 5) Use las anteriores funciones para calcular las variables 
#    "inflacion.trimestral.promedio" y "inflacion.trimestral.findemes" 
#    correspondientes a cada metodo

# 6) En una misma figura, muestre la grafica de cada una de las dos variables
#    calculadas en el paso anterior para comparar los resultados de cada metodo
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
# -    brag01   (Byron Ajanel)
# -    AndOrt88 (Andres Ortiz)
# -
#
# 3) Escriba aca las areas de interes en economia de cada integrante
# (microeconomia teorica, macroeconomia aplicada, macroeconometria,
#  microeconometria, econometria, finanzas, etc... )
#     Area financiera  
#     microeconometria(Con aplicaciones a la produccion en la industria o area comercial)
#
# 4) Escriba aca algun topico de interes que le llamaria la atencion aprender
#    durante el curso:
#    
#    1. Modelo Econometrico X13 ARima
#    2. Modelo VEC
#    3. Paquetes relacionados al inventario
#    4. Simulación Montecarlo  




