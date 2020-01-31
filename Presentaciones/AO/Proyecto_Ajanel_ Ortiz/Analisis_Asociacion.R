################################################################

# Analisis de Reglas de Asociaciones
# Usando el algoritmo APRIORI

# En esta sección se tratara de la búsqueda de asociaciones entre 
# los productos que tiene las canastas de los individuos de un 
# supermercado.

################################################################
# CARGAMOS LA LIBRERIA Y DATOS
# --------------------------------------------------------------

rm(list=ls(all.names=TRUE))
graphics.off()
gc()

# install.pacages("grid")
# install.pacages("arules")
# install.packages("arulesViz") 

library(Matrix)
library(grid)
library(arules)
library(arulesViz)

# Cargamos el documentos .csv

trx <- read.csv("lista_de_super.csv") # llamamos el documentos trx

################################################################
# TRANSFORMA Data.Frame en TRANSACCIONAL
# --------------------------------------------------------------
# Se va a Transformar el  data.frame en transaccional
trx       <- split(trx$Item,trx$Id_Factura)    # convierte datos en lista
trx       <- as(trx,"transactions")            # convierte datos en transacciones

################################################################
# CREAMOS LAS REGLAS
# --------------------------------------------------------------
# a)    soporte mínimo que debe tener un itemset para ser considerado 
#       frecuente. definimos para nuestro caso  0.01
# b)    confianza mínima que debe de tener una regla para ser incluida 
#       en los resultados. Para nuestro caso 0.01

reglas <- apriori(trx, parameter=list(support=0.01, confidence = 0.01))

################################################################
# PRINT
# --------------------------------------------------------------
# cantidad de reglas creadas
print(reglas)

# imprime todas las reglas
inspect(reglas)

# Análisis de las 10 reglas con mayor confianza
plot(reglas)

# Interprectación
    # lhs: (left-hand-sides) es la parte izquierda de la regla, o antecedente 
    # (producto/s que "causa" la compra de otro producto)

    # rhs: ( right-hand-sides ) es la parte derecha de la regla, o resultado 
    # (producto comprado como "consecuencia" de otro producto)

    # Support:  es la frecuencia relativa de una regla sobre el total de transacciones
            #   (Es el numero de veces una canasta en la base de datos)
    # Confidence: mide qué tan confiable es la suposición hecha por la regla, 
            #   es decir: que tantas veces sucede el rhs cuando se presenta el lhs, para cada regla.
            #   es la probabilidad de que se compre el itemset (Y) dado que sabemos que 
            #   se compre (X)
    # Lift: mide si la regla se debió al azar. Calcula el ratio entre la confianza de la 
            #   regla y el consecuente de la regla o rhs.
################################################################
# PRINT
# --------------------------------------------------------------
# Análisis de las 10 reglas con mayor confianza

reglas_1 <-sort(reglas, by="confidence", decreasing=TRUE)   # ordena la regla con mayor confianza 
inspect(head(reglas_1,10))

# Análisis de las 10 reglas con mayor frecuencia 

reglas_2 <-sort(reglas, by="support", decreasing=TRUE)   # ordena la regla con mayor frecuencia  
inspect(head(reglas_2,10))

# Análisis de los productos con mayor frecuencia en las canastas

FreqProd <- data.frame(Producto=names(itemFrequency(trx)), 
            Frecuencia=itemFrequency(trx), row.names=NULL)
FreqProd <- FreqProd[order(FreqProd$Frecuencia, decreasing = T),]
head(FreqProd,20)

# PLOT
# grafica los 20 productos mas frecuente

itemFrequencyPlot(trx,topN=20,type="absolute")

# Análisis con el producto que más se vende

regla_3<- apriori(trx, parameter=list(support=0.01, confidence = 0.01), appearance = list (default="lhs", rhs= "whole milk"))
regla_3 <-sort(regla_3, by="lift", decreasing=TRUE)
inspect(head(regla_3,10))

# CONCLUSIÓN:
#       Ahora sabemos que la probabilidad de que el cliente compre leche entera ha
#       aumentando cuando se compro otros vegetales y yogurt. 


################################################################
#    GRAFICA DE LOS PRODUCTOS CON MAYOR LIFT
# --------------------------------------------------------------
reglas <-sort(reglas, by="lift", decreasing=TRUE) # ordena reglas 
inspect(reglas)

# Grafico de matriz de 100 regla con mayor confianza
plot(head(reglas,100), method="grouped")


################################################################
# Fin
# --------------------------------------------------------------

