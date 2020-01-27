# Introduccion a Julia:
# Parte 2: Manipulacion de datos en Julia
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
# 1) Variables y Matrices
################################################################################

### Asignacion de variables escalares ###
a = 1    # Crea la variable "a" cuyo valor es "1"
b = 1+1  # Podemos utilizar Julia como una calculadora
c = a+b  # Podemos hacer operaciones aritmeticas con las var en el workspace
c = c+1  # Podemos sumar de forma iterativa una variable

# Importante: A diferencia de Python, Julia no copia los valores escalares
a = 1
b = a + 1
a = 10
5 % 2 # Residuo de la division

# Pero a diferencia de Matlab y R, si copia arreglos, matrices y vectores
A = ["Algo" 2; 3.1 true];
B = A;
A[1,1] = "Cambio";
A
B 

# Para evitar este comportamiento, podemos usar copy()
A = ["Algo" 2; 3.1 true];
B = copy(A);
A[1,1] = "Cambio";
A
B 

# Si el arreglo tiene sub-arreglos, deepcopy() aplicara esto a todos los subarreglos
A = [1 2 3]
B = ["Algo", A]
C = copy(B)
D = deepcopy(B)
A[1] = 45
C[2] 
D[2]

# Tambien podemos asignar el resultado de una funcion
e = rand() # Generamos una variable aleatoria uniforme y la llamamos "e"

# Noten que Julia es sensible a mayusculas y minusculas
a  # Nos muestra el valor de la variable "a"
A  # Nos arroja un error indicando que no existe esta variable en la memoria

# Julia permite usar cualquier caracter unicode (UTF-8)!
α = 5
α

🐐 = "Messi"
🐐

# Y hacer operaciones
🍕  = 5
🍔  = 4
🍕>🍔

# Inclusive opara definir funciones
∑(x,y) = x + y
∑(1,2)

# Y algunas constantes estan ya guardadas
# pi (+ press Tab) 			# returns 3.14...
# ℯ
# Base.MathConstants.golden
pi
π
ℯ
ℯ - exp(1)
Base.MathConstants.golden

# Usar variables griegas hara mas facil leer el codigo
# Pero no recomiendo usar emojis y otros caracteres mas exoticos
# Ya que no aparecen en el worskpace de forma clara y haran mas dificil
# testear el codigo

# Julia exige que el nombre de una variable empiece por una letra
# El nombre puede contener "_" pero no espacios
numeroBalonesOroMessi      = 5
numero_balones_oro_ronaldo = 5

### Crear vectores ###
A = [1   2]     # Vector de dimension 1x2
B = [1 ; 2]     # Vector de dimension 2x1
C = hcat(1,2)   # Comando para concatenar de forma horizontal
D = hcat(A,C)   # Tambien se puede usar para concatenar vectores

# Contrario a Matlab, el ; en un vector/matriz tiene el mismo efecto que el ,
v1 = [1; 2; 3]
v2 = [1, 2, 3]

### Crear Matrices ###
AA = [1 ; 2 ]        # Matriz 2x1
BB = [1   2]         # Matriz 1x2
CC = [1 2 ; 3 4]     # Matriz 2x2

### Manipular Matrices ###
FF = CC                   # Crear una matriz duplicado
FF                        # Ver en el command window
FF[1,1] = 10              # Asignacion de elementos de la matriz
FF                        # Ver en el command window
FF[1,2]                   # Seleccion del elemento en la posicion (1,2)
GG = hcat(FF,[5; 6])      # Contatenar vector columna a una matriz
GG                        # Ver en el command window
GG = vcat(GG,[7 8 9])     # Contatenar vector fila a una matriz
GG                        # Ver en el command window
GG = [GG;GG]              # Otra forma de concatenar
GG[:,1]                   # Seleccionar todos los elementos de la 1er columna
GG[1,1:2]                 # Elementos 1 hasta 2 de la primera fila
GG[2:end,2]               # Elementos de la 2da columna, excepto el primero
GG = GG[1:2,:]            # Extraer sub-matriz
AA[end]		              # Ultimo elemento de AA
AA[end-1]	              # Penultimo elemento de AA

# Note que Julia indexa los valores de una matriz primero por filas
A = [10 20 30 ; 40 50 60 ; 70 80 90]
A[1]
A[2]
A[3]
A[4]
A[5]
A[6]
A[7]
A[8]
A[9]

################################################################################
# 2) Tipos de Datos
################################################################################

# Contamos con la funcion typeof() para verificar el tipo de una variable
a = 1
typeof(a)

# Podemos ver la representacion binaria de la variable usando bitstring()
bitstring(a)

# Añadir un .0 cambia el tipo de variable a flotante
a = 1.0
typeof(a)
bitstring(a)

# Podemos usar isa() para verificar el tipo de variable
isa(a,Float64)

# Otras utiles
iseven(2)
isodd(2)
ispow2(4)
isfinite(a)
isinf(a)
isnan(a)

# Otros comandos nos dicen la maxima y minima representacion en la maquina de
# un tipo de variable
typemax(Int64)
typemin(Int64)
typemin(Float64)
typemin(Float64)
eps(Float64)

1.0 + eps(Float64)
precision(Float64)	# Numero de bits en la mantisa

# Una particularidad de Julia es que cuenta con el tipo "irracional"
typeof(π)

# Otro tipo interesante es el tipo "racional"
a = 1 // 2
typeof(a)
b = 3//7
c = a+b
numerator(c)
denominator(c)
a = 1 // 0
a = 0 // 0


# Podemos usar :: para fijar el tipo de una variable
a::Float64
a = "Hello"
a::Float64

# Otros tipos de variables
a = 0x3				# Entero sin signo en base hexadecimal
a = 0b11			# Entero sin signo en base binaria
a = 3.0				# Flotante 64
a = 4 + 3im		    # Imaginario
a = complex(4,3)	# Lo mismo
a = true			# Valor logico
a = "String"	    # string
const aa = 1        # constant

# En problemas que requieran mucha precision, podemos usar
BigFloat(2.0^66) / 3

# Julia cuenta con un sistema interno de promocion de tipos de variable
# que es clave para su desempeño. Esta utiliza una jerarquia entre tipos de
# variable para inicializarlas y "promocionarlas", dependiendo de la necesidad
a = Any[1 2 3; 4 5 6] # Any es un tipo de objeto abstracto del cual todos los demos tipos hacen parte
typeof(a)
b = convert(Array{Float64}, a)
typeof(b)
c = (1,1.0)
typeof(c)
d = [1,1.0]
typeof(d)
e = promote(c)
typeof(e)
supertype(Float64)
subtypes(Integer)
supertype(Rational)

# Pueden consultarse en:
# https://discourse.julialang.org/t/diagram-with-all-julia-types/5018

################################################################################
# 3) Trabajar con Datos
################################################################################

# La libreria DataFrames permite utilizar esta estructura como en R
using DataFrames

# Los dataframes son una especie de lista que guarda "columnas" de datos
# relacionados. Por lo general, cada columna corresponde a una variable pero
# cada columna puede contener un tipo diferente de dato

# Para ilustrar su uso, utilizaremos una correlacion interesante que hay entre
# el numero de peliculas en que ha aparecido Nicolas Cage cada 12 meses con el
# numero de editoras mujeres de la revista "Harvard Law Review", disponible en:
# http://tylervigen.com/view_correlation?id=9224

# Primero, organizamos los vectores de datos

# No. de peliculas en que aparecio Nicolas Cage entre 2005 y 2009
NC = [2 3 4 1 4]

# No. de muejeres editoras en "Harvard Law Review" entre 2005 y 2009
ME = [9;14;19;12;19]

# Ahora construimos un data frame.
CorrelacionEspurea = DataFrame(NC=[2,3,4,1,4],ME=[9,14,19,12,19])

# Veamos como luce un data frame
describe(CorrelacionEspurea)

# Vemos que tiene tipo DataFrame
typeof(CorrelacionEspurea)

# Podemos acceder a las variables de un dataframe usando la misma notacion
# que para matrices
CorrelacionEspurea[1,2]   # Primera fila, segunda columna
CorrelacionEspurea[:,2]   # Toda la segunda columna
CorrelacionEspurea[2,:]   # Toda la segunda fila

# Tambien podemos acceder directamente usando campos
CorrelacionEspurea.ME
CorrelacionEspurea.NC

# O uando el nombre como indice
CorrelacionEspurea[:,:ME]

# La funcion names() permite saber el nombre de las columnas
names(CorrelacionEspurea)

# Para graficar desde un DataFrame, es necesario usar @df y StatsPlots
using StatsPlots
fechas = ["Year 2005","Year 2006","Year 2007","Year 2008","Year 2009"]
@df CorrelacionEspurea plot(fechas, [:NC :ME])

################################################################################
# 5) Cargar Datos Desde Archivos Externos
################################################################################

### Directorio de Trabajo ###
# Antes de cargar datos desde un archivo externo, debemos asegurarnos que el
# directorio de trabajo de Julia sea el mismo donde se encuentran el archivo
# Con el comando setwd() cambiamos el directorio donde nos encontramos ubicados

#filePath = "C:\\Users\\agutieda\\Desktop\\MSD-PES-Guatemala 2020\\Part 2 - Introduction to Julia\\2 - Learn Julia\\2 - Data Manipulation"
filePath = @__DIR__
cd(filePath)
pwd()

# En el directorio hay varios archivos con una serie de tiempo del PIB anual de
# Guatemala en USD de 2010, en diferentes formatos

# Vamos a ver como cargar el archivo para cada formato

### Archivo de texto
# Podemos ingresar una ruta completa para el archivo, de lo contrario, se
# interpretara como una ruta relativa al directorio actual

# Estos tres son equivalentes si estoy en mi escritorio:
using DataFrames, Plots
datos_desde_texto = readtable("PIB.txt",header=true,separator =' ')
plot(datos_desde_texto.Guatemala)

### Archivo CSV (Comma-Separated Values)
using CSV, Plots
datos_desde_csv = CSV.read("PIB.csv")
datos_desde_csv
@df datos_desde_csv plot(:Year,:Guatemala)
plot(datos_desde_csv.Guatemala)

# Esto tambien funcionan
datos_desde_csv2 = readtable("PIB.csv",header=true)

### Archivo de Excel

# Archivo xls
using ExcelFiles, DataFrames, Plots
datos_desde_xls = DataFrame(load("PIB.xls","PIB"))
plot(datos_desde_xls.Guatemala)

# Archivo xlsx
using ExcelFiles, DataFrames, Plots
datos_desde_xlsx = DataFrame(load("PIB.xlsx","PIB"))
plot(datos_desde_xlsx.Guatemala)

################################################################################
# 5) Cargar Datos Desde Internet
################################################################################

# Cargamos la libreria FredData
using FredData, StatsPlots

# Primero debemos crear una cuenta en FRED y solicitar "API Key"
my_API_KEY = "774d3d91735228d35827d32e5c405dc8"

# La funcion Fred nos creara una conexion con el API de FRED
f = Fred(my_API_KEY)

# Podemos usar el comando get_data para descargar directamente una serie
# usando su token, si ya lo conocemos
gdpFRED_1 = get_data(f, "GDPC1")

# La funcion crea una estructura cuyos campos contienen la informacion
# de la variable descargada
gdpFRED_1

# Extraemos el DataFrame
tableFRED1=gdpFRED_1.data

# Podemos acceder a los datos en el campo "data"
@df tableFRED1 plot(:date,:value)

# Tambien podemos ingresar todas las opciones disponibles en el API
data = get_data(f, "GDPC1"; vintage_dates="2008-09-15")
data = get_data(f, "GDPC1"; frequency="a", units="chg")

# Pueden consultar mas opciones en
# https://research.stlouisfed.org/docs/api/fred/series_observations.html
