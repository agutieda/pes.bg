# Introduccion a Julia: 
# Parte 4) Estructuras de Control
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
# 1) Valores Logicos
################################################################################

# Ya nos encontramos antes a los valores logicos true y false
x = true
y = false

# En Julia, los operadores logicos son funciones sin ningun misterio
!	# not
&&	# and
||	# or
==	# is equal?
!==	# is not equal?
===  	# is equal? (enforcing type 2===2.0 is false)
!===	# is not equal? (enforcing type)
>	# bigger than
>=	# bigger or equal than
<	# less than
<=	# less or equal than
~	# bitwise not
&	# bitwise and
|	# bitwise or
xor	# bitwise xor (also typed by \xor or \veebar + tab)

# Se pueden usar en conjunto, como es de esperarse
3 > 2 && 4<=8 || 7 < 7.1

# Incluso con strings
messi   = "goat"
ronaldo = "good"
messi    == "good"
messi    == "goat"
ronaldo !== "good"
ronaldo  == "goat"

# Como son funciones, hay que usar "." para aplicarlas elemento por elemento
A = (2,2,2)
B = (1,9,9)
A .> B 

# La ecaluacion de condicionales es "perezosa": 
# Una vez se rompe una condicion, no se evaluan las demas
2 > 3 && println("Maluma Baby")
2 > 1 && println("Maluma Baby")

# Existe ademas la opcion de comparar logicamente, incluyendo el tipo
messi_balonOro = 6
ronaldo_balonOro = 5

messi_balonOro     == 6.0 # Igualdad
messi_balonOro    === 6.0 # Igualdad, incluyendo tipo de variable
ronaldo_balonOro  !== 6.0 # Negacion, incluyendo tipo de variable
ronaldo_balonOro !=== 6.0 # Negacion, incluyendo tipo de variable

# Esta funcion nos permite comparar si dos valor son arbitrariamente cercanos
isapprox(1, 1.0001; atol = 0.1)
isapprox(1, 1.0001; atol = 1e-8)

# Julia permite ademas revisar pertenencia a un conjunto de forma compacta!
a = [1,2,3]
2 in a		
in(2,a)		
4 in a		

# Podemos usar valores logicos para hacer extraccion condicional
a = 1:10
sum(a.>4)  
mean(a.>4) 
a[a.>4]

# Pero es mas eficiente usar la funcion filter()
a = 1:10
filter(isodd,a)	            # Pares
filter(iseven,a)            # Impares
filter(x->x>5,a)            # Mayores que 5
filter(x-> x>=4 && x<=6,a)  # Entre 4 y 6
filter(x->x%3==0,a)         # Multiplos de 3

# Algunas otras funciones condicionales 
isa(1,Float64)
iseven(2)
isodd(2)
ispow2(4)
isfinite(a)
isinf(a)
isnan(a)

# Finalmente, Julia cuenta con el operador "ternario"
# Este operador es parecido a un "if-elseif-else" pero se usa cuando se requiere
# la eleccion condicional entre expresiones unicas, en lugar de la ejecucion
# pedazos de codigo mas largo.
#
# Se llama ternario porque consiste en tres operandos:
# a ? b : c
# 
# La expresion "a", antes del "?", es una condicion logica
# El operador ternario evalua la expresion "b" antes del ":"
# Si la condicion "a" es verdadera 

# Es mas facil de entender con un ejemplo
x = 1; y = 2;
println(x < y ? "less than" : "not less than")
x = 1; y = 0;
println(x < y ? "less than" : "not less than")

# El espacio entre operadores es obligatorio: a?b:c no es valido
println(x < y?"less than":"not less than") # Error!

# Se pueden anidar
test(x,y) = println(x < y ? "x is less than y"    :
                    x > y ? "x is greater than y" : "x is equal to y")

test(1,2)
test(2,1)
test(1,1)

# Se puede usar para definir funciones de forma compacta!
fib(n) = n < 2 ? n : fib(n-1) + fib(n-2)
fib(2)
fib(3)
fib(9)

################################################################################
# 2) Condicionales
################################################################################

# Tampoco hay misterio aca: Funcionan como es de esperarse

JBalvin  = 10
Maluma   = 8

if JBalvin < Maluma
    println("Maldad")
elseif JBalvin > Maluma
    println("Morado")
else
    println("Que Pena")
end

################################################################################
# 3) Loops
################################################################################

# Tambien funcionan como de esperarse, con una notacion bastante sencilla
for i in 1:5
	println(i)
end

for i in 1:0.1:5
	println(i)
end

# A diferencia de otros lenguajes, Julia no conserva el iterador local "i"

# Podemos hacer loops como en Matlab tambien!
for i = 1:5
	println("Maluma Baby")
end

# Podemos ademas iterar sobre cualquier coleccion de elementos
a = (1, 2, 3)
for i in a
	println(i)
end

# Y Usar notacion fina!
for i ∈ 5:-1:0
	println(i)
end

# Podemos usar notacion compacta para multiples loops!
for i = 1:2, j = 3:4
	println((i, j))
end

# Y utilizar iteradores anidados
for i = 1:2, j = i:4
	println((i, j))	
end

# La instruccion "break" termina el loop
for i = 1:2, j = 3:4
	println((i, j))
	if condition break
end

# Y la instruccion "continue" para condicionar el loop
for i = 1:2, j = 3:4
	if condition continue
	println((i, j))
end

# Tambien tenemos a nuestra dispocision el tradicional "while"
k = 0
while k <= 5
	println(k)
	global k += 1
end

# Note que el scope en los loops de Julia son locales (a diferencia de Matlab)
k = 0; y = 1;
while k <= 5
	y = 2
	global k += 1
end
y

k = 0; y = 1;
while k <= 5
	global y = 2
	global k += 1
end
y

# Finalmente, mote que en Julia podemos usar compresiones!
[n^2 for n in 1:5]

# Podemos fijar el tipo del output de una compresion
Float64[n^2 for n in 1:5]	

# Y podemos usar varios iteradores
[x+y for x in 1:3, y = 1:4]

# Y como generadores para funciones:

# Esto 
suma1 = 0
for i = 1:1000
	global suma1 += (1/i)^2
end
suma1

# Es equivalente a esto
suma2 = sum(1/i^2 for i=1:1000)
