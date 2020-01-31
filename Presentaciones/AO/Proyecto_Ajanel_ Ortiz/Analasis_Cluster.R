################################################################
# Analisis de Conglomerados
# Utilizando la libreria Cluster
# --------------------------------------------------------------


rm(list=ls(all.names=TRUE))
graphics.off()
gc()

# Instanlando y cargando los paquetes necesarios 

# install.packages("cluster")

library(cluster)
library(Matrix)
library(grid)

################################################################
# INFORMACIÓN DEL PROBLEMA QUE VAMOS A ANALIZAR
# --------------------------------------------------------------

# En este ejemplo vamos a agrupar distintos tipos de alimentos según sus aportes 
# en calorías, proteínas, grasas y calcio. 

# lo primero que se va a realizar es cargar el documento .csv

alimentos<-read.table("alimentos.txt",header=TRUE) # cargamos los datos
alimentos

# Ya se tiene el conjunto de datos con el que vamos a trabajar, pero la tabla 
# tiene una variable de caracteres y por lo que puede provocar dificultades por 
# eso hemos de separar la variable Alimentos y unir las variables (Calorías, 
# Proteínas, Grasas y Calcio) en una matriz con la función cbind:

alimentos_2<-as.matrix(cbind(Calorias, Proteinas, Grasas, Calcio))
alimentos_2

# Ahora se puede empezar a realizar a emplear los datos para el agrupamiento de 
# las medidas de disimilitud con base en la distancia euclidea.

disimilar<-daisy(alimentos_2)   # usando la función daisy
disimilar

# Esa es la matriz de disimilaridades entre los valores de las observaciones 
# que calcula R

################################################################
#        Determinar el número de Closters optimo
# --------------------------------------------------------------


# A partir de la matriz de disimilaridad se va a hacer el agrupamiento, vamos a ver 
# gráficamente el comportamiento de ese agrupamiento y posteriormente determinaremos 
# el número de cluster necesarios para realizar el estudio:

cluster<-hclust(disimilar)
plot(cluster)

#   CONCLUSIÓN:
#       Por medio de la grafica se puede obervar que se tiene dos cluster


################################################################
#        Resultados en DataFrame
# --------------------------------------------------------------

# Para ver que alimentos son esas observaciones se ha unido la función order
# (orden del dendograma del cluster), para poder realizar una correspondencia 
# visual entre los grupos y los alimentos. 

data.frame(alimentos$Alimentos,cluster$order)

################################################################
#  OTRA FORMA DE VISUALIZAR (UNA GRAN CANTIDAD DE OBSERVACIONES)
# --------------------------------------------------------------

# Para este caso ya habiendo establecido el número de cluster empleariamos
# una técnica por medios divisorios que situaría cada observación en algunos
# de los cluster de forma que se minimiza la suma de las disimilitudes.

cluster_nGrande<-pam(alimentos_2,2)
cluster_nGrande
cluster_nGrande$data

################################################################
#                RESULTADOS GRAFICAMENTE
# --------------------------------------------------------------

# Con la función Pam los cluster formados son distintos a los que formamos
# con el método jerárgico, por lo que veamoslo graficamente

par(mfrow=c(2,2))   # Arreglo para ver los gráficos en una pantalla divida en 2 celdas
plot(cluster_nGrande)
plot(cluster)

# La función Pam ofrece 2 graficos: 
#       Uno de los componentes principal 
#       El otro de las distancias entre los centroides de los cluster


################################################################
#        COMPARANDO LOS DOS METÓDOS
# --------------------------------------------------------------

data.frame(alimentos$Alimentos,cluster$order,cluster_nGrande$clustering)
cluster<-hclust(disimilar)
plot(cluster)

#   CONCLUSIÓN:
#       Podemos observar que cordero se ha unido al cluster 2 y en análisis 
#       jerárquico se había unido al cluster 1. 

################################################################
#        INTERPRETACIÓN DE RESULTADOS
# --------------------------------------------------------------

# Como siguiente paso vamos a ver el resumen de los datos de Cluster_nGrande

summary(cluster_nGrande)

#   CONCLUSIÓN:

#       Medoids:
#       En la primera parate tenemos la media de cada variable dentro del cluster, 
#       los alimentos "sanos" con menor aporte calórico, menos grasas y más calcio
#       forman el cluster 1 y los "menos sanos" forman el cluster 2

#       Clustering vector:
#       Se tiene el vector que coloca cada observación en un cluster

#       Numerical information per Cluster:
#       Se tiene la información númerica sobre cada cluster como el tamaño, 
#       distancia medias y maximas,.....

#       Silhouette plot information:
#       Se tiene como funciona el algoritmo que clasifica las observaciones, 



