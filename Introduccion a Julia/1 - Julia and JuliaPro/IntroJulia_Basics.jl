# Introduccion a Julia
# Parte 1: Julia + Juno-Atom/VS Code-Julia Extension
#
# Angelo Gutierrez Daza
# 2020
#
# Programacion II
# Programa de Estudios Superiores
# Banco de Guatemala
#
# Codigo probado utilizando la version 1.2.0-2 de Julia-Pro

## #############################################################################
# 1) Julia: Comentarios y Editores
################################################################################

# Podemos usar el simbolo "#" para escribir comentarios
a=1 # Estos pueden ir al comienzo de una linea o despues de un comando

#=
Podemos ademas ingresar comentarios de multiples lineas utilizando  "#=" y "=#"
y para marcar su comienzo y su final
=#

##
#=
Podemos crear celdas de codigo usando "##", "#---" o "# %%"
En Juno, podemo usar los atajos Alt+Up y Alt+Down para moverse entre celdas
=#
##

## #############################################################################
# 2) Dar instrucciones a Julia
################################################################################

#=
Por defecto, podemos usar Ctrl+Enter tanto en VS Code como en Juno para enviar
el codigo seleccionado a la REPL

Si no seleccionamos nada, VS Code enviará la linea actual, mientras que Juno
evaluara el bloque de codigo donde este el cursor (por ejemplo, un loop entero
o la parte de adentro de una funcion)

Tambien podemos usar Alt+Enter en ambos editores para correr la celda actual.

En Juno, podemos usar Alt+Shift+Enter para evaluar la celda actual y moverse
a la siguiente.

Para evaluar el script completo, usamos F5 en VS Code y Ctrl+Shift+Enter en Juno

=#

# Primer comando: Imprimir en la pantalla "Hello World"
print("Hello World")

# Segundo comando: Crear la variable "a" cuyo valor es "1"
a = 1

# Tercer comando: Crear el vector fila A = (1,2)
A  = [1,2]

M = [1 2 ; 3 4]

# Podemos usar la tecla "flecha arriba" en el "command window" para ver los
# comandos recientemente utilizados

# Juno cuenta con otros atajos interesantes:
#=
Ctrl+Shift+p     - Open the command panel
Ctrl+Enter       - Evaluate at the cursor
Ctrl+Shift+Enter - Evaluate the current file
Ctrl+j Ctrl+e    - Jump cursor to the editor
Ctrl+j Ctrl+o    - Jump cursor to the REPL
Ctrl+j Ctrl+c    - Clear the console
Ctrl+j Ctrl+s    - Start Julia
Ctrl+j Ctrl+k    - Kill the Julia process
Ctrl+j Ctrl+r    - Open a REPL
Ctrl+j Ctrl+p    - Open the Plot Pane
Ctrl+j Ctrl-d    - Get the documentation for the symbol under the cursor
Ctrl+j Ctrl-g    - Go to the definition of the symbol under the cursor
Ctrl+l           - Clear console, when in console
=#

# Tanto VS Code como Atom son sompletamente configurables y podemos tener
# estos y otros atajos donde queramos

################################################################################
# 3) Workspace
################################################################################

# Informacion de la version de Julia usada
versioninfo()

# Podemos usar el siguiente comando para ver las variables en el workspace
varinfo()

# A diferencia de R o Matlab, no existen formas directas de eliminar una o todas
# las variables en el workspace de Julia

# En su lugar, se recomienda el uso del paquete Revise.jl
# https://timholy.github.io/Revise.jl/stable/

# En juno, podemos usar el siguiente comando para limpiar la consola
clearconsole()

# Lastimosamente, no hay un comando equivalente a "clear" de Matlab para
# limpiar el escritorio
# https://discourse.julialang.org/t/why-julia-has-no-clear-variable/6541

################################################################################
# 4) Directorio de Trabajo
################################################################################

# Podemos obtener el directorio actual usando pwd()
pwd()

# Tambien podemos asignarlo a una variable temporal
tempDir = pwd()
tempDir

# Si deseamos cambiar el directorio de trabajo actual, podemos usar cd()
cd(".\\OtroDirectorio") # Un subdirectorio del directorio actual

# De forma alternativa, podemos dar el path completo
cd("C:\\Users\\agutieda\\Desktop\\")
cd(tempDir)
pwd()

# Por el momento, los IDE's recomendados no cuentan con una interfaz visual
# para hacer esto. En el caso de Juno, se puede hacer a traves de la pestana "Juno".

# Note que podemos pararnos en el REPL de Julia e ingresar ";"
# Esto hace que el REPL entre en modo "shell" lo que hace que se comporte como
# la terminal de nuestro sistema operativo y navegar usando los comandos usuales
# Debemos usar Backspace para regresar al modo Julia

################################################################################
# 5) Librerias
################################################################################

# Comparado con R y Python, Julia cuenta con un numero pequeño pero creciente
# de librerias que pueden consultarse en:
#

# Para instalarlas, debemos ingresar a modo "pkg" en el REPL ingresando la
# tecla ]
#
# En este modo, podemos descargar paquetes de Julia desde repositorios de GitHub
# usando el comando "add"

# Como ejemplo, descarguemos el paquete "Plots" usando "add Plots" en modo Package
# Una vez descargado, usamos el comando "using" y el nombre de la libreria

# Como prueba, vaya al REPL, ingrese "]"  y luego "add Plot"
# Esto instalara un paquete que permite hacer figuras sencillas

# Una vez instalado, podemos cargar la libreria usando "using"
using Plots

# La primera vez que cargamos un paquete, Julia precompila la libreria
# lo que hace que tarde un poco, pero esto solo ocurrira la primera vez

# De forma alternativa, podemos cargar la libreria Pkg y usar la funcion "add"
# para instalar un paquete

# Aca instalamos el paquete IJulia que permite usar Jupyter con Julia
using Pkg
Pkg.add("IJulia")

#******************** Opcional: No siempre funciona ****************************
# Se puede usar la siguiente linea para especificar el directorio donde esta
# la instalaciona actual de Jupyter.De lo contrario, notebook() pedira instalar
# version light de anaconda (que de todos modos pesa mas de 1GB) para poder
# usar notebook()
# using Pkg
# ENV["JUPYTER"] ="C:\\ProgramData\\Anaconda3\\Scripts\\jupyter-notebook.exe"
# Pkg.build("IJulia")
# Una vez instalado, podemos abrir Jupyter y crear un notebook para Julia o, de
# forma alternativa, podemos usar la funcion notebook() en Julia
# using IJulia
# notebook()
#*******************************************************************************

#=
Otros comandos que podemos usar para administrar paquetes incluyen:
st         # checks status
up IJulia  # update IJulia
rm IJulia  # remove package
update     # update packages
=#


# Otras librerias recomendadas para instalar
using Pkg
Pkg.add("Compat") # Permite compatibilidad con versiones pasadas de Julia
Pkg.add("Optim")  # Rutinas de optimizacion no-restringida
Pkg.add("JuMP") # Metodos para resolver problemas de optimizacion
Pkg.add("Interpolations") # Funciones para interpolar numericamente
Pkg.add("Distributions") # Rutinas para evaluar y simular variables aleatorias
Pkg.add("Expectations") # Calcular valor esperado de variables en paquete anterior
Pkg.add("DataFrames") # Soporte a tablas de datos
Pkg.add("JuliaDB") # La respuesta de Julia al TidyVerse
Pkg.add("GraphRecipes") # Figuras de redes
Pkg.add("StatsPlots") # Figuras usando DataFrames
Pkg.add("Gadfly") # La respuesta de Julia a gg-plot
Pkg.add("FastGaussQuadrature") #  Metodos de integracion deterministicos
Pkg.add("Cuba") # Algoritmos de integracion de libreria "CUBA"
Pkg.add("Cubature") # Algoritmos de integracion libreria "CUBATURE"
Pkg.add("Calculus") # Derivadas numericas y simbolicas
Pkg.add("Zygote") # Diferenciacion automatica
Pkg.add("StatsKit") # Wrapper para paquetes estadisticos
Pkg.add("FredData") # Funciones para extraer datos desde FRED
Pkg.add("ExcelFiles") # Cargar datos de Excel
Pkg.add("CSV") # Cargar datos de CSV
Pkg.add("DSGE") # DSGE de la NY-FED
Pkg.add("StateSpaceRoutines") # Rutinas para modelos SS de la NY-FED

# Nota: Algunas de estas librerias no funcionan para la version 1.3 de Julia
# Pero todas funcionan para JuliaPro

# Load first time to precompile
using Compat
using Optim
using JuMP
using Interpolations
using Expectations
using Distributions
using DataFrames
using GraphRecipes
using StatsPlots
using JuliaDB
using Gadfly
using FastGaussQuadrature
using Cuba
using Cubature
using Calculus
using Zygote
using StatsKit
using FredData
using ExcelFiles
using CSV
using DSGE
using StateSpaceRoutines

# Otros
# Pandas: Front-end para trabajar con Pandas de Python
# Pycall: Llamar Python desde Julia
# RCall : Llamar R desde Julia
# ExcelFiles: # Wrapper de funciones de Python para importar Excel


# Instalar librerias sin accesso a internet es un poco mas complejo.
# En algunos casos, el siguiente truco funciona:
# Si se tiene un computador con acceso a Internet y el mismo sistema operativo
# del computador sin Internet, se puede instalar Julia y las librerias deseadas
# en este. Luego, se busca la carpeta .julia (por lo general, esta en el
# directorio del usuario). Se puede copiar y pegar esta carpeta en el computador
# con Julia pero sin acceso a  Internet. Cuando abra Julia en dicho computador,
# tardara un poco en precompilar de nuevo las librerias peor luego funcionara.
