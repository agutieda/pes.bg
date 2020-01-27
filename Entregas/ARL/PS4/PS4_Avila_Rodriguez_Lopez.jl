##################################################################################
#                               TAREA NO. 4                                      #
##################################################################################
using Plots

beta   = 0.98   # Factor de descuento de Leo
sigma  = 1.5   # Coeficiente de aversion al riesgo de Messi
T      = 70     # Horizonte de vida que le queda a la pulga
A_0    = 0      # Valor inicial de sus activos
A_T    =0
## Sendas para las variables exogenas

# Tasa de interes a la que Mascherano presta (o pide prestado) a Leo
R =  1/beta - 0.02 # Perfil de consumo creciente (Se endeuda)
#R = 1/beta+0.02 # Perfil de consumo decreciente (Ahorra)
#R = 1/beta      # Perfil de consumo constante a traves del tiempo

## Proceso para el ingreso de Leo
Y = ones(T+1) # Ingreso constante a lo largo de la vida

# Descomente la siguiente linea para asumir que Leo se retira a los 40
#Y[40:T+1]=0

# Descomente el siguiente bloque para simular un proceso de ingreso mas
# complicado donde el FC Barcelona sube a Leo su sueldo anualmente
g = 0.04 # Tasa de crecimiento del ingreso
Y[1] = 1
for t in 2:(T+1)
    Y[t] = (1+g)*Y[t-1]
end

#X = 1:70

Y[41:end].=0 # Se retira a los 40
X = 1:T+1

plot(X,Y)
savefig("GraficaB4.pdf")
# Note que Leo no solo tiene gran vision en el campo de juego sino tambien en
# este modelo

# Esto le permite saber con certeza su ingreso en cada periodo de su vida,
# inclusive su ingreso futuro

## Funcion de utilidad instantanea de Leo
function U_t(C)
    if sigma == 1
        U_t = log(C)
    else
        U_t = (C.^(1-sigma)-1)/(1-sigma)
    end
end

## Funcion objetivo de Leo

function messi_fun(A_vec)
    A_vec_lag = [A_0 A_vec']
    A_vec     = [A_vec' A_T]             # Vector de activos
    C_vec     = A_vec_lag.*R + Y'-A_vec
    beta_vec  = beta.^(0:T)                # Vector con tasas de descuento
    bienestar = sum(beta_vec.*U_t.(C_vec'))

    return(-bienestar)
end

################################################################################
# 2) Problema de Ahorro Optimo de Leo Messi: Solucion cuando sigma = 1
################################################################################

# Bajo ciertos supuestos, la solucion del modelo se puede hallar con lapiz y
# papel: sigma=1 y A0=AT=0

# Valor presente del ingreso de Leo
Y_bar = sum(Y./(R.^(0:T)))

# Consumo
C0        = ((1-beta)/(1-beta^(T+1))).*Y_bar
C_initval = ((beta*R).^(0:T))*C0

# Activos
A_initval    = zeros(T)
A_initval[1] = R*A_0+Y[1]-C_initval[1]

for t in 2:T
    A_initval[t] = R*A_initval[t-1]+Y[t]-C_initval[t]
end

# Y grafiquemos
X1 = 1:T
Plots.plot(X1,A_initval, title ="Simulacion: sigma=1", ylab="A(t)",xlab="t" )
savefig("Simulacion_sigma_1_B4.pdf")
################################################################################
# 3) Problema de Ahorro Optimo de Leo Messi: Solucion cuando sigma != 1
################################################################################

# Cuando sigma no es 1, debemos acudir a un algoritmo de optimizacion para
# encontrar una solucion numerica

# Ahora usaremos la solucion particular como valor inicial
using Optim

x0 = A_initval
messi_fun(x0)
lower = fill(-13.0,T)
upper = fill(70.0,T)
results = optimize(messi_fun,lower,upper,x0)
A_t = results.minimizer

# Peguemos el valor terminal
A_t = [A_t' A_T]
A_t

# Calculemos el consumo de Leo
C_t = zeros(T)

for t in 1:T
    if t==1
        C_t[1] = A_0*R+Y[1]-A_t[1]
    else
        C_t[t] = A_t[t-1]*R+Y[t]-A_t[t]
    end
end
# Y grafiquemos
#y_ax_bound = 2*max(max(Y),max(abs(A_t)))
Plots.plot(X,A_t', ylab="A(t)",xlab="t", title = "Activos: Caso General", ylim=(- 52.06268, 52.06268))
Plots.plot!(X,zero)
savefig("Activos_Caso_General_B4.pdf")
X2 = 1:T
Plots.plot(X2,C_t, ylab="C(t)",xlab="t", title = "Consumo: Caso General", ylim=(0, 9.232732))
plot!(X2, zero)
savefig("Consumo_Caso_General_B4.pdf")

################################################################################
# 3) Problema de Ahorro Optimo de Leo Messi: Solucion con restricciones de deuda
################################################################################

# Supongamos ahora que el malvado gobierno espanol,al servicio del Real Madrid,
# decide atacar a Leo con un proceso por fraude fiscal. Esto impide al mejor de
# la historia contraer deudas por encima de un umbral A_bound, incluso con su
# amigo Mascherano

# Por lo anterior, At>=A_bound en todo periodo

# Usamos el algoritmo optim() incluyendo una restriccion de desigualdad en cero
#A_bound = 0
A_bound = 0
# A_bound <- -0.1
x0 = zeros(length(A_initval))
for i in 1:length(A_initval)
    x0[i] = max(A_bound,A_initval[i])
end
lower = fill(-0.5,T)
upper = fill(60.0,T)
messi_fun(x0)
resultados2 = optimize(messi_fun, lower, upper,x0 )
A_t = resultados2.minimizer

# Peguemos el valor terminal
A_t = [A_t' A_T]
A_t

# Calculemos el consumo de Messi
C_t = zeros(T)

for t in 1:T
    if t==1
        C_t[1] = A_0*R+Y[1]-A_t[1]
    else
    C_t[t] = A_t[t-1]*R+Y[t]-A_t[t]
    end
end

# Y grafiquemos
Plots.plot(X,A_t', ylab="A(t)",xlab="t", title = "Activos: Restriccion de liquidez", ylim=(-10.0, 52.06268))
Plots.plot!(X,zero)
savefig("Activos_Restriccion_de_liquidez_B4.pdf")
Plots.plot(X2,C_t, ylab="C(t)",xlab="t", title= "Consumo: Restriccion de liquidez", ylim=(0, 9.232732))
#scatter!( C_t, label="points")
Plots.plot!(X,zero)
savefig("Consumo_Restriccion_liquidez_B4.pdf")

#################################################################################
#                                   AR(1)                                       #
#################################################################################
# Nuestro proceso es:
# y(t) = mu(1-rho) + rho*Y[t-1]+epsilon[t]; epsilon(t)~N(0,sigma^2); y(0) dado.

#### 1a) Parametros del modelo ####
T     = 71         # Numero de observaciones a simular
rho   = 0.8        # Persistencia del proceso
mu    = 1      # Constante del proceso
sigma = 0.2       # Desv. Est. de los choques del proceso
y0    = 1          # Valor inicial del proceso

####Esribimos una funcion que simule el proceso para ###
function Ar_1(rho_sim,mu_sim,sigma_sim,y0_sim,T_sim,epsilon_sim)
y_sim = zeros(T)
y_sim
y_sim[1] = y0_sim
for t in 2:T_sim
    y_sim[t]=mu_sim*(1-rho_sim)+rho_sim*y_sim[t-1]+epsilon_sim[t]
end
return y_sim
end

#### Procesos Exogenos ####
epsilon = sigma.*randn(T)

####Simulacion ####
# Forma 1 de llamar la funcion: El orden importa
Y = Ar_1(rho,mu,sigma,y0,T,epsilon)
X= 1:T
plot(X,Y)

using Statistics
Ctprom = mean(C_t, dims = 1)
