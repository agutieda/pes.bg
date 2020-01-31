# Banco de Guatemala 
# Programa de Estudios Superiores 2019-2020
# Programación II
# Profesor: Ángelo Gutierrez

# ------------------------------ Trabajo Final -------------------------------#

# Ingregrantes:
#       Elmer Humberto Lémus Flores
#       Erwin Roberto Navas Solís

# ----------------------------------------------------------------------------#

# Trabajo Basado en:

# Temporal Disaggregation of Time Series
# by Christoph Sax and Peter Steiner

# ----------------------------------------------------------------------------#

# Instalación de paquete

graphics.off(); rm(list=ls()); shell("cls")

#install.packages("tempdisagg")
library(tempdisagg)
library(readxl)

# Demostración del autor, correr para ver un ejemplo de desagregación
#demo(tempdisagg)

# Importación de datos en excel
d_af = read_excel(path = "Mensual.xlsx")
d_bf = read_excel(path = "Anual.xlsx")

# Selección de columnas de trabajo
af = d_af$TOTAL # Serie de alta frecuencia (Mensual)
bf = d_bf$TOTAL # Serie de baja frecuencia (Anual), solo ejemplo

# Ejemplo de Agregación de Series temporale
# De alta frecuencia a baja frecuencia

# Despúes de cargar e identificar los datos que queremos trabajar, ahora debemos
# pasarlos a al objeto "ts", de Time Series
# Atributos del objeto
    # data          corresponde al vector de valores numéricos o matriz de datos
                    # un dataframe se convierte a data.matrix
    # start         punto de inicio de la serie, puede ser fecha
    # end           punto final de la serie
    # frequency     numero de observaciones por periodo
    # deltat        fración de la uestra del periodo entre las observaciones 
                    #(ej. mensual 1/12)
    # ts.eps        tolerancia de comparación de la serie de tiempo
                    # se consideran iguales las series si el valor absoluto de 
                    # las diferencias es menor que este indicador
    # class         ts para serie simple, mts, ts o matrix para series múltiples

# Ejemplo de serie mensual
tsaf = ts(af, start= c(1995, 1), end= c(2019, 12),  frequency=12, deltat=1/12, ts.eps = 0.05, class = "ts")
class(tsaf)
tsaf

# Graficamos
plot(tsaf, col = "red")

# Agregación
# Usamos ta de Temporal Aggregation
# Criterios de agregación
    # sum           Para que la agregación indicada sea de forma suma
    # average       Para que la agregación sea de tipo promedio
    # first         Para que la agregación tome solo el primer valor
    # last          Para que la agregación tome solo el último valor

# Ejemplo de agregación de serie mensual a diferentes niveles
# Agregación
    # 1 = anual, 2 = semestral, 3 = cuatrimestre, 4 = trimestre, 6 = bimestre

agg = 1

ta_suma = ta(tsaf, conversion = "sum", to = agg)
ta_average = ta(tsaf, conversion = "average", to = agg)
ta_last = ta(tsaf, conversion = "last", to = agg)
ta_first = ta(tsaf, conversion = "first", to = agg)

# Graficas
plot(ta_suma, col = "darkgreen")
plot(ta_average, col = "navyblue")
lines(ta_first, col = "brown")
lines(ta_last, col = "red")

# Si aplicamos esta función a una salida de td, el resultado es la serie original.

# ----------------------------------------------------------------------------#

# Para grupos de series de tiempo
# Matriz

# Extraemos los datos
af1 = d_af$TOTAL
af2 = d_af$PUBLICO
af3 = d_af$PRIVADO

# Creamos el objeto matrix, según las series a incluir, el punto inicial de la fecha
# y la cantidad de observaciones a incluir. IMPORTANTE, COLOCAR LA FRECUENCIA
series = ts(matrix(c(af1,af2,af3), 300, 3), start= c(1995, 1),  frequency=12)
series

# Ahora podemos ver la gráfica
x11()
plot(series[,1], col = "black")

x11()
plot(series)

# Aplicamos el proceso de agregación, según lo que deseamos.
# para el ejemplo, criterio de agregación trimestral, con promedio

aggm = 4
mta = ta(series, conversion = "average", to = aggm)
mta

# Ahora podemos ver la gráfica
x11()
plot(mta[,1], col = "red")
lines(series[,1])

x11()
plot(mta)

# Exportamos los datos generados si se desea, en diferentes formatos:

# Documento de texto, "txt"
write.table(mta, "aggregation.txt", sep=" ; ")

# fin