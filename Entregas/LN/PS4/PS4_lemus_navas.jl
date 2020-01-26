#=
Lista de ejercicios 4

Programacion II
Programa de Estudios Superiores
Banco de Guatemala

Integrantes:
Elmer Humberto Lémus Flores
Erwin Roberto Navas Solis

###############################################################################################

1) Escriba un programa que encuentre la senda óptima de Ct y At de Leo Messi a lo largo de
su vida, dadas unas sendas de ingreso, un valor para la tasa de interés bruta y un valor 
de deuda.

###############################################################################################
=#

# Carga de paquetes 
using Plots
using Optim
using Random
using Distributions, Plots

###############################################################################################

# Valores de los parametros
beta   = 0.98  ; # Factor de descuento de Leo
sigma  = 1.5   ; # Coeficiente de aversion al riesgo de Messi
T      = 70    ; # Horizonte de vida que le queda a la pulga
A_0    = 0     ; # Valor inicial de sus activos
A_T    = 0     ; # Herencia que deja Leo a Thiago Messi

###############################################################################################

# Solución para una sola tasa de interés

R = (1/beta)-0.02       # Perfil de consumo creciente (Se endeuda)
#R = 1/beta             # Perfil de consumo constante a traves del tiempo
#R = (1/beta)+0.02        # Perfil de consumo decreciente (Ahorra)

## Proceso para el ingreso de Leo
Y = ones(T+1) # Ingreso constante a lo largo de la vida

#= Incremento anual de sueldo
g = 0.04      # Tasa de crecimiento del ingreso
Y[1] = 1
for t = 2:(T+1)
    global Y[t]=(1+g)*Y[t-1]
end
=#

# Asumimos que Leo se retira a los 40
# Y[41:(T+1)] .= 0

# Veamos como luce el ingreso
plot(Y, 
  color= :red,
  xlabel = "Años de edad",
  ylabel = "Nivel de ingreso",
  title = "Comportamiento del ingreso de Messi",
  legend=:none,
  markershape = :hexagon,
  markersize = 2,
  markeralpha = 0.6,
  markercolor = :blue,
  xlims = (0,70),
  ylims = (0,2),
)
savefig("Numeral 1, Gráfica 1, Nivel de ingreso.pdf")

# Funcion de utilidad instantanea de Leo
U_t_1 = function(C)
	if (sigma==1)
		U_t = log(C)
	else
      U_t = (C.^(1-sigma)-1)/(1-sigma)
    end
end

## Funcion objetivo de Leo
messi_func_1 = function(A_vec)
    A_vec_lag = [A_0 A_vec']                            # Vector con el rezago de los acivos
    A_vec     = [A_vec' A_T]                            # Vector de activos
    C_vec     = A_vec_lag.*R + Y' - A_vec               # Vector de consumo en cada periodo
    beta_vec  = beta.^(0:T)                             # Vector con tasas de descuento
    bienestar = sum(beta_vec.*U_t_1.(C_vec'))
        return -bienestar
end

#=
Problema de Ahorro Optimo de Leo Messi: Solucion cuando sigma = 1
=#

# Valor presente del ingreso de Leo
Y_bar = sum(Y./(R.^(0:T)))

# Consumo
C0 = ((1-beta)/(1-beta.^(T+1)))*Y_bar

C_initval = zeros(T+1)
C_initval = ((beta*R).^(0:T))*C0

# Activos
A_initval    = zeros(T)
A_initval[1] = R*A_0+Y[1]-C_initval[1]
for t = 2:T
    global A_initval[t] = R*A_initval[t-1]+Y[t]-C_initval[t]
end

# Y grafiquemos
plot(A_initval, 
  color= :red,
  xlabel = "Años de edad",
  ylabel = "Nivel de activos",
  title = "Comportamiento del stock de activos de Messi",
  legend=:none,
  markershape = :hexagon,
  markersize = 2,
  markeralpha = 0.6,
  markercolor = :blue,
  xlims = (0,70),
)
savefig("Numeral 1, Gráfica 2, Nivel de activos inicial.pdf")

#=
Problema de Ahorro Optimo de Leo Messi: Solucion cuando sigma != 1
=#

# Ahora usaremos la solucion particular como valor inicial
x0         = A_initval
A_t        = zeros(T)

# Optimizamos
lower = fill(-60.0,T)
upper = fill(60.0,T)
resultados = optimize(messi_func_1,lower,upper,x0)
A_t = Optim.minimizer(resultados)

comparativo = hcat(x0,A_t)
plot(comparativo, 
  xlabel = "Años de edad",
  ylabel = "Nivel de consumo",
  legend=:topleft,
  title = "Comparación, nivel inicial y óptimo (rojo) activos",
  xlims = (0,70),
)

# Peguemos el valor terminal
A_t = vcat(A_t,A_T)

# Calculemos del vector de consumo de Leo, por tipo de tasa de interes
C_t = zeros(T)

for t in 1:T
  if (t==1)
    global C_t[1] = A_0 * R + Y[1] - A_t[1]
  else
    global C_t[t] = A_t[(t-1)] * R + Y[t] - A_t[t]
  end
end

# Y grafiquemos
plot(A_t, 
  color= :red,
  xlabel = "Años de edad",
  ylabel = "Nivel de activos",
  title = "Comportamiento óptimo del stock de activos de Messi",
  legend=:none,
  markershape = :hexagon,
  markersize = 2,
  markeralpha = 0.6,
  markercolor = :blue,
  xlims = (0,70),
)
savefig("Numeral 1, Gráfica 3, Nivel de activos.pdf")

plot(C_t, 
  color= :red,
  xlabel = "Años de edad",
  ylabel = "Nivel de consumo",
  title = "Comportamiento óptimo del consumo de Messi",
  legend=:none,
  markershape = :hexagon,
  markersize = 2,
  markeralpha = 0.6,
  markercolor = :blue,
  xlims = (0,70),
)
savefig("Numeral 1, Gráfica 4, Nivel de consumo.pdf")

###############################################################################################

# Solución para todas las tasas de interés

R1 = (1/beta)-0.02       # Perfil de consumo creciente (Se endeuda)
R2 = 1/beta             # Perfil de consumo constante a traves del tiempo
R3 = (1/beta)+0.02        # Perfil de consumo decreciente (Ahorra)
R = [R1 R2 R3]

# Funcion de utilidad instantanea de Leo
U_t = function(C)
	if (sigma==1)
		U_t = log(C)
	else
        U_t = (C.^(1-sigma)-1)/(1-sigma)
    end
end

## Funcion objetivo de Leo
messi_func = function(A_vec,RRR = RR)
    A_vec_lag = [A_0 A_vec']                            # Vector con el rezago de los acivos
    A_vec     = [A_vec' A_T]                            # Vector de activos
    C_vec     = A_vec_lag.*RRR + Y' - A_vec               # Vector de consumo en cada periodo
    beta_vec  = beta.^(0:T)                             # Vector con tasas de descuento
    bienestar = sum(beta_vec.*U_t.(C_vec'))
        return -bienestar
end

#=
Problema de Ahorro Optimo de Leo Messi: Solucion cuando sigma = 1
=#

# Vector de valor presente del ingreso de Leo
Y_bar = zeros(length(R))
for t = 1:length(R)
  global Y_bar[t] = sum(Y./(R[t].^(0:T)))     # Para cada tasa de interes
end

# Vector de consumo
C0 = zeros(length(R))
for t = 1:length(R)
  global C0[t] = ((1-beta)/(1-beta.^(T+1)))*Y_bar[t] # Para cada tasa de interes
end

C_initval = zeros((T+1),length(R))
for t = 1:length(R)
  global C_initval[:,t] = ((beta*R[t]).^(0:T))*C0[t] # Para cada tasa de interes
end

# Vector de activos para cada tasa de interes
A_initval    = zeros(T,length(R))

for t = 1:length(R)
  global A_initval[1,t] = R[t]*A_0+Y[1]-C_initval[1,t] # Para cada tasa de interes
end

for i = 1:length(R)
  for t = 2:T
      global A_initval[t,i] = R[i]*A_initval[t-1,i]+Y[t]-C_initval[t,i]
  end
end

# Y grafiquemos
plot(A_initval, 
  xlabel = "Años de edad",
  ylabel = "Nivel de activos",
  legend=:topleft,
  title = "Comportamiento del stock de activos de Messi",
  xlims = (0,70),
  label = ["Deuda creciente" "Deuda constante" "Deuda decreciente"]
)

#=
Problema de Ahorro Optimo de Leo Messi: Solucion cuando sigma != 1
=#

# Ahora usaremos la solucion particular como valor inicial
x0         = A_initval
A_t    = zeros(T,length(R))

# Optimizamos cada columna correspondiente a cada R
for t = 1:length(R)
  lower = fill(-60.0,T)
  upper = fill(60.0,T)
  global argumento = x0[:,t]
  global RR = R[t]
    resultados = optimize(messi_func,lower,upper,argumento)
  global A_t[:,t] = Optim.minimizer(resultados)
end

# Peguemos el valor terminal
A_TT    = zeros(1,length(R))
A_tt = vcat(A_t,A_TT)

# Calculemos del vector de consumo de Leo, por tipo de tasa de interes
C_t = zeros(T,length(R))

for i in 1:length(R)
  for t in 1:T
    if (t==1)
      global C_t[1,i] = A_0 * R[i] + Y[1] - A_tt[1,i]
    else
      global C_t[t,i] = A_tt[(t-1),i] * R[i] + Y[t] - A_tt[t,i]
    end
  end
end

# Y grafiquemos
plot(A_tt, 
  xlabel = "Años de edad",
  ylabel = "Nivel de activos",
  legend=:topleft,
  title = "Comportamiento óptimo del stock de activos de Messi",
  xlims = (0,70),
  label = ["Deuda creciente" "Deuda constante" "Deuda decreciente"]
)
savefig("Numeral 1, Gráfica 5, Comparativo de R para el nivel de activos.pdf")

plot(C_t, 
  xlabel = "Años de edad",
  ylabel = "Nivel de consumo",
  legend=:topleft,
  title = "Comportamiento óptimo del consumo de Messi",
  xlims = (0,70),
  label = ["Deuda creciente" "Deuda constante" "Deuda decreciente"]
)
savefig("Numeral 1, Gráfica 6, Comparativo de R para el nivel de consumo.pdf")

#=
###############################################################################################

2) Problema de Ahorro Optimo de Leo Messi: Solucion con restricciones de deuda

###############################################################################################

Supongamos ahora que el malvado gobierno espanol,al servicio del Real Madrid,
decide atacar a Leo con un proceso por fraude fiscal. Esto impide al mejor de
la historia contraer deudas por encima de un umbral A_bound, incluso con su
amigo El Banco de Argentina
Por lo anterior, At>=A_bound en todo periodo
=#

# CASO, DONDE LA DEUDA TIENDE AL INFINITO, SE UTILIZÓ UN VALOR DE 1000 PARA REPRESENTARLO
A_bound = -10000

# Valor inicial
x0_deuda = zeros(T,length(R))

for i = 1:length(R)
  for t = 1:T
      x0_deuda[t,i]=max(A_bound,A_initval[t,i])
  end
end

# Usamos el tercer argumento para indicar la cota inferior para At
A_t_deuda    = fill(0.0,T,length(R))

# Optimizamos cada columna correspondiente a cada R
for t = 1:length(R)
  lower = fill(-1000.0,T)
  upper = fill(1000.0,T)
  global argumento = x0_deuda[:,t]
  global RR = R[t]
    resultados = optimize(messi_func,lower,upper,argumento)
  global A_t_deuda[:,t] = Optim.minimizer(resultados)
end

# Peguemos el valor terminal
A_TT_deuda    = zeros(1,length(R))
A_tt_deuda = vcat(A_t_deuda,A_TT_deuda)

# Calculemos del vector de consumo de Leo, por tipo de tasa de interes
C_t_deuda = zeros(T,length(R))

for i in 1:length(R)
  for t in 1:T
    if (t==1)
      global C_t_deuda[1,i] = A_0 * R[i] + Y[1] - A_tt_deuda[1,i]
    else
      global C_t_deuda[t,i] = A_tt_deuda[(t-1),i] * R[i] + Y[t] - A_tt_deuda[t,i]
    end
  end
end

# Y grafiquemos
plot(A_tt_deuda, 
  xlabel = "Años de edad",
  ylabel = "Nivel de activos",
  legend=:topleft,
  title = "Comportamiento óptimo del stock de activos de Messi",
  xlims = (0,70),
  label = ["Deuda creciente" "Deuda constante" "Deuda decreciente"]
)
savefig("Numeral 2, Gráfica 1, Deuda infinita, Óptimo del nivel de activos.pdf")

plot(C_t_deuda, 
  xlabel = "Años de edad",
  ylabel = "Nivel de consumo",
  legend=:topleft,
  title = "Comportamiento óptimo del consumo de Messi",
  xlims = (0,70),
  label = ["Deuda creciente" "Deuda constante" "Deuda decreciente"]
)
savefig("Numeral 2, Gráfica 2, Deuda infinita, Óptimo del nivel de consumo.pdf")

#=
###############################################################################################

3) CASO DE CERO DEUDA

###############################################################################################
=#

A_bound = 0

# Valor inicial
x0_deuda = zeros(T,length(R))

for i = 1:length(R)
  for t = 1:T
      x0_deuda[t,i]=max(A_bound,A_initval[t,i])
  end
end

# Usamos el tercer argumento para indicar la cota inferior para At
A_t_deuda    = fill(0.0,T,length(R))

# Optimizamos cada columna correspondiente a cada R
for t = 1:length(R)
  lower = fill(0.0,T)
  upper = fill(60.0,T)
  global argumento = x0_deuda[:,t]
  global RR = R[t]
    resultados = optimize(messi_func,lower,upper,argumento)
  global A_t_deuda[:,t] = Optim.minimizer(resultados)
end

# Peguemos el valor terminal
A_TT_deuda    = zeros(1,length(R))
A_tt_deuda = vcat(A_t_deuda,A_TT_deuda)

# Calculemos del vector de consumo de Leo, por tipo de tasa de interes
C_t_deuda = zeros(T,length(R))

for i in 1:length(R)
  for t in 1:T
    if (t==1)
      global C_t_deuda[1,i] = A_0 * R[i] + Y[1] - A_tt_deuda[1,i]
    else
      global C_t_deuda[t,i] = A_tt_deuda[(t-1),i] * R[i] + Y[t] - A_tt_deuda[t,i]
    end
  end
end

# Y grafiquemos
plot(A_tt_deuda, 
  xlabel = "Años de edad",
  ylabel = "Nivel de activos",
  legend=:topleft,
  title = "Comportamiento óptimo del stock de activos de Messi",
  xlims = (0,70),
  label = ["Deuda creciente" "Deuda constante" "Deuda decreciente"]
)
savefig("Numeral 3, Gráfica 1, Deuda cero, Óptimo del nivel de activos.pdf")

plot(C_t_deuda, 
  xlabel = "Años de edad",
  ylabel = "Nivel de consumo",
  legend=:topleft,
  title = "Comportamiento óptimo del consumo de Messi",
  xlims = (0,70),
  label = ["Deuda creciente" "Deuda constante" "Deuda decreciente"]
)
savefig("Numeral 3, Gráfica 2, Deuda cero, Óptimo del nivel de consumo.pdf")

#=
###############################################################################################

4) Asuma ahora que Yt es un proceso AR(1)

###############################################################################################
Creación de la serie Yt, con 
Y1 = mi = 1 ; rho = 0.8 ; sigma = 0.2 ; R = (1/B)-0.02
=#

# Definición de parámetros
rho     = 0.8
sigma   = 0.2
mi      = 1
R       = R[1]      # Perfil de consumo creciente (Se endeuda)

# Valor inicial aleatorio
y1 = mi
distr = Normal(0,sigma)
# Semilla
Random.seed!(15)
eps = rand(distr,T,1)
inicial = y1

# Construcción de serie AR(1)
y_ar = zeros(T+1)
y_ar[1] = y1

for t = 2:T
  y_ar[t] = mi*(1-rho) + rho*y_ar[t-1] + eps[t]
end

# Asumimos que Leo se retira a los 40
# y_ar[41:(T+1)] .= 0

# El comportamiento del ingreso, bajo el proceso aleatorio es
plot(y_ar, 
  color= :red,
  xlabel = "Años de edad",
  ylabel = "Nivel de ingreso",
  title = "Comportamiento del ingreso de Messi AR()",
  legend=:none,
  markershape = :hexagon,
  markersize = 2,
  markeralpha = 0.6,
  markercolor = :blue,
  xlims = (0,70),
  ylims = (0,2),
)

# Valor presente del ingreso de Leo
Y_bar_ar = sum(y_ar./(R.^(0:T)))

# Consumo
C0_ar = ((1-beta)/(1-beta.^(T+1)))*Y_bar_ar

C_initval_ar = zeros(T+1)
C_initval_ar = ((beta*R).^(0:T))*C0_ar

# Activos
A_initval_ar    = zeros(T)
A_initval_ar[1] = R*A_0+y_ar[1]-C_initval_ar[1]
for t = 2:T
    global A_initval_ar[t] = R*A_initval_ar[t-1]+y_ar[t]-C_initval_ar[t]
end

# Y grafiquemos
plot(A_initval_ar, 
  color= :red,
  xlabel = "Años de edad",
  ylabel = "Nivel de activos",
  title = "Comportamiento del stock de activos de Messi AR()",
  legend=:none,
  markershape = :hexagon,
  markersize = 2,
  markeralpha = 0.6,
  markercolor = :blue,
  xlims = (0,70),
)

#=
###############################################################################################

punto a) En una misma gráfica, muestre las sendas de Ct y At para una realización de Yt cuando
la deuda tiende a infinito

###############################################################################################
=#
# Capacidad de endeudamiento
A_bound_ar = -100000 # tiende al infinito

# Valor inicial
x0_ar = zeros(T)

for t = 1:T
    x0_ar[t]=max(A_bound_ar,A_initval_ar[t])
end

# Usamos el tercer argumento para indicar la cota inferior para At
A_t_ar    = fill(0.0,T)

# Optimizamos
lower_ar = zeros(T)
for t = 1:T
  lower_ar[t]= x0_ar[t]-0.5
end

upper_ar = zeros(T)
for t = 1:T
  upper_ar[t]= x0_ar[t]+0.5
end

resultados_ar = optimize(messi_func_1,lower_ar,upper_ar,x0_ar)
A_t_ar = Optim.minimizer(resultados_ar)

comparativo_ar = hcat(x0_ar,A_t_ar)
plot(comparativo_ar, 
  xlabel = "Años de edad",
  ylabel = "Nivel de consumo",
  legend=:topleft,
  title = "Comparación, nivel inicial y óptimo (rojo) activos AR()",
  xlims = (0,70),
)

# Peguemos el valor terminal
A_t_ar = vcat(A_t_ar,A_T)

# Calculemos del vector de consumo de Leo, por tipo de tasa de interes
C_t_ar = zeros(T)

for t in 1:T
  if (t==1)
    global C_t_ar[1] = A_0 * R + y_ar[1] - A_t_ar[1]
  else
    global C_t_ar[t] = A_t_ar[(t-1)] * R + y_ar[t] - A_t_ar[t]
  end
end

# Y grafiquemos
plot(A_t_ar, 
  color= :red,
  xlabel = "Años de edad",
  ylabel = "Nivel de activos",
  title = "Comportamiento óptimo del stock de activos de Messi AR()",
  legend=:none,
  markershape = :hexagon,
  markersize = 2,
  markeralpha = 0.6,
  markercolor = :blue,
  xlims = (0,70),
)
savefig("Numeral 4, parte a, Gráfica 1, Deuda infinita, Óptimo del nivel de activo.pdf")

plot(C_t_ar, 
  color= :red,
  xlabel = "Años de edad",
  ylabel = "Nivel de consumo",
  title = "Comportamiento óptimo del consumo de Messi AR()",
  legend=:none,
  markershape = :hexagon,
  markersize = 2,
  markeralpha = 0.6,
  markercolor = :blue,
  xlims = (0,70),
)
savefig("Numeral 4, parte a, Gráfica 2, Deuda infinita, Óptimo del nivel de consumo.pdf")

#=
###############################################################################################

punto b) Repita el ejercicio anterior para la misma senda de ingreso simulada, pero cuando el nivel
de deuda es 0

###############################################################################################
=#

# Capacidad de endeudamiento
A_bound_ar = 0

# Valor inicial
x0_ar = zeros(T)

for t = 1:T
    x0_ar[t]=max(A_bound_ar,A_initval_ar[t])
end

# Usamos el tercer argumento para indicar la cota inferior para At
A_t_ar    = fill(0.0,T)

# Optimizamos
lower_ar = fill(0.0,T)
upper_ar = fill(60.0,T)

resultados_ar = optimize(messi_func_1,lower_ar,upper_ar,x0_ar)
A_t_ar = Optim.minimizer(resultados_ar)

comparativo_ar = hcat(x0_ar,A_t_ar)
plot(comparativo_ar, 
  xlabel = "Años de edad",
  ylabel = "Nivel de consumo",
  legend=:topleft,
  title = "Comparación, nivel inicial y óptimo (rojo) activos AR()",
  xlims = (0,70),
)

# Peguemos el valor terminal
A_t_ar = vcat(A_t_ar,A_T)

# Calculemos del vector de consumo de Leo, por tipo de tasa de interes
C_t_ar = zeros(T)

for t in 1:T
  if (t==1)
    global C_t_ar[1] = A_0 * R + y_ar[1] - A_t_ar[1]
  else
    global C_t_ar[t] = A_t_ar[(t-1)] * R + y_ar[t] - A_t_ar[t]
  end
end

# Y grafiquemos
plot(A_t_ar, 
  color= :red,
  xlabel = "Años de edad",
  ylabel = "Nivel de activos",
  title = "Comportamiento óptimo del stock de activos de Messi AR()",
  legend=:none,
  markershape = :hexagon,
  markersize = 2,
  markeralpha = 0.6,
  markercolor = :blue,
  xlims = (0,70),
  ylims = (-5,5)
)
savefig("Numeral 4, parte b, Gráfica 1, Deuda cero, Óptimo del nivel de activo.pdf")

plot(C_t_ar, 
  color= :red,
  xlabel = "Años de edad",
  ylabel = "Nivel de consumo",
  title = "Comportamiento óptimo del consumo de Messi",
  legend=:none,
  markershape = :hexagon,
  markersize = 2,
  markeralpha = 0.6,
  markercolor = :blue,
  xlims = (0,70),
  ylims = (0,2)
)
savefig("Numeral 4, parte b, Gráfica 2, Deuda cero, Óptimo del nivel de consumo.pdf")

#=
###############################################################################################

punto c) Repita los dos puntos anteriores para N = 10:000 realizaciones diferentes de Yt. 
Calcule el valor de Ct promedio para cada t entre todas las realizaciones y grafiquelo.

###############################################################################################
=#

iter = 10000

# Creación de series y, 10 mil realizaciones
y_ar_sim = zeros(T+1,iter)
y1 = mi
distr = Normal(0,sigma)

eps_sim = zeros(T,iter)
for t = 1:iter
  eps_sim[:,t] = rand(distr,T,1)
end
inicial = y1

# Construcción de serie AR(1)
for t = 1:iter
  global y_ar_sim[1,t] = inicial
end

for i = 1:iter
  for t = 2:T
    y_ar_sim[t,i] = mi*(1-rho) + rho*y_ar_sim[t-1,i] + eps_sim[t,i]
  end
end

# Asumimos que Leo se retira a los 40
#for t = 1:iter
#  global y_ar_sim[41:(T+1),t] .= 0
#end

# Valor presente del ingreso de Leo
Y_bar_ar_sim = zeros(iter)
for t = 1:iter
  global Y_bar_ar_sim[t] = sum(y_ar_sim[:,t]./(R.^(0:T)))
end

# Consumo
C0_ar_sim = zeros(iter)
for t = 1:iter
  global C0_ar_sim[t] = ((1-beta)/(1-beta.^(T+1)))*Y_bar_ar_sim[t]
end

C_initval_ar_sim = zeros((T+1),iter)
for t = 1:iter
  global C_initval_ar_sim[:,t] = ((beta*R).^(0:T))*C0_ar_sim[t] # Para cada tasa de interes
end

# Vector de activos para cada tasa de interes
A_initval_ar_sim    = zeros(T,iter)

for t = 1:iter
  global A_initval_ar_sim[1,t] = R*A_0+y_ar_sim[1]-C_initval_ar_sim[1,t] # Para cada tasa de interes
end

for i = 1:iter
  for t = 2:T
      global A_initval_ar_sim[t,i] = R*A_initval_ar_sim[t-1,i]+y_ar_sim[t]-C_initval_ar_sim[t,i]
  end
end

####################################################################################################
# Capacidad de endeudamiento
# punto a, con deuda que tiende al infinito
A_bound_ar_sim = -1000 # tiende al infinito

# Valor inicial
x0_ar_sim = zeros(T,iter)

for i = 1:iter
  for t = 1:T
      x0_ar_sim[t,i]=max(A_bound_ar_sim,A_initval_ar_sim[t,i])
  end
end

# Usamos el tercer argumento para indicar la cota inferior para At
A_t_ar_sim    = x0_ar_sim #fill(0.0,T,iter)

# Optimizamos cada columna correspondiente a cada realización
lower_ar_sim = zeros(T,iter)
for i = 1:iter
  for t = 1:T
    lower_ar_sim[t,i]= x0_ar_sim[t,i]-0.5
  end
end

upper_ar_sim = zeros(T,iter)
for i = 1:iter
  for t = 1:T
    upper_ar_sim[t,i]= x0_ar_sim[t,i]+0.5
  end
end

for t = 1:iter
  global argumento = x0_ar_sim[:,t]
  global RR = R
    resultados = optimize(messi_func,lower_ar_sim[:,t],upper_ar_sim[:,t],argumento)
  global A_t_ar_sim[:,t] = Optim.minimizer(resultados)
end

# Peguemos el valor terminal
A_TT_sim    = zeros(1,iter)
A_tt_ar_sim = vcat(A_t_ar_sim,A_TT_sim)

# Calculemos del vector de consumo de Leo, por tipo de tasa de interes
C_t_ar_sim = zeros(T,iter)

for i = 1:iter
  for t in 1:T
    if (t==1)
      global C_t_ar_sim[1,i] = A_0 * R + y_ar_sim[1,i] - A_t_ar_sim[1,i]
    else
      global C_t_ar_sim[t,i] = A_t_ar_sim[(t-1),i] * R + y_ar_sim[t,i] - A_t_ar_sim[t,i]
    end
  end
end

C_t_ar_sim_prom = mean(C_t_ar_sim, dims=2)

# Y grafiquemos
plot(C_t_ar_sim_prom, 
  color= :red,
  xlabel = "Años de edad",
  ylabel = "Nivel de consumo",
  title = "Consumo promedio de simulación",
  legend=:none,
  markershape = :hexagon,
  markersize = 2,
  markeralpha = 0.6,
  markercolor = :blue,
  xlims = (0,70),
  ylims = (0,3)
)
savefig("Numeral 4, parte c, Gráfica 1, Deuda Infinita, Óptimo del nivel de consumo.pdf")

####################################################################################################
# punto b, con deuda cero
A_bound_ar_sim = 0

# Valor inicial
x0_ar_sim = zeros(T,iter)

for i = 1:iter
  for t = 1:T
      x0_ar_sim[t,i]=max(A_bound_ar_sim,A_initval_ar_sim[t,i])
  end
end

# Usamos el tercer argumento para indicar la cota inferior para At
A_t_ar_sim    = x0_ar_sim #fill(0.0,T,iter)

# Optimizamos cada columna correspondiente a cada realización
lower_ar_sim = zeros(T,iter)

upper_ar_sim = zeros(T,iter)
for i = 1:iter
  for t = 1:T
    upper_ar_sim[t,i]= x0_ar_sim[t,i]+0.5
  end
end

for t = 1:iter
  global argumento = x0_ar_sim[:,t]
  global RR = R
    resultados = optimize(messi_func,lower_ar_sim[:,t],upper_ar_sim[:,t],argumento)
  global A_t_ar_sim[:,t] = Optim.minimizer(resultados)
end
#

# Peguemos el valor terminal
A_TT_sim    = zeros(1,iter)
A_tt_ar_sim = vcat(A_t_ar_sim,A_TT_sim)

# Calculemos del vector de consumo de Leo, por tipo de tasa de interes
C_t_ar_sim = zeros(T,iter)

for i = 1:iter
  for t in 1:T
    if (t==1)
      global C_t_ar_sim[1,i] = A_0 * R + y_ar_sim[1,i] - A_t_ar_sim[1,i]
    else
      global C_t_ar_sim[t,i] = A_t_ar_sim[(t-1),i] * R + y_ar_sim[t,i] - A_t_ar_sim[t,i]
    end
  end
end

C_t_ar_sim_prom = mean(C_t_ar_sim, dims=2)

# Y grafiquemos
plot(C_t_ar_sim_prom, 
  color= :red,
  xlabel = "Años de edad",
  ylabel = "Nivel de consumo",
  title = "Consumo promedio de simulación",
  legend=:none,
  markershape = :hexagon,
  markersize = 2,
  markeralpha = 0.6,
  markercolor = :blue,
  xlims = (0,70),
  ylims = (0,3)
)
savefig("Numeral 4, parte c, Gráfica 2, Deuda Cero, Óptimo del nivel de consumo.pdf")

# FIN