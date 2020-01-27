#PROGRAMACION II
#TALLER #4

#Integrantes: Mariela Benavides
#             Ernesto Monterroso
#             Allan Santizo


##############################################################################
# Paquetes
using Plots
using LinearAlgebra
using Optim
using Distributions
using Random

##############################################################################
# Funciones
## Funcion de utilidad instantanea de Leo
function U_t(C)
    if (σ == 1)
        U_t = log(C)
    else
        U_t = ((C).^(1-σ)-1)/(1-σ)
    end
end

#Funcion objetivo Leo
# Con varias lineas
function messi_fun(A_vec)
     A_vec_lag = [A_0 A_vec']                 # Vector con el rezago de los activos
     A_vec     = [A_vec' A_T]                 # Vector de activos
     C_vec     = A_vec_lag.*R+Y'-A_vec       # Vector de consumo en cada periodo
     beta_vec  = β.^(0:T)                # Vector con tasas de descuento
     bienestar = sum(beta_vec.*U_t.(C_vec')) # Funcion objetivo del problema
     return (-bienestar)
end

##############################################################################
# INCISO 1)

## Valores de los parametros
β   = 0.98      ; # Factor de descuento de Leo
σ  = 1.5        ; # Coeficiente de aversion al riesgo de Messi
T      = 70     ; # Horizonte de vida que le queda a la pulga
A_0    = 0      ; # Valor inicial de sus activos
A_T    = 0      ; # Herencia que deja Leo a Thiago Messi
# Tasa de interes a la que el Banco de Argentina presta a Messi
R = 1/β-0.02 # Perfil de consumo creciente (Se endeuda)
## Proceso para el ingreso de Leo
Y = ones(T+1) # Ingreso constante a lo largo de la vida
Φ = -5.0 # Se supone un valor de Φ y una tasa R cualquiera.
# sin embargo, el FC Barcelona sube a Leo su sueldo anualmente
g = 0.04 # Tasa de crecimiento del ingreso
for t = 2:(T+1)
    global Y[t] = (1+g)*Y[t-1]
end
Y[41:end].=1 # Se retira a los 40, se va a Argentina y sigue jugando,
# asesorando jóvenes promesas hasta su muerte con un sueldo constante de 1.0

# Valor presente del ingreso de Leo
Y_bar = sum(Y./(R.^(0:T)))

# Consumo
C0        = ((1-β)/(1-β^(T+1)))*Y_bar
C_initval = ((β*R).^(0:T)).*C0

# Activos
A_initval    = zeros(T)
A_initval[1] = R*A_0+Y[1]-C_initval[1]
for t = 2:T
    global A_initval[t] = R*A_initval[t-1]+Y[t]-C_initval[t]
end

# Valor inicial
xcero = fill(0.0,length(A_initval))
for i = 1:length(A_initval)
    xcero[i] = max(Φ,A_initval[i])
end
# Usamos el tercer argumento para indicar la cota inferior para At
lower = fill(Φ,T)
upper = fill(35.0, T)
resultados = optimize(messi_fun,lower,upper,xcero)
A_t = resultados.minimizer

# Peguemos el valor terminal
A_t = [A_t' A_T]

# Calculemos el consumo de Messi
C_t = zeros(T)

for t = 1:T
    if (t==1)
        C_t[1] = A_0*R+Y[1]-A_t[1]
    else
        C_t[t] = A_t[t-1].*R+Y[t]-A_t[t]
    end
end
plot(A_t',xlabel="t",ylabel="A(t)",title="Activos - Inciso 1")
savefig("Activos - Inciso 1.pdf")
plot(C_t,xlabel="t",ylabel="C(t)",title="Consumo - Inciso 1")
savefig("Consumo - Inciso 1.pdf")


##############################################################################
# INCISO 2.1)

## Valores de los parametros
β   = 0.98      ; # Factor de descuento de Leo
σ  = 1.5        ; # Coeficiente de aversion al riesgo de Messi
T      = 70     ; # Horizonte de vida que le queda a la pulga
A_0    = 0      ; # Valor inicial de sus activos
A_T    = 0      ; # Herencia que deja Leo a Thiago Messi
# Tasa de interes a la que el Banco de Argentina presta a Messi
R = 1/β # Perfil de consumo creciente (Se endeuda)
## Proceso para el ingreso de Leo
Y = ones(T+1) # Ingreso constante a lo largo de la vida
Φ = -Inf # Se supone un valor de Φ y una tasa R cualquiera.

# Valor presente del ingreso de Leo
Y_bar = sum(Y./(R.^(0:T)))

# Consumo
C0        = ((1-β)/(1-β^(T+1)))*Y_bar
C_initval = ((β*R).^(0:T)).*C0

# Activos
A_initval    = zeros(T)
A_initval[1] = R*A_0+Y[1]-C_initval[1]
for t = 2:T
    global A_initval[t] = R*A_initval[t-1]+Y[t]-C_initval[t]
end

# Valor inicial
xcero = A_initval

# Usamos el tercer argumento para indicar la cota inferior para At
resultados = optimize(messi_fun,xcero)
A_t = resultados.initial_x

# Peguemos el valor terminal
A_t = [A_t' A_T]

# Calculemos el consumo de Messi
C_t = zeros(T)

for t = 1:T
    if (t==1)
        C_t[1] = A_0*R+Y[1]-A_t[1]
    else
        C_t[t] = A_t[t-1].*R+Y[t]-A_t[t]
    end
end

##############################################################################
# INCISO 2.2)

## Valores de los parametros
β   = 0.98      ; # Factor de descuento de Leo
σ  = 1.5        ; # Coeficiente de aversion al riesgo de Messi
T      = 70     ; # Horizonte de vida que le queda a la pulga
A_0    = 0      ; # Valor inicial de sus activos
A_T    = 0      ; # Herencia que deja Leo a Thiago Messi
# Tasa de interes a la que el Banco de Argentina presta a Messi
R = 1/β-0.02 # Perfil de consumo creciente (Se endeuda)
## Proceso para el ingreso de Leo
Y = ones(T+1) # Ingreso constante a lo largo de la vida
Φ = -Inf # Se supone un valor de Φ y una tasa R cualquiera.

# Valor presente del ingreso de Leo
Y_bar = sum(Y./(R.^(0:T)))

# Consumo
C0        = ((1-β)/(1-β^(T+1)))*Y_bar
C_initval = ((β*R).^(0:T)).*C0

# Activos
A_initval    = zeros(T)
A_initval[1] = R*A_0+Y[1]-C_initval[1]
for t = 2:T
    global A_initval[t] = R*A_initval[t-1]+Y[t]-C_initval[t]
end

# Valor inicial
xcero = A_initval

# Usamos el tercer argumento para indicar la cota inferior para At
lower = fill(-25.0,T)
upper = fill(35.0, T)
resultados = optimize(messi_fun,lower,upper,xcero)
A_t2 = resultados.minimizer

# Peguemos el valor terminal
A_t2 = [A_t2' A_T]

# Calculemos el consumo de Messi
C_t2 = zeros(T)

for t = 1:T
    if (t==1)
        C_t2[1] = A_0*R+Y[1]-A_t2[1]
    else
        C_t2[t] = A_t2[t-1].*R+Y[t]-A_t2[t]
    end
end

##############################################################################
# INCISO 2.3)

## Valores de los parametros
β   = 0.98      ; # Factor de descuento de Leo
σ  = 1.5        ; # Coeficiente de aversion al riesgo de Messi
T      = 70     ; # Horizonte de vida que le queda a la pulga
A_0    = 0      ; # Valor inicial de sus activos
A_T    = 0      ; # Herencia que deja Leo a Thiago Messi
# Tasa de interes a la que el Banco de Argentina presta a Messi
R = 1/β + 0.02 # Perfil de consumo creciente (Se endeuda)
## Proceso para el ingreso de Leo
Y = ones(T+1) # Ingreso constante a lo largo de la vida
Φ = -Inf # Se supone un valor de Φ y una tasa R cualquiera.

# Valor presente del ingreso de Leo
Y_bar = sum(Y./(R.^(0:T)))

# Consumo
C0        = ((1-β)/(1-β^(T+1)))*Y_bar
C_initval = ((β*R).^(0:T)).*C0

# Activos
A_initval    = zeros(T)
A_initval[1] = R*A_0+Y[1]-C_initval[1]
for t = 2:T
    global A_initval[t] = R*A_initval[t-1]+Y[t]-C_initval[t]
end

# Valor inicial
xcero = A_initval

# Usamos el tercer argumento para indicar la cota inferior para At
lower = fill(-25.0,T)
upper = fill(35.0, T)
resultados = optimize(messi_fun,lower,upper,xcero)
A_t3 = resultados.initial_x

# Peguemos el valor terminal
A_t3 = [A_t3' A_T]

# Calculemos el consumo de Messi
C_t3 = zeros(T)

for t = 1:T
    if (t==1)
        C_t3[1] = A_0*R+Y[1]-A_t3[1]
    else
        C_t3[t] = A_t3[t-1].*R+Y[t]-A_t3[t]
    end
end

plot(hcat(A_t3',A_t2',A_t'),xlabel="t",ylabel="A(t)",title="Activos - Inciso 2")
savefig("Activos - Inciso 2.pdf")
plot(hcat(C_t3,C_t2,C_t),xlabel="t",ylabel="C(t)",title="Consumo - Inciso 2")
savefig("Consumo - Inciso 2.pdf")

##############################################################################
# INCISO 3.1)

## Valores de los parametros
β   = 0.98      ; # Factor de descuento de Leo
σ  = 1.5        ; # Coeficiente de aversion al riesgo de Messi
T      = 70     ; # Horizonte de vida que le queda a la pulga
A_0    = 0      ; # Valor inicial de sus activos
A_T    = 0      ; # Herencia que deja Leo a Thiago Messi
# Tasa de interes a la que el Banco de Argentina presta a Messi
R = 1/β # Perfil de consumo creciente (Se endeuda)
## Proceso para el ingreso de Leo
Y = ones(T+1) # Ingreso constante a lo largo de la vida
Φ = 0.0 # Se supone un valor de Φ y una tasa R cualquiera.

# Valor presente del ingreso de Leo
Y_bar = sum(Y./(R.^(0:T)))

# Consumo
C0        = ((1-β)/(1-β^(T+1)))*Y_bar
C_initval = ((β*R).^(0:T)).*C0

# Activos
A_initval    = zeros(T)
A_initval[1] = R*A_0+Y[1]-C_initval[1]
for t = 2:T
    global A_initval[t] = R*A_initval[t-1]+Y[t]-C_initval[t]
end

xcero = fill(0.0,length(A_initval))
for i = 1:length(A_initval)
    xcero[i] = max(Φ,A_initval[i])
end
# Usamos el tercer argumento para indicar la cota inferior para At
lower = fill(Φ,T)
upper = fill(35.0, T)
resultados = optimize(messi_fun,lower,upper,xcero)
A_t = resultados.minimizer

# Peguemos el valor terminal
A_t = [A_t' A_T]

# Calculemos el consumo de Messi
C_t = zeros(T)

for t = 1:T
    if (t==1)
        C_t[1] = A_0*R+Y[1]-A_t[1]
    else
        C_t[t] = A_t[t-1].*R+Y[t]-A_t[t]
    end
end

##############################################################################
# INCISO 3.2)

## Valores de los parametros
β   = 0.98      ; # Factor de descuento de Leo
σ  = 1.5        ; # Coeficiente de aversion al riesgo de Messi
T      = 70     ; # Horizonte de vida que le queda a la pulga
A_0    = 0      ; # Valor inicial de sus activos
A_T    = 0      ; # Herencia que deja Leo a Thiago Messi
# Tasa de interes a la que el Banco de Argentina presta a Messi
R = 1/β-0.02 # Perfil de consumo creciente (Se endeuda)
## Proceso para el ingreso de Leo
Y = ones(T+1) # Ingreso constante a lo largo de la vida
Φ = 0.0 # Se supone un valor de Φ y una tasa R cualquiera.

# Valor presente del ingreso de Leo
Y_bar = sum(Y./(R.^(0:T)))

# Consumo
C0        = ((1-β)/(1-β^(T+1)))*Y_bar

C_initval = ((β*R).^(0:T)).*C0

# Activos
A_initval    = zeros(T)
A_initval[1] = R*A_0+Y[1]-C_initval[1]
for t = 2:T
    global A_initval[t] = R*A_initval[t-1]+Y[t]-C_initval[t]
end

xcero = fill(0.0,length(A_initval))
for i = 1:length(A_initval)
    xcero[i] = max(Φ,A_initval[i])
end
# Usamos el tercer argumento para indicar la cota inferior para At
lower = fill(Φ,T)
upper = fill(0.5, T)
resultados = optimize(messi_fun,lower,upper,xcero)
A_t2 = resultados.minimizer

# Peguemos el valor terminal
A_t2 = [A_t2' A_T]

# Calculemos el consumo de Messi
C_t2 = zeros(T)

for t = 1:T
    if (t==1)
        C_t2[1] = A_0*R+Y[1]-A_t2[1]
    else
        C_t2[t] = A_t2[t-1].*R+Y[t]-A_t2[t]
    end
end

##############################################################################
# INCISO 3.3)

## Valores de los parametros
β   = 0.98      ; # Factor de descuento de Leo
σ  = 1.5        ; # Coeficiente de aversion al riesgo de Messi
T      = 70     ; # Horizonte de vida que le queda a la pulga
A_0    = 0      ; # Valor inicial de sus activos
A_T    = 0      ; # Herencia que deja Leo a Thiago Messi
# Tasa de interes a la que el Banco de Argentina presta a Messi
R = 1/β+0.02 # Perfil de consumo creciente (Se endeuda)
## Proceso para el ingreso de Leo
Y = ones(T+1) # Ingreso constante a lo largo de la vida
Φ = 0.0 # Se supone un valor de Φ y una tasa R cualquiera.

# Valor presente del ingreso de Leo
Y_bar = sum(Y./(R.^(0:T)))

# Consumo
C0        = ((1-β)/(1-β^(T+1)))*Y_bar
C_initval = ((β*R).^(0:T)).*C0

# Activos
A_initval    = zeros(T)
A_initval[1] = R*A_0+Y[1]-C_initval[1]
for t = 2:T
    global A_initval[t] = R*A_initval[t-1]+Y[t]-C_initval[t]
end

xcero = fill(0.0,length(A_initval))
for i = 1:length(A_initval)
    xcero[i] = max(Φ,A_initval[i])
end
# Usamos el tercer argumento para indicar la cota inferior para At
lower = fill(Φ,T)
upper = fill(35.0, T)
resultados = optimize(messi_fun,lower,upper,xcero)
A_t3 = resultados.minimizer

# Peguemos el valor terminal
A_t3 = [A_t3' A_T]

# Calculemos el consumo de Messi
C_t3 = zeros(T)

for t = 1:T
    if (t==1)
        C_t3[1] = A_0*R+Y[1]-A_t3[1]
    else
        C_t3[t] = A_t3[t-1].*R+Y[t]-A_t3[t]
    end
end

plot(hcat(A_t3',A_t2',A_t'),xlabel="t",ylabel="A(t)",title="Activos - Inciso 3")
savefig("Activos - Inciso 3.pdf")
plot(hcat(C_t3,C_t2,C_t),xlabel="t",ylabel="C(t)",title="Consumo - Inciso 3")
savefig("Consumo - Inciso 3.pdf")

##############################################################################
# INCISO 4)
Random.seed!(15)

# Creación de Yt como proceso aleatorio AR(1)
Y_1= 1
μ = 1
ρ = 0.8
sigma_ϵ = 0.2

ϵ_t =  Normal(0,sigma_ϵ)
ϵ = rand(ϵ_t,T+1,1)

plot(ϵ)
Y = ones(T+1)

for t = 2:(T+1)
    global Y[t] = μ*(1-ρ) + ρ*Y[t-1]+ϵ[t]
end
plot(Y)
##############################################################################
# INCISO 4 (a)

## Valores de los parametros
β   = 0.98      ; # Factor de descuento de Leo
σ  = 1.5        ; # Coeficiente de aversion al riesgo de Messi
T      = 70     ; # Horizonte de vida que le queda a la pulga
A_T    = 0      ; # Herencia que deja Leo a Thiago Messi
A_0    = 0      ; # Valor inicial de sus activos
# Tasa de interes a la que el Banco de Argentina presta a Messi
R = 1/β-0.02 # Perfil de consumo creciente (Se endeuda)
## Proceso para el ingreso de Leo
Φ = -Inf # Se supone un valor de Φ y una tasa R cualquiera.

# Valor presente del ingreso de Leo
plot(Y)
Y_bar = sum(Y./(R.^(0:T)))

# Consumo
C0        = ((1-β)/(1-β^(T+1)))*Y_bar
C_initval = ((β*R).^(0:T)).*C0

# Activos
A_initval    = zeros(T)
A_initval[1] = R*A_0+Y[1]-C_initval[1]
for t = 2:T
    global A_initval[t] = R*A_initval[t-1]+Y[t]-C_initval[t]
end

# Valor inicial
xcero = A_initval

# Usamos el tercer argumento para indicar la cota inferior para At
lower = fill(-40.0,T)
upper = fill(1.0, T)
resultados = optimize(messi_fun,lower,upper,xcero)
A_t4 = resultados.minimizer

# Peguemos el valor terminal
A_t4 = [A_t4' A_T]

# Calculemos el consumo de Messi
C_t4 = zeros(T)

for t = 1:T
    if (t==1)
        C_t4[1] = A_0*R+Y[1]-A_t4[1]
    else
        C_t4[t] = A_t4[t-1].*R+Y[t]-A_t4[t]
    end
end

plot(A_t4',xlabel="t",ylabel="A(t)",title="Activos - Inciso 4-a")
savefig("Activos - Inciso 4-a.pdf")
plot(C_t4,xlabel="t",ylabel="C(t)",title="Consumo - Inciso 4-a")
savefig("Consumo - Inciso 4-a.pdf")

##############################################################################
# INCISO 4 (b)

## Valores de los parametros
β   = 0.98      ; # Factor de descuento de Leo
σ  = 1.5        ; # Coeficiente de aversion al riesgo de Messi
T      = 70     ; # Horizonte de vida que le queda a la pulga
A_0    = 0      ; # Valor inicial de sus activos
A_T    = 0      ; # Herencia que deja Leo a Thiago Messi
# Tasa de interes a la que el Banco de Argentina presta a Messi
R = 1/β-0.02 # Perfil de consumo creciente (Se endeuda)
## Proceso para el ingreso de Leo
Φ = 0 # Se supone un valor de Φ y una tasa R cualquiera.

# Valor presente del ingreso de Leo
plot(Y)
Y_bar = sum(Y./(R.^(0:T)))

# Consumo
C0        = ((1-β)/(1-β^(T+1)))*Y_bar
C_initval = ((β*R).^(0:T)).*C0

# Activos
A_initval    = zeros(T)
A_initval[1] = R*A_0+Y[1]-C_initval[1]
for t = 2:T
    global A_initval[t] = R*A_initval[t-1]+Y[t]-C_initval[t]
end
plot(A_initval)

# Valor inicial
xcero = fill(0.0,length(A_initval))
for i = 1:length(A_initval)
    xcero[i] = max(Φ,A_initval[i])
end
minimum(A_initval)
# Usamos el tercer argumento para indicar la cota inferior para At
lower = fill(0.0,T)
upper = fill(0.01, T)
resultados = optimize(messi_fun,lower,upper,xcero)
A_t5 = resultados.minimizer
maximum(A_t5)

# Peguemos el valor terminal
A_t5 = [A_t5' A_T]

# Calculemos el consumo de Messi
C_t5 = zeros(T)

for t = 1:T
    if (t==1)
        C_t5[1] = A_0*R+Y[1]-A_t5[1]
    else
        C_t5[t] = A_t5[t-1].*R+Y[t]-A_t5[t]
    end
end

plot(hcat(A_t5',A_t4'),xlabel="t",ylabel="A(t)",title="Activos - Inciso 4a-b",yaxis=(0,3))
savefig("Activos - Inciso 4-b.pdf")
plot(hcat(C_t5,C_t4),xlabel="t",ylabel="C(t)",title="Consumo - Inciso 4a-b")
savefig("Consumo - Inciso 4-b.pdf")

#############################################################################
# INCISO 4 (c) con ϕ=-Inf

nSim= 1
T=70

Consumo = ones(1,T)

for i = 1:(nSim)
#Generando y's
    Y_1= 1
    T=70
    μ = 1
    ρ = 0.8
    sigma_ϵ = 0.2

    ϵ_t =  Normal(0,sigma_ϵ)
    ϵ = rand(ϵ_t,T+1,1)

    plot(ϵ)
    Y = ones(T+1)

    for t = 2:(T+1)
        global Y[t] = μ*(1-ρ) + ρ*Y[t-1]+ϵ[t]
    end


    ## Valores de los parametros
    β   = 0.98      ; # Factor de descuento de Leo
    σ  = 1.5        ; # Coeficiente de aversion al riesgo de Messi
    T      = 70     ; # Horizonte de vida que le queda a la pulga
    A_T    = 0      ; # Herencia que deja Leo a Thiago Messi
    A_0    = 0      ; # Valor inicial de sus activos
    # Tasa de interes a la que el Banco de Argentina presta a Messi
    R = 1/β-0.02 # Perfil de consumo creciente (Se endeuda)
    ## Proceso para el ingreso de Leo
    Φ = -Inf # Se supone un valor de Φ y una tasa R cualquiera.

    # Valor presente del ingreso de Leo
    plot(Y)
    Y_bar = sum(Y./(R.^(0:T)))

    # Consumo
    C0        = ((1-β)/(1-β^(T+1)))*Y_bar
    C_initval = ((β*R).^(0:T)).*C0

    # Activos
    A_initval    = zeros(T)
    A_initval[1] = R*A_0+Y[1]-C_initval[1]
    for t = 2:T
        global A_initval[t] = R*A_initval[t-1]+Y[t]-C_initval[t]
    end

    # Valor inicial
    xcero = A_initval

    # Usamos el tercer argumento para indicar la cota inferior para At
    lower = fill(-10.0,T)
    upper = fill(1.0, T)
    resultados = optimize(messi_fun,lower,upper,xcero)
    A_t6 = resultados.minimizer

    # Peguemos el valor terminal
    A_t6 = [A_t6' A_T]

    # Calculemos el consumo de Messi
    C_t6 = zeros(T)

    for t = 1:T
        if (t==1)
            C_t6[1] = A_0*R+Y[1]-A_t6[1]
        else
            C_t6[t] = A_t6[t-1].*R+Y[t]-A_t6[t]
        end
    end
	global Consumo= vcat(Consumo, C_t)
end

C= mean(Consumo[2:end , :],dims=1)

plot(C')

#############################################################################
# INCISO 4 (c) con ϕ=0

nSim= 100
T=70

Consumo = ones(1,T)

for i = 1:(nSim)
#Generando y's
    β   = 0.98      ; # Factor de descuento de Leo
    σ  = 1.5        ; # Coeficiente de aversion al riesgo de Messi
    T      = 70     ; # Horizonte de vida que le queda a la pulga
    A_0    = 0      ; # Valor inicial de sus activos
    A_T    = 0      ; # Herencia que deja Leo a Thiago Messi
    # Tasa de interes a la que el Banco de Argentina presta a Messi
    R = 1/β-0.02 # Perfil de consumo creciente (Se endeuda)
    ## Proceso para el ingreso de Leo
    Φ = 0 # Se supone un valor de Φ y una tasa R cualquiera.

    # Valor presente del ingreso de Leo
    plot(Y)
    Y_bar = sum(Y./(R.^(0:T)))

    # Consumo
    C0        = ((1-β)/(1-β^(T+1)))*Y_bar
    C_initval = ((β*R).^(0:T)).*C0

    # Activos
    A_initval    = zeros(T)
    A_initval[1] = R*A_0+Y[1]-C_initval[1]
    for t = 2:T
        global A_initval[t] = R*A_initval[t-1]+Y[t]-C_initval[t]
    end
    plot(A_initval)

    # Valor inicial
    xcero = fill(0.0,length(A_initval))
    for i = 1:length(A_initval)
        xcero[i] = max(Φ,A_initval[i])
    end
    minimum(A_initval)
    # Usamos el tercer argumento para indicar la cota inferior para At
    lower = fill(0.0,T)
    upper = fill(1.0, T)
    resultados = optimize(messi_fun,lower,upper,xcero)
    A_t7 = resultados.minimizer
    maximum(A_t7)

    # Peguemos el valor terminal
    A_t7 = [A_t7' A_T]

    # Calculemos el consumo de Messi
    C_t7 = zeros(T)

    for t = 1:T
        if (t==1)
            C_t7[1] = A_0*R+Y[1]-A_t7[1]
        else
            C_t7[t] = A_t7[t-1].*R+Y[t]-A_t7[t]
        end
    end
	global Consumo= vcat(Consumo, C_t7')
end

C_2= mean(Consumo[2:end , :],dims=1)
maximum(C)
minimum(C)
plot(C')


plot(hcat(C_t4,C_2'),xlabel="t",ylabel="C(t)",title="Consumo - Inciso 4c")
savefig("Consumo - Inciso 4c.pdf")
