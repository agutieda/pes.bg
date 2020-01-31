########################################################
# Analisis de Conglomerados
# Metódo K-means

# Cargando la libreria Cluster

rm(list=ls(all.names=TRUE))
graphics.off()
gc()

# install.packages("cluster")
# install.packages("grid")

library(cluster)
library(Matrix)
library(grid)

set.seed(80) # fijamos una semilla 

########################################################
# lo primero que se va a realizar es cargar el documento .csv

Datos <- read.csv("informe_seguros.csv")

########################################################
# un poco de información de los datos:
# a)  El documento tiene variables cualitativas y cuantitativas
# b)  Para este ejemplo sólo se utilizara variables cuantitativas
#     (También se puede utilizar las variables cualitativas pero con
#     ciertas limitaciones, kmeans es un algoritmo basado en distancias) 

# Porque utilizar este analisis de Datos: 
# a)  A que grupo de usuarios nos queremos centrar para venderle los seguros 
# b)  Que tarifa se tiene que cobrar por los seguros

########################################################
#             Preparando el Set de DAtos
########################################################

# Lo primero que se va a realizar es escalar los datos o bien normarlizarlos
# para que ninguna variable tenga más pesos que las otras, sino por ejemplo: la 
# varibale edad tiene más peso que la variable accidente

# Por lo que se va a convertir los datos en escalares

Datos.scale <- as.data.frame(scale(Datos[,5:9])) 

Datos.km <- kmeans(Datos.scale, centers = 4) #Indicamos el numero de cluster o centros
Datos.km
# Ahora ya tenmos creado el cluster (Datos.km)


########################################################
#             Preparando el Set de DAtos
########################################################
# Ahora vamos a acceder a la información del cluster creado (usando names):
#   a) Como la asignación de las observaciones a los distintos cluster
#   b) Accdemos a los resultados de las distintas inercias 

names(Datos.km)  # Nos indica el contenido del objeto "kmeans creado"


Datos.km$cluster         # Asignción observacion a cluster (es la representación de cada Item)
Datos.km$totss           # Inercia Total
Datos.km$betweenss       # Inercia inter grupos (interesa que sea lo mas alto posible)
Datos.km$withinss        # Inercia intra grupos (una para cada cluster)
Datos.km$tot.withinss    # Inercia intra grupos (Total) (interesa que sea lo minimo posible)

########################################################
#        Determinar el número de Closters optimo
########################################################

# Se selecciono previamente 4 cluster, pero puede generar duda si es el optimo,
# realmente no se puede calcular un optimo ya que depende de lo que se desea analizar
# pero existe una medida en la que se puede ayudar, que es la inercia intergrupo
# haciendo una exploración de los distintos valores de las inercias intergrupos

# Se va a crear un primer momento, ingresando un sólo un cluster 
sumbt<- kmeans(Datos.scale, centers= 1)$betweenss    #(Ahora este es un vector)

# Ahora generamos un secuencia de 2 hasta 10
for (i in 2 : 10) sumbt[i]<- kmeans(Datos.scale, centers= i)$betweenss

# Ahora graficamos 
plot(1:10, sumbt, type = "b", xlab= "Número de Cluster", ylab= "suma de cuadrados inter grupos") 

########################################################
# INTERPRETACIÓN DE LA GRAFICA
########################################################

# Se ve como ha ido incrementando el valor de intergrupos a medidad que 
# añadimos cluster y vemos que en el número 4 el valor desciende 
# un buen corte seria en el cluster número 4


########################################################
#        Inspeccionar los resultados (Resumen)
########################################################

# Ahora vamos representar graficamente dos de las variables iniciales antes de escalar 
# que son la antiguedad en la compañia y la antiguedad del permiso de conducir
# y que pinte las observaciones en función al cluster al que han sido asignadas

plot(Datos$ant_comp, Datos$ant_perm, col=Datos.km$cluster , xlab= "Antiguedad en la compañia", ylab= "Experiencia en conducir")

# Azul representa las personas que le son fiel a la compañia y tienen cierta  
# experiencia como conductores

# otra cosa interesante que se puede ver (con aggregate) es que agrupe las variables   
# iniciales según el cluster asignado y que nos genera la media de los valores

aggregate(Datos [,5:9], by= list(Datos.km$cluster), mean)

# En el cluster No. 3 se tiene a las personas que presentan el indice de 
# accidentes más altos y corresponde a las personas que tienen una media 
# de edad de 49 años y tiene la antiguedad del vehiculo con una media  
# 3,2 años (los vehiculos más nuevos)


########################################################
#               Conclusión:
########################################################

#   Los vehiculos más nuevos con las personas máyores de la muestra 
#   de datos como media presentan el mayor indice de accidentes

#   Se puede crear un politica de aumento del seguro a las personas mayores
#   que tienen vehiculos nuevos








########################################################
#               RECORDATORIO  
#            Analisis Univariante 
########################################################

# Recordando que, antes de realizar cualquier análisis de datos, es 
# imprescindible estudiar el comportamiento univariante y Bivariante
# de las variables

summary(Datos)

freq<-table(Datos$sin)
freq

barplot(freq,xlab="Número de siniestros", ylab="Frecuencia")
title(main="Número de siniestros", col.main="blue", font.main=1)

table(Datos$sexo,Datos$siniestros)
prop.table(table(Datos$sexo,Datos$siniestros))

barplot(prop.table(table(Datos$sexo,Datos$siniestros)),col=c("darkblue","red"))
legend(5,0.8,c("Hombre","Mujer"),fill = c("darkblue","red"))
title(main="Indice de Siniestro", col.main="blue", font.main=1)

edad_c<-Datos$edad
edad_c[edad_c<26] <- "18-26"
edad_c[edad_c>=26 & edad_c<=55] <- "26-55"
edad_c[Datos$edad>55] <- "55+"
table(edad_c)
barplot(table(edad_c))
