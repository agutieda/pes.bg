# Introduccion a Julia:
# Parte 3: Funciones en Julia
#
# Angelo Gutierrez Daza
# 2020
#
# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala
#
# Codigo probado utilizando la version 1.2.0-2 de Julia Pro

################################################################################
# 1) Funciones Predefinidas
################################################################################

clearconsole()

############ La funcion mas importante de todas: La ayuda ######################

# Podemos ingresar en modo ayuda al insertar "?" en el REPL
# De forma alternativa, podemos usar apropos() para buscar palabras clave
apropos("Diagonal")

################################################################################

# Requerimos la libreria LinearAlgebra, que viene por defecto con Julia
using LinearAlgebra

### Funciones para crear vectores
A = 1:10   # Crear vectores con sucesiones de variables
A # Note que est obj es de tipo "rango", ideal para usar como iterador
typeof(A)

# Para llenar este vector, podemos usar collect()
B = collect(1:10) 
B 
typeof(B)

# Rangos con saltos y en orden inverso
C = 1:2:10    
D = 10:-2:1   

### Funciones para crear matrices

# Algunas basicas
zeros(2,2)	 # Matriz de ceros
ones(2,2)	   # Matriz de 1's
fill(2,3,4)	 # Matriz 3x4 llena de 2's
trues(2,2)	 # Matriz 2x2 de "True"
falses(2,2)	 # Matriz 2x2 de "False"
rand(2,2)  	 # Matriz 2x2 de v.a. uniformes
randn(2,2)	 # Matriz 2x2 de v.a. normal estandar

# Podemos usar diagm para crear matrices "llenas" especificando la diagonal
diagm(0 => [1,2,1])              
diagm(0 => [1,2,1])              
diagm(1 => [1,2,3], -1 => [4,5])

# Julia cuenta con versiones mas eficientes para la memoria
Diagonal([1,2,3])
Bidiagonal([1,2,3,4,5],[1,1,1,1] , :U)
Bidiagonal([1,2,3,4,5],[1,1,1,1] , :L)

# Mientras que diag (note la minuscula) recupera la diagonal de la matriz
diag(A) 

### Operaciones sobre matrices

# Definamos algunas matrices
A = [ 1 2 ; 3 4 ]  
B = [ 5 6 ; 7 8 ]
C = [ 9 0 ; 1 2 ]
d = [ 1 ; 0 ]            

### Las basicas
B'         # Transpuesta (en realidad matriz conjugada)
A*B        # Multiplicacion de matrices
B*d        # Multiplicacion de matrices
A.*B       # Producto punto de matrices
A^2        # Potencia de matriz (AxA)
inv(A)     # Inversa
pinv(A)    # Pseudo-Inversa (Moore-Penrose)
det(A)     # Determinante
tr(A)      # Traza
rank(A)    # Rango
eigen(A)   # Valores y vectores propios
eigvals(A) # Eigen-Valores
eigvecs(A) # Eigen-Vectores
size(A)    # Dimensiones
nrow, ncol = size(A)
A\d        # Resuelve A*x==d, mejor que usar inv(M)*v

### Por fila/columna
A
sum(A)               # Suma de todos los elementos de A
sum(A,dims=1)        # Suma de cada columna
sum(A,dims=2)        # Suma de cada fila
maximum(A)           # Max de todos los elementos de A
maximum(A,dims=1)    # Max de cada columna
maximum(A,dims=2)    # Max de cada fila
minimum(A)           # Min de todos los elementos de A
minimum(A,dims=1)    # Min de cada columna
minimum(A,dims=2)    # Min de cada fila
mean(A)              # Mean de todos los elementos de A
mean(A,dims=1)       # Mean de cada columna
std(A)               # SD de todos los elementos de A
std(A,dims=1)        # SD de cada columna
var(A,dims=1)        # Mean de cada columna
median(A,dims=2)     # Mean de cada columna

# En general, podemos usar . para aplicar una operacion elemento
A .+ B
A .- B
A .* B
A ./ B
A .^ B
A .% B

### Curiosidad
# Julia cuenta con la matriz identidad I que adapta automaticamente su tamaño
# a las operaciones en que se use sin tener que definirla!
A = [1 2; 3 4]
inv(I-A)
B = [1 2 3; 4 5 6; 7 8 9]
inv(I-B)
C = A + I
D = B*I

# Algunas funcione se pueden operan sobre escalares
a = 1.2
abs(a)		 # Valor absoluto
abs2(a)		 # Cuadrado
sqrt(a)		 # Raiz cuadrada
cbrt(a)		 # Raiz cubica de 2
exp(a)		 # Exponente de 2
exp2(a)		 # Potencia a de 2
log(a)		 # Log natural de a
log(2,a)	 # Log base n de a
real(a)		 # Parte real
imag(a)		 # Parte imaginaria
reim(a)		 # Parte real e imaginaria (como tuple)
sign(a)		 # Signo
round(a)	 # Redondear al flotante natural mas cercano
ceil(a)		 # Redondear arriba
floor(a)	 # Redondear abajo
mod(a,b)	 # Modulo a,b

# Las operaciones son tambien funciones
1+2
+(1,2)
methods(+)
methods(exp)

# Para aplicarlas elemento por elemento, usamos la funcion map()
A = [1 0; 0 -1]
B = map(abs,A)

# Podemos usar map inclusive con funciones anonimas
C = map(x->3*x+2 , A) 

# Podemos crear arreglos de funciones y evaluarlas como tal
a = [exp, abs]
a[1]
a[1](3)

# Otra curiosidad: En Julia, expresiones como 2x calculan el producto 2x
x = 2
2x
2x+2

# Podemos usar tambien iteradores 
x+=1		# x = x+1
x-=2		# x = x-2
x*=3		# x = 3*x
x/=4		# x = x/4
x^=5		# x = x^5

# Una curiosidad mas de Julia: Las funciones que terminan en ! ("push")
# cambian el objeto original!
a = [5,3,4,2,1]
sort(a)
a
sort!(a)
a

# Las funciones ! son importantes para alterar variables existentes
A = [1,2,3]
A[4] = 4 # Error! (Pero funciona en Matlab!)
push!(A,4)
A
A[4] = [] # Error! (Pero funciona en Matlab!)
pop!(A)
A
A[A.>1,:] = [] # Error! Maldita sea, Matlab!
filter!(x->x.>1,A)

# Esta clase de funciones es recomendada cuando se requiera modificar ya
# que hacen un uso mas eficiente de la memoria al evitar la copia de elementos

# Finalmente, hay funciones para operar sobre conjuntos!
a = [2,1,3]
b = [2,4,5]
union(a,b)	
intersect(a,b)
setdiff(a,b)	
setdiff(b,a)	

###### Funciones para generar y trabajar con numeros aleatorios
using Distributions, Plots

# Julia cuenta con las funciones rand() y randn() en su libreria base
M =  rand(10000)   # Vector de 10 realizaciones de una uniforme(0,7)
N = randn(10000,2) # Matriz 10x2 de 1000 realizaciones de una normal(0,1)
histogram(M, bins=50)
histogram(N, bins=50)

# La libreria Distributions nos ofrece una interface para generar 
# v.a. de muchas otras distribuciones

# Para usarla, primero especificamos la familia de distribuciones
la_elegida = Normal(0,5)

# Y podemos usar rand() simular de la distribucion
X = rand(la_elegida,1000,2)
histogram(X,bins=50)

# Y otras funciones de la libreria para calcular momentos
pdf.(la_elegida, 0)
cdf.(la_elegida, 0)
quantile.(la_elegida, [0.25 , 0.50, 0.95])

# Podemos inclusive truncar la distribucion
truncada = Truncated(Normal(0, 1), 0, 3)
X = rand(truncada,1000)
histogram(X,bins=50)
pdf.(truncada, 0)
cdf.(truncada, 0)
quantile.(truncada, [0.25 , 0.50, 0.95])

# Podemos hacerlo para muchas otras distribuciones ademas de la normal
fieldnames(Binomial)
fieldnames(Multinomial)
fieldnames(Cauchy)
fieldnames(Beta)
fieldnames(MvNormal)

# Puede consultarse la lista completa en
# https://juliastats.org/Distributions.jl/v0.21/index.html

# Otras funciones utiles para trabajar con numeros aleatorios
using Random
A = [1,2,3,4,5,6]
B = randsubseq(A,0.3) # Muestra aleatoria de elementos de A, incluidos con probabilidad 0.3
C = shuffle(A)        # Permutacion aleatoria de elementos de A
D = randperm(5)       # Permutacion aleatoria de numeros de 1 a 5
Random.seed!(123)     # Fijar la semilla del generador de numeros aleatorios

# El paquete StatsBase nos ofrece otra funcion para generar muestras 
# aleatorias con o sin remplazamiento
using StatsBase
A = 1:10
sample(A,5, replace=true, ordered=false)
sample(A,5, replace=false, ordered=false)

################################################################################
# 2) Definir Funciones
################################################################################

### Podemos definir funciones de varias formas: 

# Con una sola linea
mi_primer_funcion(x) = x+1

# Con varias lineas 
function mi_tercer_funcion(x)
	x+1
end

# Con varias lineas (estilo R, no recomendado)
mi_segunda_funcion = function(x)
	x+1
end

mi_primer_funcion(1)
mi_segunda_funcion(1)
mi_tercer_funcion(1)

# Tambien tenemos a nuestra dispocision funciones anonimas
x -> x.^2			# Funcion anonima
f_anonima = x -> x.^2	# Funcion anonima con nombre
f_anonima(3)
f_anonima([3.0,2.0])

# Por defecto, el output es el ultimo valor calculado en la funcion
# Se recomienta el uso de return para especificar el output
function funcion_sin_argumentos()
  output = "Hola"
	return output
end
funcion_sin_argumentos()

# Podemos recibir varios argumentos y devolver varios argumentos como tuplas
function test_fun(x,y)
  z1 = x^2 + 2y
  z2 = x + y
	return z1 , z2
end
test_fun(2,1)

# O como arreglos
function test_fun(x,y)
  z1 = x^2 + 2y
  z2 = x + y
	return [z1  z2]
end
test_fun(2,1)

# Podemos especificar argumentos opcionales
function test_fun_2(x,y=0)
  z1 = x^2 + 2y
  z2 = x + y
	return z1 , z2
end
test_fun_2(2,1)
test_fun_2(2)

# De forma anonima
f_anonima = (x,y) -> (x^2 + y, x+y ) 
f_anonima(2,1)

# Se puede usar los tuples para asignar directamente
function f_otra_mas(a,b)
  a+b, a*b
end
x, y = f_otra_mas(2,3)
x
y

# Los argumentos deben ingresar en orden. Pero se puede usar "keywords" para
# especificar los que entran en cualquier orden
function otra_funcion(x, y; keyword)
  z = 2x+y+keyword
end
otra_funcion(keyword=0, 1, 2) # Hace lo que tiene que hacer
otra_funcion(keyword=0, 2, 1) # Esto no

# La diferencia entre el argumento opcional y el keyword es que este ultimo
# puede aparecer en cualquier orden
function otra_funcion_mas(; opcion1 = 0, opcion2 = 0)
  return opcion1 + 2*opcion2
end
otra_funcion_mas(opcion1=2,opcion2=1)
otra_funcion_mas(opcion2=1,opcion1=2)
otra_funcion_mas()

# Podemos fijar de antemano el tipo de los argumentos
function test_fun_3(var1::Int64, var2::Int64=1; keyword=2)
	output1 = var1+var2+keyword
end
test_fun_3(2.0,2)
test_fun_3(2,2)

# Y del output
function test_again(x,y)::Int8
    return x*y
end
test_again(1.2,1.3)
test_again(1,1)

# Broadcasting: Para evaluar la funcion en un vector, debemos usar la notacion
# ".", sin necesidad de definir internamente la funcion (como en Matlab)
f(x) = x^2             # En Matlab seria x.^2
g(x, y) = x + 2 + y^2  # En Matlab seria x + 2 + y.^2 
x = 1:5
y = 1:5
f.(x)
g.(x, y)

# Multiple dispatch
una_funcion(var1,var2) = var1+var2+1
methods(una_funcion)

# Funciones de alto nivel: Funciones que definen funciones!
function f_mama(var1)
	function f_hija(var2)
		nieta = var1+var2
		return nieta
	end
	return f_hija
end
f_nieta_1 = f_mama(1)	# f_nieta_1: Produce 1+var2
f_nieta_2 = f_mama(2)	# f_nieta_2: Produce 2+var2
f_nieta_1(1)
f_nieta_2(1)

# Hemos visto ya la funcion map()
# Esta hace parte del paradigma de programacion "mapreduce"
#  https://www.dummies.com/programming/big-data/data-science/the-mapreduce-programming-paradigm/
map(x->3*x+2,A) 
reduce(+,[1,2,3])	# generic reduce
mapreduce(x->x*x, +, [1,2,3])        # 1*1 + 2*2 + 3*3
mapreduce((x) -> x^3, +, 9, [1:3])   # (1^3 + 2^3 + 3*3) + 9 
mapreduce((x) -> -x, *, [8:10])      #  -8 * -9 * -10
