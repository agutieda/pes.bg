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

# Introducción

# Los métodos de desagregación temporal se usan para desagregar series de tiempo
# de baja frecuencia a series de frecuencia más alta, donde la suma, el promedio,
# el primer o el último valor de la serie de alta frecuencia resultante es 
# consistente con la serie de baja frecuencia. Pueden tratar situaciones en las 
# que la frecuencia alta es un múltiplo entero de la frecuencia baja (por ejemplo,
# años a trimestres, semanas a días), pero no con frecuencias irregulares (por 
# ejemplo, semanas a meses).La desagregación temporal se puede realizar con o sin
# una o más series de indicadores de alta frecuencia. El paquete "tempdisagg" es
# una colección de varios métodos para la desagregación temporal.

# ----------------------------------------------------------------------------#

# Instalación de paquete

graphics.off(); rm(list=ls()); shell("cls")

#install.packages("tempdisagg")
#install.packages("readxl")
library(tempdisagg)
library(readxl)

# Demostración del autor, correr para ver un ejemplo de desagregación
#demo(tempdisagg)

# --------------------Importación de datos de Excel---------------------------#

# Importación de datos en excel

# Series de Alta frecuencia (mensual)
# Estimación mensual de los cotizantes al IGSS
d_af_empleo = read_excel(path = "Ejemplo.xlsx", sheet = "EM_TAC") 
# Índice Mensual de la Actividad Económica
d_af_IMAE = read_excel(path = "Ejemplo.xlsx", sheet = "IMAE") 

# Series de Baja frecuencia (anual)
# Vector del Gasto de Consumo Final de los Hogares e ISL
d_bf_GCF = read_excel(path = "Ejemplo.xlsx", sheet = "GCFHISL") 
# PIB anual por actividad económica
d_bf_PIB = read_excel(path = "Ejemplo.xlsx", sheet = "PIB 2001") 

# Selección de columnas de trabajo
af_empleo = d_af_empleo$Empleo
af_IMAE = d_af_IMAE$IMAE

bf_GCF = d_bf_GCF$GCFH
bf_PIB = d_bf_PIB$PIB

# ------------Ejemplo de desagregación de Series temporales-------------------#

# -----------------De baja frecuencia a alta frecuencia-----------------------#

# Despúes de cargar e identificar los datos que queremos trabajar, ahora debemos
# pasarlos a al objeto "ts", de Time Series
# Atributos del objeto:

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

# -------------Transformación de los datos a series temporales----------------#

# Pasamos los datos anuales a "Time Series"
tsbf_GCF = ts(bf_GCF, 
              start= c(2001,1),
              end= c(2018,1),
              frequency=1,
              deltat=1/1,
              ts.eps = 0.05,
              class = "ts"
              )

class(tsbf_GCF)
tsbf_GCF

tsbf_PIB = ts(bf_PIB, 
              start= c(2001,1),
              end= c(2018,1),
              frequency=1,
              deltat=1/1,
              ts.eps = 0.05,
              class = "ts"
              )

class(tsbf_PIB)
tsbf_PIB

# Pasamos los datos mensuales a Time Series
tsaf_empleo = ts(af_empleo,
                  start= c(2001,1),
                  end= c(2018,12),
                  frequency=12,
                  deltat=1/12,
                  ts.eps = 0.05,
                  class = "ts"
                  )

class(tsaf_empleo)
tsaf_empleo

tsaf_IMAE = ts(af_IMAE,
                 start= c(2001,1),
                 end= c(2018,12),
                 frequency=12,
                 deltat=1/12,
                 ts.eps = 0.05,
                 class = "ts"
                 )

class(tsaf_IMAE)
tsaf_IMAE

# Graficamos
x11(); plot(tsbf_PIB,
             col = "red",
             lwd = 1,
             lty= 1,
             main="Serie de Baja Frecuencia",
             ylab=" "
             ) # Baja frecuencia

x11(); plot(tsaf_IMAE,
             col = "black",
             lwd = 1,
             lty= 1,
             main="Serie de Alta Frecuencia",
             ylab=" "
             ) # Alta frecuencia

#-----------Argumentos para la desagregación de series de tiempo--------------#

# Usamos "td"
# td(serie o conjunto de series,

#       conversion = "sum" "average" "first" "last",

#       to = frecuencia de desagregación con número entero (trimestre = 4),
#               si la serie ingresada es objeto ts, el argumento es necesario si
#                   no se da indicador.
#               Si es una matriz, to debe ser un escalar indicando la frecuencia.

#       method = Métodos de Denton
#                   1. "denton-cholette"
#                   2. "denton"
#                   3. "uniform"
#                   4. "ols"

#                Métodos basados en regresión
#                   5. "chow-lin-maxlog" 
#                   6. "chow-lin-minrss-ecotrim"
#                   7. "chow-lin-minrss-quilis"
#                   8. "chow-lin-fixed"
#                   9. "fernandez"
#                   10. "litterman-maxlog"
#                   11. "litterman-minrss"
#                   12. "litterman-fixed"

#                Métodos experimentales
#                   13. "dynamic-maxlog" (experimental)
#                   14. "dynamic-minrss" (experimental)
#                   15. "dynamic-fixed" (experimental)

#       truncated.rho =  límite inferior del parámetro autorregresivo ρ.
#                0 = (default), no acepta valores negativos
#               -1 = truncado.

#       fixed.rho = fija el parametro autorregresivo ρ. 
#               (Solo para "chow-lin-fixed" and "litterman-fixed")

#       start = valor inicial

#       end = valor final

#------->  Sólo para los métodos de Denton

#       criterion = criterio de minimización para los métodos de Denton
#               "proportional" o "additive"

#       h = grado de diferenciación para el método Denton

#-----------------------------------------------------------------------------#

#                                   IMPORTANTE

#-----------------------------------------------------------------------------#

# 1) La "conversion" hace que la serie de alta frecuencia resultante es consistente
# con la serie de baja frecuencia. Esta desagregación se puede realizar con o sin
# la ayuda de una o más series de indicadores de referencia.

# 2) Si los indicadores de alta frecuencia cubren un período de tiempo más largo
# que las series de baja frecuencia, se realiza una extrapolación o retropolación
# (Wei, 1994, p. 138), utilizando el mismo modelo que para la interpolación.

# 3) La selección del modelo de desagregación es similar a la selección del modelo
# de regresión lineal. "td" refleja de cerca el funcionamiento de la función lm.
# El lado izquierdo de la fórmula denota las series de baja frecuencia, 
# el lado derecho los indicadores. Si no se especifica ningún indicador, el lado
# derecho debe establecerse igual a 1. A diferencia de lm, td maneja objetos de 
# series temporales ts y mts (matriz).

#-----------------------------------------------------------------------------#

# 4) Para los métodos de mínimos cuadrados generalizados (GLS) "chow-lin-maxlog",
# "chow-lin-minrss-ecotrim", "chow-lin-minrss-quilis", "litterman-maxlog" y 
# "litterman-minrss"; y para el autorregresivo ρ. El método predeterminado 
# (y recomendado) es chow-lin-maxlog. Con truncated.rho = 0 (predeterminado), 
# produce buenos resultados para una amplia gama de aplicaciones.

# 5) Los métodos "dynamic-maxlog", "dynamic-minrss" y "dynamic-fixed" son 
# extensiones dinámicas de Chow-Lin (Santos Silva y Cardoso, 2001). 
# Si el parámetro autorregresivo ρ es igual a 0, no se agrega el resto de
# truncamiento. ESTOS SON MÉTODOS EXPERIMENTALES.

# 6) Los métodos de Denton ("denton" y "denton-cholette") pueden especificarse
# con uno o sin indicador. El parámetro "h" se puede establecer igual a 0, 1 o 2.
# El procedimiento minimiza la suma de cuadrados de las desviaciones del indicador
# y la serie resultante. "denton-cholette" elimina el movimiento transitorio del
# método original "denton" al comienzo de la serie resultante.

# 7) "uniforme" es un caso especial del enfoque "denton", con "h" igual a 0 y
# criterio igual a "proporcional". Distribuye los residuos de manera uniforme.
# Si no se utiliza ningún indicador, esto conduce a una serie en forma de escalón.

# 8) Por último, "ols" realiza una regresión ordinaria de mínimos cuadrados (OLS)
# y distribuye los residuos de manera uniforme. Es especialmente útil para 
# comparar los estimadores de regresiones GLS y OLS.

#-----------------------------------------------------------------------------#

# Indicadores de referencia
tsaf1 = tsaf_empleo
tsaf2 = tsaf_IMAE

#bf = tsbf_GCF
bf = tsbf_PIB

# Consistente con:
criterio = "average"

#-----------------------------------------------------------------------------#

#                               Métodos de Denton

# Por un lado, Denton (Denton, 1971) y Denton-Cholette, se preocupan principalmente
# por la preservación del movimiento, generando una serie que es similar a la 
# serie de indicadores, ya sea que el indicador esté o no correlacionado con el 
# nivel bajo de frecuencias. Alternativamente, estos métodos pueden desagregar 
# una serie sin un indicador.

#-----------------------------------------------------------------------------#


#-----------------------------------------------------------------------------#

#                       Método 1 - "Denton-Cholette"

#-----------------------------------------------------------------------------#

dc_si = td(bf ~ 1,                                # sin indicador
            to = 12,                              # mensual
            method = "denton-cholette",
            conversion = criterio,                # consistente con la average
            criterion = "proportional",           # criterio proporcional
            h = 1,                                # primera diferencia
            )

# Extraemos la serie resultante
dc_salida_si = predict(dc_si)

# Resumen del método
summary(dc_si)

# Pasamos los datos a Time Series
tsbfa_dc_si = ts(dc_salida_si,
               start= c(2001,1),
               end= c(2017,12),
               frequency=12,
               deltat=1/12,
               ts.eps = 0.05,
               class = "ts"
               )

class(tsbfa_dc_si)
tsbfa_dc_si

# Graficamos para comparar
x11(); plot(tsbfa_dc_si, 
         col = "red",
         lwd = 1,
         lty= 2,
         main="Comparación de serie estimada y de referencia",
         ylab=" ",
         sub="Estimada = Rojo"
         ); lines(bf, 
                  col = "black",
                  lwd = 1,
                  lty= 1,
                  ylab=" ",
                  )

#-----------------------------------------------------------------------------

dc_ci = td(bf ~ 0 + tsaf2,                     # con indicador
        to = 12,                               # mensual
        method = "denton-cholette",
        conversion = criterio,                 # consistente con la average
        criterion = "proportional",            # criterio proporcional
        h = 1                                  # primera diferencia
        )

# Extraemos la serie resultante
dc_salida_ci = predict(dc_ci)

# Resumen del método
summary(dc_ci)

# Pasamos los datos a Time Series
tsbfa_dc_ci = ts(dc_salida_ci,
              start= c(2001,1),
              end= c(2018,12), # con pronóstico de un año
              frequency=12,
              deltat=1/12,
              ts.eps = 0.05,
              class = "ts"
             )

class(tsbfa_dc_ci)
tsbfa_dc_ci

# Graficamos para comparar

x11(); 
par(mfrow=c(2,1))
plot(tsbfa_dc_ci, 
        col = "red",
        lwd = 1,
        lty= 2,
        main="Serie estimada y Original",
        ylab=" ",
        sub="Estimada = Rojo"
        ); lines(bf, 
                 col = "black",
                 lwd = 1,
                 lty= 1,
                 ylab=" ",
                )
plot(tsaf_IMAE, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia",
     ylab=" ",
     )

# ----------------------------------------------------------------------------#

#                               Método 2 - "Denton"

# ----------------------------------------------------------------------------#

d_si = td(bf ~ 1,                            # sin indicador
       to = 12,                              # mensual
       method = "denton",
       conversion = criterio,                # consistente con la average
       criterion = "proportional",           # criterio proporcional
       h = 1                                 # primera diferencia
       )

# Extraemos la serie resultante
d_salida_si = predict(d_si)

# Resumen del método
summary(d_si)

# Pasamos los datos a Time Series
tsbfa_d_si = ts(d_salida_si,
             start= c(2001,1),
             end= c(2017,12),
             frequency=12,
             deltat=1/12,
             ts.eps = 0.05,
             class = "ts"
            )

class(tsbfa_d_si)
tsbfa_d_si

# Graficamos para comparar
x11(); plot(tsbfa_d_si, 
            col = "red",
            lwd = 1,
            lty= 2,
            main="Comparación de serie estimada y de referencia",
            ylab=" ",
            sub="Estimada = Rojo"
            ); lines(bf, 
                     col = "black",
                     lwd = 1,
                     lty= 1,
                     ylab=" ",
                     )

#-----------------------------------------------------------------------------

d_ci = td(bf ~ 0 + tsaf2,                     # con indicador
       to = 12,                               # mensual
       method = "denton",
       conversion = criterio,                 # consistente con la average
       criterion = "proportional",            # criterio proporcional
       h = 1                                  # primera diferencia
        )

# Extraemos la serie resultante
d_salida_ci = predict(d_ci)

# Resumen del método
summary(d_ci)

# Pasamos los datos a Time Series
tsbfa_d_ci = ts(d_salida_ci,
             start= c(2001,1),
             end= c(2018,12), # Con pronóstico de un año
             frequency=12,
             deltat=1/12,
             ts.eps = 0.05,
             class = "ts"
            )

class(tsbfa_d_ci)
tsbfa_d_ci

# Graficamos para comparar
x11(); 
par(mfrow=c(2,1))
plot(tsbfa_d_ci, 
     col = "red",
     lwd = 1,
     lty= 2,
     main="Serie estimada y Original",
     ylab=" ",
     sub="Estimada = Rojo"
    ); lines(bf, 
             col = "black",
             lwd = 1,
             lty= 1,
             ylab=" ",
             )
plot(tsaf_IMAE, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia",
     ylab=" ",
     )

# ----------------------------------------------------------------------------#

#                             Método 3 - "Uniforme"

# caso especial del enfoque "denton", con "h" igual a 0 y criterio igual a 
# "proporcional". Distribuye los residuos de manera uniforme. Si no se utiliza 
# ningún indicador, esto conduce a una serie en forma de escalón.

# ----------------------------------------------------------------------------#

uni_si = td(bf ~ 1,                            # sin indicador
         to = 12,                              # mensual
         method = "uniform",
         conversion = criterio,                # consistente con la average
         criterion = "proportional",           # criterio proporcional
         h = 0                                 # de nivel
         )

# Extraemos la serie resultante
uni_salida_si = predict(uni_si)

# Resumen del método
summary(uni_si)

# Pasamos los datos a Time Series
tsbfa_uni_si = ts(uni_salida_si,
           start= c(2001,1),
           end= c(2017,12),
           frequency=12,
           deltat=1/12,
           ts.eps = 0.05,
           class = "ts"
            )

class(tsbfa_uni_si)
tsbfa_uni_si

# Graficamos para comparar
x11(); plot(tsbfa_uni_si, 
            col = "red",
            lwd = 1,
            lty= 2,
            main="Comparación de serie estimada y de referencia",
            ylab=" ",
            sub="Estimada = Rojo"
            ); lines(bf, 
                     col = "black",
                     lwd = 1,
                     lty= 1,
                     ylab=" ",
                    )


#-----------------------------------------------------------------------------

uni_ci = td(bf ~ 0 + tsaf1,                     # Con indicador
         to = 12,                               # mensual
         method = "uniform",
         conversion = criterio,                 # consistente con la average
         criterion = "proportional",            # criterio proporcional
         h = 0                                  # de nivel
         )

# Extraemos la serie resultante
uni_salida_ci = predict(uni_ci)

# Resumen del método
summary(uni_ci)

# Pasamos los datos a Time Series
tsbfa_uni_ci = ts(uni_salida_ci, 
           start= c(2001,1),
           end= c(2017,12),
           frequency=12,
           deltat=1/12,
           ts.eps = 0.05,
           class = "ts"
            )

class(tsbfa_uni_ci)
tsbfa_uni_ci

# Graficamos para comparar
x11(); 
par(mfrow=c(2,1))
plot(tsbfa_uni_ci, 
     col = "red",
     lwd = 1,
     lty= 2,
     main="Serie estimada y Original",
     ylab=" ",
     sub="Estimada = Rojo"
    ); lines(bf, 
             col = "black",
             lwd = 1,
             lty= 1,
             ylab=" ",
            )
plot(tsaf_IMAE, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia",
     ylab=" ",
    )


# ----------------------------------------------------------------------------#

#                             Método 4 - "ols"

# ----------------------------------------------------------------------------#

# ------> No recomendado si no existe un indicador de referencia

ols_si = td(bf ~ 1,                            # sin indicador
         to = 12,                              # mensual
         method = "ols",
         conversion = criterio,                # consistente con la average
         criterion = "proportional",           # criterio proporcional
         h = 0                                 # de nivel
         )

# Extraemos la serie resultante
ols_salida_si = predict(ols_si)

# Resumen del método
summary(ols_si)

# Pasamos los datos a Time Series
tsbfa_ols_si = ts(ols_salida_si,
           start= c(2001,1),
           end= c(2017,12),
           frequency=12,
           deltat=1/12,
           ts.eps = 0.05,
           class = "ts"
            )

class(tsbfa_ols_si)
tsbfa_ols_si

# Graficamos para comparar
x11(); plot(tsbfa_ols_si, 
            col = "red",
            lwd = 1,
            lty= 2,
            main="Comparación de serie estimada y de referencia",
            ylab=" ",
            sub="Estimada = Rojo"
            ); lines(bf, 
                     col = "black",
                     lwd = 1,
                     lty= 1,
                     ylab=" ",
                     )


#-----------------------------------------------------------------------------

ols_ci = td(bf ~ 0 + tsaf1 + tsaf2,         # Con indicador
         to = 12,                           # mensual
         method = "ols",
         conversion = criterio,             # consistente con la average
         truncated.rho = 0,                 # p autorregresivo no acepta negativos
         criterion = "proportional",        # criterio proporcional
         h = 0                              # de nivel
         )

# Extraemos la serie resultante
ols_salida_ci = predict(ols_ci)

# Resumen del método
summary(ols_ci)

# Pasamos los datos a Time Series
tsbfa_ols_ci = ts(ols_salida_ci, 
           start= c(2001,1),
           end= c(2018,12), # con pronóstico
           frequency=12,
           deltat=1/12,
           ts.eps = 0.05,
           class = "ts"
            )

class(tsbfa_ols_ci)
tsbfa_ols_ci

# Graficamos para comparar
x11(); 
par(mfrow=c(2,1))
plot(tsbfa_ols_ci, 
     col = "red",
     lwd = 1,
     lty= 2,
     main="Serie estimada y Original",
     ylab=" ",
     sub="Estimada = Rojo"
    ); lines(bf, 
             col = "black",
             lwd = 1,
             lty= 1,
             ylab=" ",
            )
plot(tsaf_IMAE, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia",
     ylab=" ",
    )

#-----------------------------------------------------------------------------#
# Comparación de resultados de los Métodos Denton

# Series sin indicador
x11()
par(mfrow=c(2,2))
plot(tsbfa_dc_si, lwd = 2, lty= 1, main="Denton-Cholette", ylab=" ");lines(bf, lwd = 1, lty= 3)
plot(tsbfa_d_si, lwd = 2, lty= 1, main="Denton", ylab=" ");lines(bf, lwd = 1, lty= 3)
plot(tsbfa_uni_si, lwd = 2, lty= 1, main="Uniforme", ylab=" ");lines(bf, lwd = 1, lty= 3)
plot(tsbfa_ols_si, lwd = 2, lty= 1, main="OLS", ylab=" ");lines(bf, lwd = 1, lty= 3)

# Series con indicador
x11()
par(mfrow=c(2,2))
plot(tsbfa_dc_ci, lwd = 2, lty= 1, main="Denton-Cholette", ylab=" ");lines(bf, lwd = 1, lty= 3)
plot(tsbfa_d_ci, lwd = 2, lty= 1, main="Denton", ylab=" ");lines(bf, lwd = 1, lty= 3)
plot(tsbfa_uni_ci, lwd = 2, lty= 1, main="Uniforme", ylab=" ");lines(bf, lwd = 1, lty= 3)
plot(tsbfa_ols_ci, lwd = 2, lty= 1, main="OLS", ylab=" ");lines(bf, lwd = 1, lty= 3)

# Consistencia de la serie estimada, con el promedio
bf[1] # primer valor de la serie de baja frecuencia
mean(tsbfa_dc_si[1:12])
mean(tsbfa_d_si[1:12])
mean(tsbfa_uni_si[1:12])
mean(tsbfa_ols_si[1:12])
mean(tsbfa_dc_ci[1:12])
mean(tsbfa_d_ci[1:12])
mean(tsbfa_uni_ci[1:12])
mean(tsbfa_ols_ci[1:12])

#-----------------------------------------------------------------------------#

#                       Métodos basados en regresión

# Por otro lado, Chow-Lin, Fernández y Litterman usan uno o varios indicadores 
# y realizan una regresión en las series de baja frecuencia. Chow-Lin 
# (Chow y Lin, 1971) es adecuado para series estacionarias o cointegradas, mientras
# que Fernández (Fernández, 1981) y Litterman (Litterman, 1983) se ocupan de series
# no cointegradas.

#-----------------------------------------------------------------------------#


# ----------------------------------------------------------------------------#

#                             Método 5 - "chow-lin"
#                   Para series estacionarias o cointegradas

#----------> incluye
#               a. "chow-lin-maxlog" 
#               b. "chow-lin-minrss-ecotrim"
#               c. "chow-lin-minrss-quilis"
#               d. "chow-lin-fixed"

#----------> Recomendado: chow-lin-maxlog
#----------> Con truncated.rho = 0
#----------> Sin indicador se recomienda Denton

# ----------------------------------------------------------------------------#

# a. "chow-lin-maxlog"
cl_ml_a = td(bf ~ 0 + tsaf1 + tsaf2,            # con indicador
             to = 12,                           # mensual
             method = "chow-lin-maxlog",
             conversion = criterio,             # consistente con la average
             truncated.rho = 0,                 # p autorregresivo no acepta negativos
             #fixed.rho = 0.5,                  # p autorregresivo fijo
             )

# Extraemos la serie resultante
cl_ml_a_salida = predict(cl_ml_a)

# Resumen del método
summary(cl_ml_a)
logl_a = summary(cl_ml_a)$logl              # logl
rsqrt_a = summary(cl_ml_a)$adj.r.squared    # r cuadrado ajustado
rho_a = summary(cl_ml_a)$rho                # rho

compa_a = c(logl_a, rsqrt_a, rho_a)

# Pasamos los datos a Time Series
tsbfa_cl_ml_a = ts(cl_ml_a_salida,
                   start= c(2001,1),
                   end= c(2018,12), # con pronóstico
                   frequency=12,
                   deltat=1/12,
                   ts.eps = 0.05,
                   class = "ts"
                    )

class(tsbfa_cl_ml_a)
tsbfa_cl_ml_a

# Graficamos para comparar
x11(); 
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
plot(tsbfa_cl_ml_a, 
     col = "red",
     lwd = 1,
     lty= 2,
     main="Serie estimada y Original",
     ylab=" ",
     sub="Estimada = Rojo"
    ); lines(bf, 
             col = "black",
             lwd = 1,
             lty= 1,
             ylab=" ",
            )
plot(tsaf_IMAE, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia 1",
     ylab=" ",
    )
plot(tsaf_empleo, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia 2",
     ylab=" ",
    )

# ----------------------------------------------------------------------------#

# b. "chow-lin-minrss-ecotrim"
cl_ml_b = td(bf ~ 0 + tsaf1 + tsaf2,                # con indicador
             to = 12,                               # mensual
             method = "chow-lin-minrss-ecotrim",
             conversion = criterio,                 # consistente con la average
             truncated.rho = 0,                     # p autorregresivo no acepta negativos
             #fixed.rho = 0.5,                      # p autorregresivo fijo
             )

# Extraemos la serie resultante
cl_ml_b_salida = predict(cl_ml_b)

# Resumen del método
summary(cl_ml_b)
logl_b = summary(cl_ml_b)$logl              # logl
rsqrt_b = summary(cl_ml_b)$adj.r.squared    # r cuadrado ajustado
rho_b = summary(cl_ml_b)$rho                # rho

compa_b = c(logl_b, rsqrt_b, rho_b)
compa_b

# Pasamos los datos a Time Series
tsbfa_cl_ml_b = ts(cl_ml_b_salida,
                   start= c(2001,1),
                   end= c(2018,12),# con pronóstico
                   frequency=12,
                   deltat=1/12,
                   ts.eps = 0.05,
                   class = "ts"
                    )

class(tsbfa_cl_ml_b)
tsbfa_cl_ml_b

# Graficamos para comparar
x11(); 
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
plot(tsbfa_cl_ml_b, 
     col = "red",
     lwd = 1,
     lty= 2,
     main="Serie estimada y Original",
     ylab=" ",
     sub="Estimada = Rojo"
    ); lines(bf, 
             col = "black",
             lwd = 1,
             lty= 1,
             ylab=" ",
            )
plot(tsaf_IMAE, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia 1",
     ylab=" ",
    )
plot(tsaf_empleo, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia 2",
     ylab=" ",
    )

# ----------------------------------------------------------------------------#

# c. "chow-lin-minrss-quilis"
cl_ml_c = td(bf ~ 0 + tsaf1 + tsaf2,            # con indicador
             to = 12,                           # mensual
             method = "chow-lin-minrss-quilis",
             conversion = criterio,             # consistente con la average
             truncated.rho = 0,                 # p autorregresivo no acepta negativos
             #fixed.rho = 0.5,                  # p autorregresivo fijo
             )

# Extraemos la serie resultante
cl_ml_c_salida = predict(cl_ml_c)

# Resumen del método
summary(cl_ml_c)
logl_c = summary(cl_ml_c)$logl              # logl
rsqrt_c = summary(cl_ml_c)$adj.r.squared    # r cuadrado ajustado
rho_c = summary(cl_ml_c)$rho                # rho

compa_c = c(logl_c, rsqrt_c, rho_c)

# Pasamos los datos a Time Series
tsbfa_cl_ml_c = ts(cl_ml_c_salida,
                   start= c(2001,1),
                   end= c(2018,12),# con pronóstico
                   frequency=12,
                   deltat=1/12,
                   ts.eps = 0.05,
                   class = "ts"
                    )

class(tsbfa_cl_ml_c)
tsbfa_cl_ml_c

# Graficamos para comparar
x11(); 
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
plot(tsbfa_cl_ml_c, 
     col = "red",
     lwd = 1,
     lty= 2,
     main="Serie estimada y Original",
     ylab=" ",
     sub="Estimada = Rojo"
    ); lines(bf, 
             col = "black",
             lwd = 1,
             lty= 1,
             ylab=" ",
            )
plot(tsaf_IMAE, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia 1",
     ylab=" ",
    )
plot(tsaf_empleo, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia 2",
     ylab=" ",
    )

# ----------------------------------------------------------------------------#

# d. "chow-lin-fixed"
cl_ml_d = td(bf ~ 0 + tsaf1 + tsaf2,            # con indicador
             to = 12,                           # mensual
             method = "chow-lin-fixed",
             conversion = criterio,             # consistente con la average
             truncated.rho = 0,                 # p autorregresivo no acepta negativos
             #fixed.rho = 0.5,                  # p autorregresivo fijo
             )

# Extraemos la serie resultante
cl_ml_d_salida = predict(cl_ml_d)

# Resumen del método
summary(cl_ml_d)
logl_d = summary(cl_ml_d)$logl              # logl
rsqrt_d = summary(cl_ml_d)$adj.r.squared    # r cuadrado ajustado
rho_d = summary(cl_ml_d)$rho                # rho

compa_d = c(logl_d, rsqrt_d, rho_d)

# Pasamos los datos a Time Series
tsbfa_cl_ml_d = ts(cl_ml_d_salida,
                   start= c(2001,1),
                   end= c(2018,12),# con pronóstico
                   frequency=12,
                   deltat=1/12,
                   ts.eps = 0.05,
                   class = "ts"
                    )

class(tsbfa_cl_ml_d)
tsbfa_cl_ml_d

# Graficamos para comparar
x11(); 
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
plot(tsbfa_cl_ml_d, 
     col = "red",
     lwd = 1,
     lty= 2,
     main="Serie estimada y Original",
     ylab=" ",
     sub="Estimada = Rojo"
    ); lines(bf, 
             col = "black",
             lwd = 1,
             lty= 1,
             ylab=" ",
             )
plot(tsaf_IMAE, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia 1",
     ylab=" ",
    )
plot(tsaf_empleo, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia 2",
     ylab=" ",
    )

#-----------------------------------------------------------------------------#

# Comparación de métodos
x11()
par(mfrow=c(2,2))
plot(tsbfa_cl_ml_a, lwd = 2, lty= 1, main="chow-lin-maxlog", ylab=" ");lines(bf, lwd = 1, lty= 3)
plot(tsbfa_cl_ml_b, lwd = 2, lty= 1, main="chow-lin-minrss-ecotrim", ylab=" ");lines(bf, lwd = 1, lty= 3)
plot(tsbfa_cl_ml_c, lwd = 2, lty= 1, main="chow-lin-minrss-quilis", ylab=" ");lines(bf, lwd = 1, lty= 3)
plot(tsbfa_cl_ml_d, lwd = 2, lty= 1, main="chow-lin-fixed", ylab=" ");lines(bf, lwd = 1, lty= 3)

# Indicadores de regresión
resumen_cl = matrix(c(compa_a,compa_b,compa_c,compa_d),nrow=3,ncol=4)
resumen_cl

# ----------------------------------------------------------------------------#

#                             Método 6 - "fernandez"
#                          Para series no cointegradas

#----------> Sin indicador se recomienda Denton

# ----------------------------------------------------------------------------#

# "fernandez"
fer = td(bf ~ 0 + tsaf1 + tsaf2,                # con indicador
             to = 12,                           # mensual
             method = "fernandez",
             conversion = criterio,             # consistente con la average
             truncated.rho = 0,                 # p autorregresivo no acepta negativos
             #fixed.rho = 0.5,                  # p autorregresivo fijo
            )

# Extraemos la serie resultante
fer_salida = predict(fer)

# Resumen del método
summary(fer)
logl_fer = summary(fer)$logl              # logl
rsqrt_fer = summary(fer)$adj.r.squared    # r cuadrado ajustado
rho_fer = summary(fer)$rho                # rho

compa_fer = c(logl_fer, rsqrt_fer, rho_fer)

# Pasamos los datos a Time Series
tsbfa_fer = ts(fer_salida,
                   start= c(2001,1),
                   end= c(2018,12),# con pronóstico
                   frequency=12,
                   deltat=1/12,
                   ts.eps = 0.05,
                   class = "ts"
                    )

class(tsbfa_fer)
tsbfa_fer

# Graficamos para comparar
x11(); 
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
plot(tsbfa_fer, 
     col = "red",
     lwd = 1,
     lty= 2,
     main="Serie estimada y Original",
     ylab=" ",
     sub="Estimada = Rojo"
    ); lines(bf, 
             col = "black",
             lwd = 1,
             lty= 1,
             ylab=" ",
            )
plot(tsaf_IMAE, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia 1",
     ylab=" ",
    )
plot(tsaf_empleo, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia 2",
     ylab=" ",
    )

# ----------------------------------------------------------------------------#

#                             Método 7 - "litterman"
#                          Para series no cointegradas

# Incluye:
#       a. "litterman-maxlog"
#       b. "litterman-minrss"
#       c. "litterman-fixed"

#----------> Sin indicador se recomienda Denton

# ----------------------------------------------------------------------------#

# a. "litterman-maxlog"
lit_a = td(bf ~ 0 + tsaf1 + tsaf2,          # con indicador
         to = 12,                           # mensual
         method = "litterman-maxlog",
         conversion = criterio,             # consistente con la average
         truncated.rho = 0,                 # p autorregresivo no acepta negativos
         #fixed.rho = 0.5,                  # p autorregresivo fijo
         )

# Extraemos la serie resultante
lit_a_salida = predict(lit_a)

# Resumen del método
summary(lit_a)
logl_lit_a = summary(lit_a)$logl              # logl
rsqrt_lit_a = summary(lit_a)$adj.r.squared    # r cuadrado ajustado
rho_lit_a = summary(lit_a)$rho                # rho

compa_lit_a = c(logl_lit_a, rsqrt_lit_a, rho_lit_a)

# Pasamos los datos a Time Series
tsbfa_lit_a = ts(lit_a_salida,
               start= c(2001,1),
               end= c(2018,12),# con pronóstico
               frequency=12,
               deltat=1/12,
               ts.eps = 0.05,
               class = "ts"
                )

class(tsbfa_lit_a)
tsbfa_lit_a

# Graficamos para comparar
x11(); 
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
plot(tsbfa_lit_a, 
     col = "red",
     lwd = 1,
     lty= 2,
     main="Serie estimada y Original",
     ylab=" ",
     sub="Estimada = Rojo"
    ); lines(bf, 
             col = "black",
             lwd = 1,
             lty= 1,
             ylab=" ",
            )
plot(tsaf_IMAE, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia 1",
     ylab=" ",
    )
plot(tsaf_empleo, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia 2",
     ylab=" ",
    )

# ----------------------------------------------------------------------------#

# b. "litterman-minrss"
lit_b = td(bf ~ 0 + tsaf1 + tsaf2,             # con indicador
           to = 12,                            # mensual
           method = "litterman-minrss",
           conversion = criterio,              # consistente con la average
           truncated.rho = 0,                  # p autorregresivo no acepta negativos
           #fixed.rho = 0.5,                   # p autorregresivo fijo
            )

# Extraemos la serie resultante
lit_b_salida = predict(lit_b)

# Resumen del método
summary(lit_b)
logl_lit_b = summary(lit_b)$logl              # logl
rsqrt_lit_b = summary(lit_b)$adj.r.squared    # r cuadrado ajustado
rho_lit_b = summary(lit_b)$rho                # rho

compa_lit_b = c(logl_lit_b, rsqrt_lit_b, rho_lit_b)

# Pasamos los datos a Time Series
tsbfa_lit_b = ts(lit_b_salida,
                 start= c(2001,1),
                 end= c(2018,12),# con pronóstico
                 frequency=12,
                 deltat=1/12,
                 ts.eps = 0.05,
                 class = "ts"
                 )

class(tsbfa_lit_b)
tsbfa_lit_b

# Graficamos para comparar
x11(); 
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
plot(tsbfa_lit_b, 
     col = "red",
     lwd = 1,
     lty= 2,
     main="Serie estimada y Original",
     ylab=" ",
     sub="Estimada = Rojo"
    ); lines(bf, 
             col = "black",
             lwd = 1,
             lty= 1,
             ylab=" ",
            )
plot(tsaf_IMAE, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia 1",
     ylab=" ",
    )
plot(tsaf_empleo, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia 2",
     ylab=" ",
    )

# ----------------------------------------------------------------------------#

# c. "litterman-fixed"
lit_c = td(bf ~ 0 + tsaf1 + tsaf2,            # con indicador
           to = 12,                           # mensual
           method = "litterman-fixed",
           conversion = criterio,             # consistente con la average
           truncated.rho = 0,                 # p autorregresivo no acepta negativos
           #fixed.rho = 0.5,                  # p autorregresivo fijo
            )

# Extraemos la serie resultante
lit_c_salida = predict(lit_c)

# Resumen del método
summary(lit_c)
logl_lit_c = summary(lit_c)$logl              # logl
rsqrt_lit_c = summary(lit_c)$adj.r.squared    # r cuadrado ajustado
rho_lit_c = summary(lit_c)$rho                # rho

compa_lit_c = c(logl_lit_c, rsqrt_lit_c, rho_lit_c)

# Pasamos los datos a Time Series
tsbfa_lit_c = ts(lit_c_salida,
                 start= c(2001,1),
                 end= c(2018,12),# con pronóstico
                 frequency=12,
                 deltat=1/12,
                 ts.eps = 0.05,
                 class = "ts"
                 )

class(tsbfa_lit_c)
tsbfa_lit_c

# Graficamos para comparar
x11(); 
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
plot(tsbfa_lit_c, 
     col = "red",
     lwd = 1,
     lty= 2,
     main="Serie estimada y Original",
     ylab=" ",
     sub="Estimada = Rojo"
    ); lines(bf, 
             col = "black",
             lwd = 1,
             lty= 1,
             ylab=" ",
             )
plot(tsaf_IMAE, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia 1",
     ylab=" ",
    )
plot(tsaf_empleo, 
     col = "black",
     lwd = 1,
     lty= 2,
     main="Serie de referencia 2",
     ylab=" ",
    )

#-----------------------------------------------------------------------------#

# Comparación de métodos para series no cointegradas
x11()
par(mfrow=c(2,2))
plot(tsbfa_fer, lwd = 2, lty= 1, main="fernandez", ylab=" ");lines(bf, lwd = 1, lty= 3)
plot(tsbfa_lit_a, lwd = 2, lty= 1, main="litterman-maxlog", ylab=" ");lines(bf, lwd = 1, lty= 3)
plot(tsbfa_lit_b, lwd = 2, lty= 1, main="litterman-minrss", ylab=" ");lines(bf, lwd = 1, lty= 3)
plot(tsbfa_lit_c, lwd = 2, lty= 1, main="litterman-fixed", ylab=" ");lines(bf, lwd = 1, lty= 3)

# Indicadores de regresión
resumen_no_coint = matrix(c(compa_fer,compa_lit_a,compa_lit_b,compa_lit_c),nrow=3,ncol=4)
resumen_no_coint

#-----------------------------------------------------------------------------#

#               Para terminar (algunos paquetes alternativos)

# Fuera de R, hay varios paquetes de software para realizar la desagregación 
# temporal: Ecotrim de Barcellan et al. (2003); una extensión de Matlab de Quilis
# (2012); y una extensión RATS de Doan (2008).

#-----------------------------------------------------------------------------#

# FIN