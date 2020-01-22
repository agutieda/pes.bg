# Lista de ejercicios 1
# Introduccion a R
#
# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala

# Integrantes: Marybeth Rodríguez, Helen Ávila, María Fernanda López


################################################################################
# 1)  Control de Lectura
################################################################################

# Las siguientes preguntas estan relacionadas con la forma de realizar distintas
# operaciones en R

# Basado en lo mostrado en la clase y los resultados de los "scripts" usados,
# responda las siguientes preguntas:

# 1) ¿Que comando de R podemos usar para limpiar el escritorio?
# R. rm(list=ls()) o ctrl + l

# 2) ¿Que comando de R podemos usar para cerrar las ventanas de graficas activas?
# R. graphics.off()

# 3) ¿Como podemos realizar producto matricial?
# R. AA%**%BB         # Multiplicacion de matrices
#    BB%**%AA         # Multiplicacion de matrices

# 4) ¿Como podemos realizar producto punto?
# R. AA%*%BB        # Producto punto de matrices

# 5) ¿Como podemos definir una matriz 10x10 llena de ceros? 
# R. AA <- matrix(c(0),nrow=10,ncol=10)         # Matriz 10x10

# 6) ¿Como podemos  crear un vector con cien numeros equidistantes en el 
#     intervalo [0,1]? 
# R. seq(0,1,len=100)  # P un vector con 100 elementos equidistantes entre 0 y 1

# 7) Mencione tres tipos de datos comunmente encontrados en R
# R. Tipo numérico, Tipo texto(String), Valores lógicos (boolenas)

# 8) ¿Que libreria nos permite cargar archivos de Excel en R?
# R. libreria "readxl"

# 9) ¿Cual es el coeficiente de correlacion entre el numero de peliculas  en que
#     aparecio Nicolas Cage y el numero de mujeres editoras de la revista 
#     "Harvard Law Review" entre 2005 y 2009?
#    # No. de peliculas en que aparecio Nicolas Cage entre 2005 y 2009
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
#attach(Correlacion.Espurea)
#nicolas.cage

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

# Finalmente, podemos usar lm() para correr una regresion usando el data frame
# y anadimos una linea a la grafica de los datos usando la funcion abline()
mi.regresion <- lm(mujeres.editoras ~ nicolas.cage, data=Correlacion.Espurea)
abline(mi.regresion)

# Note que la funcion lm devuelve una lista como output
mi.regresion

sqrt(0.7318)
0.8554531

# 10) Haga un grafico de barras ilustrando los balones de oro ganados por 
#     Cristiano, Messi, Cruyff, Iniesta y Ronaldinho.
x <- c(5,6,3,1)
names(x) <- c("Cristiano","Messi","Cruiyff","Ronaldinho") 
x
x11(); barplot(x)

#  ¿Si la probabilidad de que Falcao se lesione es 0.2, cuantos partidos 
#      podemos esperar que juegue antes de lesionarse?
# num.simulaciones <- 1000
num.partidos     <- rep(0,num.simulaciones)

for (i in 1:num.simulaciones){
  partidos  <- 0 # Comencemos a contar partidos jugados
  lesion    <- 0 # Y empezemos la temporada sin lesiones
  while (lesion==0){ # Mientras no se lesione
    partidos <- partidos + 1        # Cuente el numero de partidos
    moneda   <- runif(1)            # Lance una moneda
    if (moneda <= 0.1) lesion <- 1  # Verifique si Falcao se lesiona
  }
  # Guarda el numero de partidos que Falcao jugo antes de lesionarse
  num.partidos[i] <- partidos 
}

# Promedio de partidos seguidos que podemos que juega Falcao antes de lesionarse
print(mean(num.partidos)) 


# Si combinamos el uso de loops con funciones, podemos definir funciones mucho
# mas elaboradas que las definidas hasta ahora

# A contiuacion, una funcion para calcular el numero de partidos que juega 
# Falcao antes de lesionarse, dada una probabilidad incondicional de lesion

Partidos.Falcao <- function(p_lesion) {
  num.simulaciones <- 1000
  num.partidos     <- rep(0,num.simulaciones)
  
  # Repetir el experimento mil veces
  for (i in 1:num.simulaciones){
    partidos  <- 0
    lesion    <- 0
    while (lesion==0){
      partidos <- partidos + 1         
      moneda   <- runif(1)             
      if (moneda <= p_lesion) lesion <- 1
    }
    num.partidos[i] <- partidos
  }
  print(mean(num.partidos))
}


# Ahora podemos usar la funcion para repetir el calculo con otras probabilidades
Partidos.Falcao(0.2)
#El promedio de partidos antes de lesionarse es aproximadamente de 5
################################################################################
# 2) Mi primera funcion 
################################################################################

# Adjunto encontrara el archivo "CPI.xlsx" con datos mensuales del indice de 
# precios al consumidor de Guatemala (El primer dato es inventado)



# A continuacion, escriba un codigo que haga lo siguiente:
# 1) Cargue los datos del archivo CPI.xlsx (incluya los codigos necesarios para 
#    descargar y cargar un paquete, si lo necesita)

install.packages("readxl") #Para poder abrir archivos desde Excel se necesita instalar la libreria "readxl".
library(readxl)

Data <-read_excel("CPI.xlsx",sheet="Main")
CPI.datos <- read_excel("CPI.xlsx",sheet="Main")$CPI #Datos especificos de CPI. 
numero.datos= lengths(Data)
numero.datos[2] #Numero de datos disponibles de CPI. 

# 2) Cree una variable inflacion.mensual que contenga la inflacion mensual de 
#    Guatemala calculada usando los datos del punto anterior.


inflacion.mensual <- rep(0,numero.datos[2]-1)

for (i in 1:numero.datos[2]-1){ 
  
  inflacion.mensual[i] <- ((CPI.datos[i+1]-CPI.datos[i])/CPI.datos[i])*100
  }

inflacion.mensual 


# 3) Defina una funcion que calcule la inflacion trimestral usando el PROMEDIO 
#    de cada trimestre

Inflacion_TRIM_PROM <- function(data,cant.datos) {  #Recibe la data y el numero de datos a estudiar
  
  inflacion.trimestral <- rep(1,cant.datos/3)
  
  for (i in seq(1,cant.datos/3)){ 
    
    inflacion.trimestral[i] <- mean(inflacion.mensual[(i*3-2):(i*3)])
  }
  return (inflacion.trimestral)
}


# 4) Defina otra funcion que calcula la inflacion trimestral usando el 
#    ULTIMO MES de cada trimestre

Inflacion_TRIM_FM <- function(data,cant.datos) {  #Recibe la data y el numero de datos a estudiar
  
  inflacion.trimestral <- rep(0,cant.datos/3)
  
  for (i in seq(1,cant.datos/3)){ 
    
    inflacion.trimestral[i] <- data[i*3]
  }
  return (inflacion.trimestral)
}


# 5) Use las anteriores funciones para calcular las variables 
#    "inflacion.trimestral.promedio" y "inflacion.trimestral.findemes" 
#    correspondientes a cada metodo

Inflacion_TRIM_PROM(inflacion.mensual,numero.datos[2])

inflacion.trimestral.promedio = Inflacion_TRIM_PROM(inflacion.mensual,numero.datos[2])

Inflacion_TRIM_FM(inflacion.mensual,numero.datos[2])  #Prueba de la funcion de Inflacion Trimestral. (fin de mes)

inflacion.trimestral.findemes = Inflacion_TRIM_FM(inflacion.mensual,numero.datos[2]) 


# 6) En una misma figura, muestre la grafica de cada una de las dos variables
#    calculadas en el paso anterior para comparar los resultados de cada metodo
#
# Pista: Los resultados deven ser iguales a los de la hoja ".csv" en el 
# mismo archivo CPI

x11(); plot(inflacion.trimestral.promedio,
                                          col="purple",
                                          type="p",
                                          xlab="Trimestre",ylab="Inflación Trimestral Promedio",
                                          main="Grafica1")
                                                             

x11(); plot(inflacion.trimestral.findemes,
                                          col="purple",
                                          type="p",
                                          xlab="Trimestre",ylab="Inflación Trimestral Fin de Mes",
                                          main="Grafica2")


################################################################################
# 3) Github e intereses de ustedes
################################################################################

# 1) Lea esta breve introduccion a Github
# https://conociendogithub.readthedocs.io/en/latest/

# 2) Cree una cuenta de github y escriba aqui el usuario de cada integrante
# del grupo:
# -mrv1992
# -HelenSarai
# -MaFer92
#
# 3) Escriba aca las areas de interes en economia de cada integrante
# (microeconomia teorica, macroeconomia aplicada, macroeconometria,
#  microeconometria, econometria, finanzas, etc... )
# -Marybeth Rodríguez (microeconomía teórica)
# -Helen Ávila(microeconomía teórica)
# -María Fernanda López (Econometría)
# 4) Escriba aca algun topico de interes que le llamaria la atencion aprender
#    durante el curso
# Series de tiempo y modelos VAR





