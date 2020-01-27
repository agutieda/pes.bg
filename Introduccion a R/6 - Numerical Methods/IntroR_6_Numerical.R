# Introduccion a R: 
# Parte 6) Metodos Numericos en R
#
# Angelo Gutierrez Daza
# 2020
#
# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala
#
# Codigo probado utilizando la version 3.6.1 de R

graphics.off(); rm(list=ls());

################################################################################
# 0) Introduccion
################################################################################

# Es comun encontrarse con problemas en Economia y Estadistica que requieran 
# derivar una funcion objetivo para calcular sus condiciones de primer orden,
# optimizar dicha funcion objetivo o resolver el sistema de ecuaciones
# caracterizado por las condiciones de primer orden del problema de optimizacion

# Estos problemas pueden resolverse con lapiz y papel solo en casos especiales 
# bajo supuestos a veces heroicos y restricciones parametricas que no siempre 
# estan acordes con la evidencia empirica

# Con los computadores, podemos resolver problemas mas complejos y relevantes
# que podremos utilizar para responder preguntas de todo tipo, construir 
# pronosticos y elaborar escenarios contra-factuales

# Para esto, es necesario conocer las herramientas con las que R cuenta para 
# resolver el tipo de problemas que encontramos comunmente en Economia

# Antes de hacerlo, es importante entender que cuando llevamos un problema de
# estos al computador, solo pueden resolverse de forma APROXIMADA

# Para entenderlo, note que los computadores representan los numeros con una 
# precision limitada, y solo un subconjunto de los numeros reales se puede usar

# Por lo anterior, siempre existe un "error de aproximacion" 
# Una primera medida del error de aproximacion en que se puede incurrir es el
# "error de maquina", que es la diferencia entre el numero "1" y el siguiente
# numero mas cercano en el computador

.Machine # Comando de R para ver el error de maquina 

# El error de aproximacion de una funcion suele ser proporcional a el error de 
# maquina, y potencialmente mas grande 

# Por lo tanto, es bueno recordar que al usar una rutina de optimizacion 
# numerica, podemos encontrar que el minimizador de f(x) = x^2 no es exactamente
# x=0, pero algo muy cercano. De forma importante, esta cercania es algo 
# que en muchas ocasiones podemos controlar

# A continuacion se ilustra como utilizar varias funciones de R que nos 
# permitiran resolver problemas como los que veremos mas adelante en el curso
# de forma numerica

################################################################################
# 1) Optimizacion
################################################################################

# Veremos dos formas: La facil y la dificil

### La facil: Comando optim()

# La forma mas rapida de optimizar es usando la funcion optim() que viene 
# incluido con la instalacion base de R
una_funcion <- function(x) return(x^2+2) # Definimos la funcion f(x)=x^2+2

# Vamos a encontrar el minimo de esta funcion

# Primero, debemos dar al algoritmo numerico un valor inicial
x0 <- 10 

# Luego usamos optim() para minimizar una_funcion
resultados <- optim(x0,una_funcion) 

resultados     # El output de la funcion es una lista
resultados$par # El minimizador de la funcion se guarda en el campo "par"

# Tambien podemos usar funciones con varios argumentos 
# Sin embargo, debemos ingresarlos como un vector
otra_funcion <- function(x) return( x[1]^2+x[2]^2 )
x0 = c(10,10) # El valor inicial debe ser un vector, esta vez
optim(x0,otra_funcion) # Note que el resultado no es exactamente cero

# Podemos reducir esta distancia con un criterio mas exigente
optim(x0,otra_funcion,control = list(reltol=1e-12))

# optim() permite tambien resolver problemas con restricciones de desigualdad

# Aca, minimizamos la misma funcion sujeta a y>=1
optim(x0,otra_funcion,method="L-BFGS-B",lower=c(-Inf,1)) 

### La menos facil: Librerias adicionales

# Algunos problemas de optimizacion pueden ser demasiado complejos o 
# dificiles para los algoritmos utilizados por optim()

# Afortunadamente, R cuenta con un gran numero de librerias que implementan todo
# tipo de algoritmos de optimizacion numerica
# Estas pueden ser consultadas en: 
# https://cran.r-project.org/web/views/Optimization.html

# Aca ilustamos el uso de una de estas: nloptr()

### Paquete nloptr()

# Aca utilizaremos la libreria "nloptr"
install.packages("nloptr")

# Otra vez un ejemplo sencillo de minimizacion
library("nloptr")
otra_funcion <- function(x) return( (x[1]-1)^2+(x[2]-2)^2 )
x0 = c(10,10) 

# El algoritmo BFGS es adecuado para funciones "suaves"
resultados <- lbfgs(x0,otra_funcion)       

# El algoritmo Nelder-Mead, basado en simplex, no requiere calcular derivadas
resultados <- neldermead(x0,otra_funcion)  

# Otro ejemplo: Optimizacion con restricciones de desigualdad e igualdad
# Este ejemplo es tomado directamente de la documentacion de la libreria

# Vamos a resolver el siguiente problema de optimizacion
# \min_{x} x1*x4*(x1 + x2 + x3) + x3
# s.t.
# x1*x2*x3*x4 >= 25
# x1^2 + x2^2 + x3^2 + x4^2 = 40
# 1 <= x1,x2,x3,x4 <= 5

# Para hacerlo, reescribimos la desigualdad como:
# 25 - x1*x2*x3*x4 <= 0
# y la igualdad como:
# x1^2 + x2^2 + x3^2 + x4^2 - 40 = 0

# Primero, definimos la funcion
# f(x) = x1*x4*(x1 + x2 + x3) + x3

eval_f <- function(x) {
    return( 
        list( "objective" = x[1]*x[4]*(x[1] + x[2] + x[3]) + x[3],
              "gradient"  = c( x[1] * x[4] + x[4] * (x[1] + x[2] + x[3]),
                               x[1] * x[4],
                               x[1] * x[4] + 1.0,
                               x[1] * (x[1] + x[2] + x[3]) 
                              ) 
              ) 
            )
}

# Incluir el gradiente hace que el algoritmo sea mas eficiente

# Ahora definimos las restricciones del problema de optimizacion como funciones

# Restricciones de desigualdad:
eval_g_ineq <- function(x) {
    constr <- c( 25 - x[1] * x[2] * x[3] * x[4] )
    grad   <- c( -x[2]*x[3]*x[4],
                 -x[1]*x[3]*x[4],
                 -x[1]*x[2]*x[4],
                 -x[1]*x[2]*x[3]
                )
    return( list( "constraints"=constr, "jacobian"=grad ) )
}

# Restricciones de Igualdad
eval_g_eq <- function(x) {
    constr <- c( x[1]^2 + x[2]^2 + x[3]^2 + x[4]^2 - 40 )
    grad <- c( 2.0*x[1],
               2.0*x[2],
               2.0*x[3],
               2.0*x[4] 
              )
    return( list( "constraints"=constr, "jacobian"=grad ) )
}

# Ahora definimos los valores iniciales
x0 <- c( 1, 5, 5, 1 )

# Y unos valores minimos y maximos que sirvan para acotar la solucion
lb <- c( 1, 1, 1, 1 )  # Valores minimos
ub <- c( 5, 5, 5, 5 )  # Valores maximos

# Especifiquemos el tipo de algoritmo y otras opciones
local_opts <- list(
 "algorithm" = "NLOPT_LD_MMA",
 "xtol_rel" = 1.0e-7
  )

opts <- list(
 "algorithm" = "NLOPT_LD_AUGLAG",
 "xtol_rel" = 1.0e-7,
 "maxeval" = 1000,
 "local_opts" = local_opts
  )

# Ahora si, invoquemos la funcion de optimizacion
res <- nloptr( 
    x0=x0,
	eval_f=eval_f,
    lb=lb,
	ub=ub,
	eval_g_ineq=eval_g_ineq,
	eval_g_eq=eval_g_eq,
	opts=opts
    )

print(res)

################################################################################
# 2) Solucion de Sistemas de Ecuaciones
################################################################################

# R cuenta con muchos paquetes para resolver sistemas de ecuaciones no-lineales

# A continuacion se muestra como utilizar el paquete "nleqslv"
install.packages('nleqslv')
library(nleqslv)

# El paquete nleqsl nos permite encontrar las raices de problemas de la 
# forma f(x)=0, donde x es un vector en Rn

# Primer ejemplo: Una funcion muy facil: f(x)=x-4
muy_facil <- function(x){ return(x-4) } # Claramente, la solucion es x=4

x0 <- 2  # Debemos dar al algoritmo num?eico un valor inicial
resultados <- nleqslv(x0,muy_facil)  # Usamos nleqslv para encontrar x
x_opt <- resultados$x  # Sacamos el valor de x que resuelve la ecuacion
x_opt

# Segundo ejemplo: Misma funcion con argumento adicional
facil <- function(x,a,b){ return(x-a+b) } # Claramente, la solucion es x=a

# Note como el cuarto argumento es para la funcion "facil" (a=5)
resultados <- nleqslv(x0,facil,jac=NULL,b=0,a=5) 
x_opt_2 <- resultados$x 
x_opt_2

# Tercer ejemplo: Sistemas de ecuaciones
menos.facil <- function(X){
  x <- X[1] 
  y <- X[2]
  
  # La funcion recibe un vector y regresa un vector
  return(c(x+y-2,x*y-1))
  } 

x0 <- c(1,1) # Note que esta vez el valor inicial es un vector con dos elementos	
resultados <- nleqslv(x0,menos.facil)
x_opt_3 <- resultados$x 
x_opt_3

################################################################################
# 3) Derivacion Numerica
################################################################################

### Derivadas y Jacobianos ###
# Para calcular derivadas, gradientes, hessianas, etc, de forma numerica, 
# podemos usar la libreria "numDeriv"
install.packages('numDeriv')
library(numDeriv)

### Derivada Numerica
# Para calcular derivadas y gradientes de una funcion, evaluadas en un punto 
# determinado, podemos usar grad()

# Probemos con una funcion de R^1 a R^1
la_funcion <- function(x) return(x^2) 
grad(la_funcion,2)             # Derivada de la funcion f(x)=x^2 evaluada en 2
grad(la_funcion,0)             # Derivada de la funcion f(x)=x^2 evaluada en 0 
grad(la_funcion,-2)            # Derivada de la funcion f(x)=x^2 evaluada en -2

# Derivada de la funcion f(x)=x^2 evaluada en el intevalo discreto -2:0.1:2
grad(la_funcion,seq(-2,2,0.1)) 

# Ahora, intentemos con una funcion de R^2 a R^1
otra_funcion <- function(x) return(x[1]^2+x[2]^2) 
grad(otra_funcion,c(2,2))   # Derivada de la funcion evaluada en (2,2)
grad(otra_funcion,c(1,2))   # Derivada de la funcion evaluada en (1,2)
grad(otra_funcion,c(0,0))   # Derivada de la funcion evaluada en (0,0)
grad(otra_funcion,c(-2,-2)) # Derivada de la funcion evaluada en (-2,-2)

## Jacobiano ##
# La funcion jacobian() del paquete numDeriv nos permite encontrar el jacobiano
# de una funcion de R^n a R^m

# Jacobiano de funcion de R^1 a R^2
funcion_1_a_2 <- function(x) return(c(x^2,x^3))
jacobian(funcion_1_a_2,1) # Jacobiano evaluado en 1
jacobian(funcion_1_a_2,2) # Jacobiiano evaluado en 2

# Jacobiano de funcion de R^2 a R^2 
funcion_2_a_2 <- function(x) return(c(x[1]^2+x[2]^2,x[1]^3+x[2]^3))
jacobian(funcion_2_a_2, c(1,1)) # Jacobiano evaluado en (1,1)
jacobian(funcion_2_a_2, c(1,1)) # Jacobiano evaluado en (2,2)

## Hessiana ##
# Finalmente, el comando hessian() nos permite calcular la matriz Hessiana de
# una funcion de R^n a R^1
la_ultima_funcion <- function(x) return(x[1]^2+x[2]^3) 
hessian(la_ultima_funcion,c(1,1)) # Hessiana evaluada en el punto (1,1)
hessian(la_ultima_funcion,c(1,2)) # Hessiana evaluada en el punto (1,2)
hessian(la_ultima_funcion,c(2,1)) # Hessiana evaluada en el punto (2,1)
hessian(la_ultima_funcion,c(0,0)) # Hessiana evaluada en el punto (0,0)

################################################################################
# 4) Integracion Numerica
################################################################################

# La instalacion base de R cuenta con una funcion para realizar integracion
# numerica que ya vimos anteriormente
una_funcion <- function(x) return((x^2)*cos(x)) # Definimos una funcion
integrate(una_funcion,-1,5) # Integramos, asi de sencillo

# Tambien podemos utilizarla para integrar sobre todo el dominio de la funcion
# (siempre que sea convergente)
otra_funcion <- function(x) return(1/((x+1)*sqrt(x)))
integrate(otra_funcion, lower = 0, upper = Inf)

# Pero integrate() no nos sirve para integrar funciones de varias variables
# Nuevamente, podemos acudir a una de tantas librerias de R
install.packages('cubature')
library(cubature)

# Definamos una funcion de R^2 a R^1
la_integral <- function(x) return(x[1]^2+x[2]^2) 
num.x <- 2 # Numero de inputs
num.y <- 1 # Numero de outputs

# Integracion usando algoritmo deterministico
cuhre(la_integral,lowerLimit=c(0,0),upperLimit=c(1,1)) 

# Integracion por Monte-Carlo
vegas(la_integral,lowerLimit=c(0,0),upperLimit=c(1,1)) 


################################################################################
# 5) Matematica Simbolica
################################################################################

# R no solo realiza computacion numerica
# Podemos utilizarlo tambien para realizar computacion simbolica
# Es decir,  para realizar operaciones matematicas sobre expresiones y simbolos
# que dan como resultado otros simbolos

# La forma mas rapida de hacerlo es usando el comando expression() para definir
# expresiones simbolicas

# Ejemplo: Definir la funcion x^2
sym_fun <- expression(x^2) 
sym_fun
sym_fun[1]
sym_fun[[1]]

# Podemos evaluar la funcion para valores determinados usando el comando eval()
eval(sym_fun, envir=list(x=2))

# O, de forma alternativa
x=2
eval(sym_fun)

# Podemos identificar ademas que variables son simbolicas utilizando all.vars
all.vars(sym_fun)

# Otros comandos como D() permiten encontrar derivadas simples de una funcion
# de una variable de forma simbolica
D_sym_fun <- D(sym_fun,"x")
D_sym_fun
eval(D_sym_fun)

# Finalmente, podemos utilizar el comando deriv() para encontrar el gradiente
# y la matriz Hessiana de una funcion de varias variables

# Primero, definamos una funcion de varias variables
sym_more_fun <- expression(
	x^3 + y^3
	)

sym_more_fun
sym_more_fun[1]
sym_more_fun[[1]]
all.vars(sym_more_fun)

# Ahora, obtengamos el gradiente usando deriv()
D_sym_fun_2 <- deriv(sym_more_fun,c("x","y")) 
D_sym_fun_2 

# Podemos evaluar esta expresion en un punto determinado
x=1; y=1; 
eval(D_sym_fun_2)

# Tambien podemos usar derive para encontrar la matriz Hessiana de f(x,y)
hessian_mat <- deriv(sym_more_fun,c("x","y"),hessian=T) 
hessian_mat 

# Ahora necesitamos attr() para recuperar la matriz Hessiana
hessian_fun <- attr(eval(hessian_mat),"hessian")
hessian_fun[1,,]

# Tambien podemos usar attr() para recuperar el gradiente
gradient_fun <- attr(eval(hessian_mat),"gradient")
gradient_fun

# Podemos usar sapply() para encontrar el jacobiano
sym_more_fun_2 <- expression(
    x^3 + y^3,
    x^2 + y^2
)

sym_jacobian <- sapply(sym_more_fun_2, deriv,c("x","y"))
eval(sym_jacobian[1])
eval(sym_jacobian[2])

# Estas funciones permiten construir "input" para algoritmos numericos
obj_fun <- expression(x^3+x^2+x+1)
foc <- D(obj_fun,"x")
foc
new_fun <-function(x){return(eval(foc))}
new_fun(1)
x11(); plot(-10:10,new_fun(-10:10))

# Ahora usemos la funcion nleqslv
library(nleqslv)
resultados <- nleqslv(1,new_fun)  # Usamos nleqslv para encontrar x
x_opt <- resultados$x  # Sacamos el valor de x que resuelve la ecuacion
x_opt

# Para calculos mas complejos, se pueden consultar las librerias
# "Ryacas" y "rsympy"

################################################################################
# 6) Mencion Especial: PRACMA para ir de Matlab a R
################################################################################

# Matlab es un software y un lenguaje bastante utilizado en para simulacion 
# y programacion numerica en Economia. Especialmente en Macroeocnomia.

# El paquete "pracma" cuenta con muchas funciones que tienen el mismo nombre de
# su contraparte en Matlab e imitan su comportamiento (tanto como pueden)

#install.packages('pracma')
#library(pracma)