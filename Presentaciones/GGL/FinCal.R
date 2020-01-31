# Proyecto Final: Librería FinCal

#Programacion II
#Programa de Estudios Superiores
#Banco de Guatemala

#Integrantes:

#Marianna Guzmán
#Joaquín Gordillo Sajbín
#Luis Lemus Mackay

graphics.off(); rm(list=ls());
ls()

#FinCal

#Es un paquete para el cálculo del valor del dinero en el tiempo, 
#análisis de series temporales y finanzas computacionales.

#LIBRERÍA A UTILIZAR

#FinCal está disponible en [CRAN] (http://cran.r-project.org/web/packages/FinCal/) 
install.packages("FinCal",dependencies=TRUE)
library("FinCal")

#La librería también se puede descargar directamente desde GitHub
library("devtools")
install_github("felixfan/FinCal") 

#FinCal cuenta con múltiples funciones. Para ver el listado o repertorio de
#las mismas, se puede utilizar el siguiente comando
ls("package:FinCal")

#Para obtener ayuda con alguna de las funciones se pueden emplear los siguientes 
#comandos 

help(pv)    # display the documentation for the function
args(pv)    # see arguments of the function
example(pv) # see example of using the function

#Este link es una especie de manual o diccionaio de todas la funciones 
#https://cran.r-project.org/web/packages/FinCal/FinCal.pdf

#A continuación se proporciona un ejemplo de algunas de las funciones empleando
#estos comandos. Se acompañan con una breve descripción en español.

#Note: for all examples, cash inflows are positive and outflows are negative.

###############################################################################

#Rendimiento de descuento bancario (BDY) 
#La tasa de descuento bancario (o Discount Bank Yield en inglés) es una de las formas 
#en las que se puede presentar la rentabilidad de un título de mercado monetario 
#emitido al descuento.

#Este descuento es la diferencia entre el precio de cotización y el valor facial 
#del título anualizado.

#Cuando se adquiere un instrumento de mercado monetario emitido al descuento, 
#el vendedor estipula la cantidad que será reembolsada al vencimiento y el comprador 
#paga un precio menor. La diferencia entre esos dos precios sería lo que ganaría 
#el inversor. Pero si calculamos así la rentabilidad, no estaríamos obteniendo una 
#rentabilidad anualizada, que es la que se suele utilizar para medir la rentabilidad 
#de estos activos.

#Su fórmula es la siguiente 
#RBD=(D/F)*(360/t)
#Rbd = Rentabilidad anualizada utilizando la tasa de descuento bancaria.
#D= Descuento sobre el valor facial (se obtiene de restar al valor facial el precio 
#de cotización del instrumento)
#F= Valor facial del título.
#t= Días hasta el vencimiento del título.

help("bdy")    
args(bdy)    
example(bdy)

#Ejemplo: Se nos requiere calcular la tasa de descuento bancario de un bono cupón 
#cero emitido al descuento. El precio del bono es de 978,5 € con un valor facial 
#de 1.000 € y éste vence en 135 días.

bdy(d=1000-978.5, f=1000, t=135)

################################################################################

#Convirtiendo el RDB a Rendimiento del mercado monetario (MMY)

#El rendimiento del mercado monetario es la tasa de rendimiento de las inversiones 
#altamente líquidas con un vencimiento inferior a un año. Se calcula multiplicando 
#el rendimiento del período de tenencia con un factor de 360/t donde t es el número 
#de días entre la fecha de emisión y la fecha de vencimiento de la inversión.

help("bdy2mmy")    
args(bdy2mmy)

#What is the money market yield for a 120-day T-bill that has a bank discount 
#yield of 4.50%?
example(bdy2mmy)

################################################################################

#Tasa Anual Efectiva (EAR por sus siglas en inglés)

#La TEA es el indicador con el que se calcula la tasa de interés en el plazo de 
#un año. Es importante comprender que este cálculo puede hacerse para conocer tanto 
#la rentabilidad de una cuenta como el costo de un préstamo o crédito. 
#Cuanto mayor sea la TEA, mayor será el interés que recibirás mientras ahorres 
#tu dinero y, por ende, tus ahorros crecerán más. Por el contrario, mientras más 
#alta sea la Tasa Efectiva Anual en un crédito, mayores serán los intereses que 
#tendrás que pagar y más caro te saldrá el préstamo. 

help("ear")    
args(ear)

#Using a stated rate of 4.25%, compute EARs for semiannual, quarterly, monthly, 
#and daily compounding.
ear(0.0425, 2)
ear(0.0425, 4)
ear(0.0425, 12)
ear(0.0425, 365)

################################################################################

#Valor Futuro 

#El valor futuro (VF) es el valor que tendrá en el futuro un determinado monto 
#de dinero que mantenemos en la actualidad o que decidimos invertir en un proyecto 
#determinado.

#El valor futuro (VF) nos permite calcular cómo se modificará el valor del dinero 
#que tenemos actualmente (en el día de hoy) considerando las distintas alternativas 
#de inversión que tenemos disponibles. Para poder calcular el VF necesitamos conocer 
#el valor de nuestro dinero es el momento actual y la tasa de interés que se le 
#aplicará en los períodos venideros.

#El Valor futuro se utiliza para evaluar la mejor alternativa en cuanto a qué hacer 
#con nuestro dinero hoy. También para ver cómo cambia el valor del dinero en el futuro.

help("fv.simple")    
args(fv.simple)

#Calculate the FV of a $300 investment at the end of ten years if it earns an 
#annually compounded rate of return of 8%.

#Calculate the FV of a $50,000 investment at the end of twenty years if it earns an 
#annually compounded rate of return of 4%.
example(fv.simple)

################################################################################

#Valor presente 

#El valor presente (VP) es el valor que tiene a día de hoy un determinado flujo 
#de dinero que recibiremos en el futuro.

#Es decir, el valor presente es una fórmula que nos permite calcular cuál es el 
#valor de hoy que tiene un monto de dinero que no recibiremos ahora mismo, sino 
#más adelante.

help("pv.simple")    
args(pv.simple)

#Given a discount rate of 7%, calculate the PV of a $100,000 cash flow that will 
#be received in ten years.

#Given a discount rate of 3%, calculate the PV of a $1,000,000 cash flow that will 
#be received in three years.

example(pv.simple)

################################################################################

#Valor futuro de una anualidad ordinaria 

#Definición de anualidad: Una anualidad es una serie de pagos que cumple con las
#siguientes condiciones:

#Todos los pagos son de igual valor.
#Todos los pagos se hacen a iguales intervalos de tiempo.
#Todos los pagos son llevados al principio o al final de la serie a la misma tasa.
#El número de pagos debe ser igual al número de periodos.

help("fv.annuity")    
args(fv.annuity)

#What is the future value of an ordinary annuity that pays $15,000 per year at 
#the end of each of the next 25 years, given the investment is expected to earn 
#a 6% rate of return?

fv.annuity(r = 0.06, n = 25, pmt = -15000, type = 0)

#What is the future value of an annuity that pays $10,000 per year at the beginning 
#of each of the next three years, commencing today, if the cash flows can be 
#invested at an annual rate of 5%?

fv.annuity(r = 0.05, n = 3, pmt = -10000, type = 1)

################################################################################

#Valor presente de una anualidad ordinaria 

help("pv.annuity")    
args(pv.annuity)

#What is the PV of an annuity that pays $20,000 per year at the end of each of 
#the next 25 years, given a 6% discount rate?

pv.annuity(r = 0.06, n = 25, pmt = -20000, type = 0)

#Given a discount rate of 10%, what is the present value of a 10-year annuity 
#that makes a series of $1000 payments at the beginning of each of the next 
#three years, starting today?

pv.annuity(r = 0.1, n = 10, pmt = -1000, type = 1)

################################################################################

#Valor presente de una perpetuidad 

#Es el valor de un flujo de pagos perpetuos, o que se estima no serán interrumpidos 
#ni modificados nunca.

help("pv.perpetuity")    
args(pv.perpetuity)

#A preferred stock that will pay $2.50 per year in annual dividends beginning next 
#year and plans to follow this dividend policy forever. Given an 10% rate of 
#return, what is the value of this preferred stock today?

pv.perpetuity(r = 0.1, pmt = 2.5, type = 0)

example("pv.perpetuity")

################################################################################

#Tasa de retorno de una perpetuidad

help("r.perpetuity")    
args(r.perpetuity)

#Using the preferred stock described in the preceding example, determine the rate 
#of return that an investor would realize if she paid $75 per share for the stock.

r.perpetuity(pmt = 2.5, pv = -75)

example("r.perpetuity")

################################################################################

#Valor presente de los flujos de efectivo de un bono

help("pv")    
args(pv)

#A bond will make coupon interest payments of 70 HK$ (dólar hongkonés) 
#(7% of its face value) at the end of each year and will also pay its face value 
#of 1,000 HK$ at maturity in 10 years. If the appropriate discount rate is 6%, 
#what is the present value of the bond's promised cash flows?

pv(r = 0.06, n = 10, fv = 1000, pmt = 70, type = 0)

example(pv)

################################################################################

#Valor presente y futuro de un flujo de efectivo desigual 

#Cuando una corriente de flujo de efectivo es desigual, el valor presente (PV) 
#y/o el valor futuro (FV) de la corriente se calculan al encontrar la PV o FV 
#de cada flujo de efectivo individual y sumarlos.

#Una corriente de flujos de efectivo es desigual cuando:
#Todos los montos en la serie de flujos de efectivo no son iguales, y/o
#Hay un tiempo desigual entre dos flujos de efectivo.

help("fv.uneven")    
args(fv.uneven)

#Ejemplo 
#Using a rate of return of 6%, compute the future value of the 6-year uneven cash 
#flow stream occured at the end of each year. (-10000 -5000 2000 4000 6000 8000)

fv.uneven(r = 0.06, cf = c(-10000, -5000, 2000, 4000, 6000, 8000))
example(fv.uneven)

help("pv.uneven")    
args(pv.uneven)

#Compute the present value of this 6-year uneven cash stream described above 
#using a 10% rate of return.

pv.uneven(r = 0.1, cf = c(-10000, -5000, 2000, 4000, 6000, 8000))
example("pv.uneven")

################################################################################

#Cálculo del pago del préstamo

help("pmt")    
args(pmt)

#A company plans to borrow $500,000 for five years. The company's bank will lend 
#the money at a rate of 6% and requires that the loan be paid off in five equal 
#end-of-year payments. Calculate the amount of the payment that the company must 
#make in order to fully amortize this loan in five years.

pmt(r = 0.06, n = 5, pv = 5e+05, fv = 0, type=0)

example(pmt)

################################################################################

#Calcular el número de períodos en una anualidad

help("n.period")    
args(n.period)

#How many $1000 end-of-year payments are required to accumulate $10,000 if the 
#discount rate is 9%?

n.period(r = 0.09, pv = 0, fv = 10000, pmt = -1000, type = 0)

example(n.period)

################################################################################

#Calcular la tasa de rendimiento por un período

help("discount.rate")    
args(discount.rate)

#Suppose you have the opponunity to invest $1000 at the end of each of the next 
#five years in exchange for $6000 at the end of the fifth year. What is the 
#annual rate of return on this investment?

discount.rate(n = 5, fv = 6000, pmt = -1000, pv = 0, type = 0)

################################################################################

#Cálculo del Valor Presente Neto (NPV por sus siglas en inglés)

#El valor presente neto (VPN) de un proyecto representa el cambio en el patrimonio 
#neto/patrimonio de una empresa que resultaría de la aceptación del proyecto a 
#lo largo de su vida. Es igual al valor presente de las entradas netas de efectivo 
#del proyecto menos el desembolso de inversión inicial. Es una de las técnicas más 
#confiables utilizadas en el presupuesto de capital porque se basa en el enfoque 
#de flujo de efectivo descontado.

#Los cálculos del valor presente neto requieren las siguientes tres entradas:

#Flujos de efectivo netos proyectados después de impuestos en cada período del proyecto.
#Desembolso de inversión inicial
#Tasa de descuento adecuada, es decir, la tasa de obstáculo.

help("npv")    
args(npv)


#Ejemplo: 

#Calculate the NPV of an investment project with an initial cost of $6 million 
#and positive cash flows of $2.6 million at the end of Year 1, $2.4 million at 
#the end of Year 2, and $3.8 million at the end ofYear 3. Use 8% as the discount 
#rate.

npv(r = 0.08, cf = c(-6, 2.6, 2.4, 3.8))

example(npv)

################################################################################

#Tasa interna de rendimiento (TIR)

#En el presupuesto de capital, el conflicto entre VPN y TIR se refiere a una 
#situación en la cual el método de VPN clasifica los proyectos de manera diferente 
#al método de TIR. En caso de tal diferencia, una empresa debe aceptar proyectos 
#con mayor VPN.

#El valor actual neto (VAN o VPN) y la tasa interna de rendimiento (TIR) son dos 
#de las técnicas de análisis de inversión y presupuesto de capital más utilizadas. 
#Son similares en el sentido de que ambos son modelos de flujo de efectivo 
#descontados, es decir, incorporan el valor temporal del dinero. Pero también 
#difieren en su enfoque principal y sus fortalezas y debilidades. 
#El VPN es una medida absoluta, es decir, es la cantidad en dólares de valor 
#agregado o perdido al emprender un proyecto. La TIR, por otro lado, es una 
#medida relativa, es decir, es la tasa de rendimiento que ofrece un proyecto a 
#lo largo de su vida útil.

help("irr")    
args(irr)

#Ejemplo: 

#What is the IRR for the investment described in the previous example?

irr(cf = c(-6, 2.6, 2.4, 3.8))

irr(cf=c(-5, 1.6, 2.4, 2.8))

################################################################################

#Cáluclo del rendimiento del período de tenencia 

#El rendimiento del período de tenencia es el rendimiento total ganado en una 
#inversión durante todo su período de tenencia expresado como un porcentaje del 
#valor inicial de la inversión. Se calcula como la suma de la ganancia de capital 
#y los ingresos divididos por el valor de apertura de la inversión.

#Hay dos fuentes de rendimiento para cualquier inversión en bonos, acciones, 
#bienes raíces, etc.: (a) ganancia de capital e (b) ingresos. La ganancia o pérdida 
#de capital resulta del movimiento en el valor de la inversión desde la fecha de
#compra hasta la fecha en que se calcula el rendimiento del período de tenencia. 
#El ingreso resulta de pagos de cupones, dividendos, alquileres, etc.

#El rendimiento del período de mantenimiento no es una medida estandarizada de 
#rendimiento. Un período de espera dado puede ser por un solo día o un período de 
#5 años y no lo sabremos. La comparación entre el rendimiento del período de 
#tenencia de diferentes inversiones directamente no es apropiada. 
#Necesitamos averiguar el tiempo total durante el cual se calcula el rendimiento 
#y luego convertirlo al rendimiento del período de tenencia anualizado.

help(hpr)
args(hpr)

#Ejemplo: 

#Suppose a stock is purchased for $3 and is sold for $4 six months later, during 
#which time it paid $0.50 in dividends. What is the holding period return?

hpr(ev = 4, bv = 3, cfr = 0.5)

example(hpr)

################################################################################

#Convetir el retorno del período de tenencia a la tasa anual efectiva

help(hpr2ear)
args(hpr2ear)

#Compute the EAR using the 120-day HPR of 2.85%

hpr2ear(hpr = 0.0285, t = 120)

example("hpr2ear")

################################################################################

#La tasa de rendimiento ponderada en el tiempo (TWR) 

#Es una medida de la tasa de crecimiento compuesta en una cartera. La medida TWR
#a menudo se usa para comparar los retornos de las inversiones porque elimina los 
#efectos distorsionadores sobre las tasas de crecimiento creados por las entradas 
#y salidas de dinero. El rendimiento ponderado en el tiempo divide el rendimiento 
#de una cartera de inversiones en intervalos separados en función de si se agregó 
#o retiró dinero del fondo.

#La medida de rendimiento ponderada en el tiempo también se denomina rendimiento 
#medio geométrico, que es una forma complicada de afirmar que los rendimientos de 
#cada subperíodo se multiplican entre sí.

help(twrr)
args(twrr)

#Ejemplo: 

#An investor purchases a share of stock at t = 0 for $200. At the end of the year 
#(at t = 1) the investor purchases an additional share of the same stock, this 
#time for $220. She then sells both shares at the end of the second year for $230 
#each. She also received annual dividends of $3 per share at the end of each year. 
#Calculate the annual time-weighted rate of return on her investment

#First, we break down the 2-year period into two 1-year periods:

#Holding period 1:
    
#Beginning value  = 200

#Dividends paid = 3

#Ending value = 220

#Holding period 2:
    
#Beginning value = 440 (2 shares * 220)

#Dividends paid = 6 (2 shares * 3)

#Ending value  = 460 (2 shares * 230)

twrr(ev=c(220,2*230), bv=c(200,2*220), cfr=c(3,2*3))

example(twrr)

################################################################################

#Convirtiendo entre Tasa Efectiva Anual (EAR), rendimiento del periodo de tenencia 
# (HPR) y Rendimiento del mercado monetario (MMY)


#Assume the price of a $10,000 T-bill that matures in 150 days is $9,800. 
#The quoted money market yield is 4.898%. Compute the HPY and the EAR.

mmy2hpr(mmy = 0.04898, t = 150)
hpr(ev = 10000, bv = 9800)
hpr2ear(hpr = mmy2hpr(mmy = 0.04898, t = 150), t = 150)
ear2hpr(ear = hpr2ear(hpr = mmy2hpr(mmy = 0.04898, t = 150), t = 150), t = 150)

################################################################################

#Cálculo del Rendimiento equivalente de bonos - BEY

#El rendimiento equivalente de bonos (BEY) permite que los valores de renta fija 
#cuyos pagos no sean anuales se puedan comparar con valores con rendimientos anuales. 
#El BEY es un cálculo para reexpresar los rendimientos de bonos o notas con 
#descuento semestral, trimestral o mensual en un rendimiento anual, y es el 
#rendimiento cotizado en los periódicos. 

#Las empresas pueden recaudar capital de dos maneras principales: deuda o capital. 
#El patrimonio se distribuye a los inversores en forma de acciones ordinarias; 
#ocupa el segundo lugar de la deuda en caso de quiebra o incumplimiento, y puede 
#no proporcionar al inversor un rendimiento si la empresa falla. Por el contrario, 
#la deuda se considera más barata para la empresa y es más segura que el capital 
#para los inversores. Aún así, la deuda debe ser pagada por la empresa, 
#independientemente del crecimiento de las ganancias. De esta manera, proporciona 
#un flujo de ingresos más confiable para el inversionista de bonos.

#Sin embargo, no todos los bonos son iguales. La mayoría de los bonos pagan a los 
#inversores pagos de intereses anuales o semestrales. Algunos bonos, denominados 
#bonos de cupón cero, no pagan intereses en absoluto, sino que se emiten con un 
#profundo descuento a la par. El inversor obtiene un rendimiento cuando vence el 
#bono. Para comparar el rendimiento de los valores descontados con otras 
#inversiones en términos relativos, los analistas utilizan la fórmula de rendimiento 
#equivalente de bonos.

help(hpr2bey)
args(hpr2bey)

#Ejemplo:

#What is the yield on a bond-equivalent basis of a 3-month loan that has a holding 
#period yield of 4%?

hpr2bey(hpr = 0.04, t = 3)

help("ear2bey")
args(ear2bey)

#What is the yield on a bond-equivalent basis of an investment with 6% effective 
#annual yield?

ear2bey(ear = 0.06)

################################################################################

#Cálculo de la media ponderada como retorno de cartera

help(wpr)
args(wpr)

#A portfolio consists of 40% common stocks, 50% bonds, and 10% cash. If the return 
#on common stocks is 9%, the return on bonds is 6%, and the return on cash is 1%, 
#what is the portfolio return?

wpr(r = c(0.09, 0.06, 0.01), w = c(0.4, 0.5, 0.1))

example(wpr)

################################################################################

#Retorno medio geométrico

#La tasa geométrica de rentabilidad es especialmente útil para medir la rentabilidad 
#media de las operaciones financieras en las que las revalorizaciones o 
#desvalorizaciones son acumulativas. Por tanto, esta medida es la adecuada y 
#correcta en lugar de la rentabilidad media calculada, como es más habitual, 
#mediante la media simple o aritmética. La tasa geométrica de rentabilidad se 
#corresponde con la rentabilidad que se deduciría mediante la aplicación de la 
#capitalización compuesta

#La rentabilidad geométrica o tasa geométrica de rentabilidad (TGR) se utiliza 
#para conocer la rentabilidad de los activos financieros de la empresa de una 
#forma más real a lo largo del tiempo que a través de una media aritmética. 
#Sirve para conocer la rentabilidad de aquellos activos que hayan sufrido 
#revalorizaciones o desvalorizaciones de forma acumulativa.

#La tasa de rentabilidad geométrica coincide con la rentabilidad que el inversor 
#obtiene tras aplicar la capitalización compuesta en su inversión.

help("geometric.mean")
args(geometric.mean)

#Ejemplo: 

#For the last three years, the returns for Acme Corporation common stock have 
#been -5%, 11%, and 9%. Compute the compound annual rate of return over the 
#3-year period.

geometric.mean(r = c(-0.05, 0.11, 0.09))

################################################################################

#Calcular el costo promedio con la media armónica

help("harmonic.mean")
args(harmonic.mean)

#An investor purchases $10,000 of stock each month, and over the last three 
#months the prices paid per share were $4.5, $5.2, and $4.8. What is the average 
#cost per share for the shares acquired?

harmonic.mean(p = c(4.5, 5.2, 4.8))

################################################################################

#Costos de productos vendidos

#Una de las principales decisiones contables que deben tomar las empresas que venden 
#productos es qué método utilizar para registrar el costo de los gastos de venta 
#de bienes, que es la suma de los costos de los productos vendidos a los clientes 
#durante el período. Se deduce el costo de los bienes vendidos de los ingresos por 
#ventas para determinar el margen bruto. El costo de los bienes vendidos es una 
#cifra muy importante porque si el margen bruto es incorrecto, el beneficio final 
#(ingreso neto) es incorrecto.

#Los costos del producto se ingresan en la cuenta del activo de inventario en el 
#orden en que se adquirieron, pero no necesariamente se sacan de la cuenta del 
#activo de inventario en el mismo orden. Puede elegir entre varios métodos para 
#registrar el costo de los bienes vendidos y el saldo de costos que permanece en 
#su cuenta de activos de inventario:

#El método FIFO (primero en entrar, primero en salir): Usted cobra los costos del 
#producto al costo de los bienes vendidos en el orden cronológico en el que los 
#adquirió. El procedimiento es así de simple. Es como si las primeras personas en 
#la fila que vieran una película entraran al cine primero. El tomador de boletos 
#recoge los boletos en el orden en que fueron comprados.

#El método LIFO (último en entrar, primero en salir): La característica principal 
#del método LIFO es que selecciona el último artículo que compró primero y luego 
#funciona hacia atrás hasta que tenga el costo total por el número total de unidades 
#vendidas durante el período.

#El método de costo promedio: en comparación con los métodos FIFO y LIFO, el método 
#de costo promedio parece ofrecer lo mejor de ambos mundos. Los costos de muchas 
#cosas en el mundo de los negocios fluctúan, por lo que puede decidir centrarse 
#en el costo promedio del producto durante un período de tiempo. Además, el 
#promedio de los costos de los productos durante un período de tiempo tiene un 
#efecto de suavización deseable que evita que el costo de los bienes vendidos 
#dependa demasiado de los cambios bruscos de una o dos adquisiciones.

help(cogs)

cogs(uinv=2,pinv=2,units=c(3,5),price=c(3,5),sinv=7,method="FIFO")
cogs(uinv=2,pinv=2,units=c(3,5),price=c(3,5),sinv=7,method="LIFO")
cogs(uinv=2,pinv=2,units=c(3,5),price=c(3,5),sinv=7,method="WAC")

inventario = c(20,30,50,70)
cogs(uinv=20,pinv=2,units=c(30,50), price=c(3,5), sinv=70, method = "WAC")

#uinv: unidades iniciales de inventario
#pinv: precio de inventario
#units: vector de unidades en el inventario.
#price: vector de precios de inventorio
#method inventory methods
################################################################################

#Download historical ﬁnancial data from Yahoo finance and Google Finance!!!!!!!!

#Aparentemente antes esta opción era viable con el paquete FinCal pero no funciona

#google <- get.ohlc.yahoo("GOOG",start="2013-07-01",end="2019-08-01"); candlestickChart(google)
#apple <- get.ohlc.google("AAPL",start="2013-07-01",end="2019-08-01"); candlestickChart(apple)


#Es por ello que se recurre a otros parquetes para lograr este objetivo. 

#https://cran.r-project.org/web/packages/BatchGetSymbols/BatchGetSymbols.pdf
#install.packages('BatchGetSymbols')
library(BatchGetSymbols)

#BatchGetSymbols Function to download financial data


#This function is designed to make batch downloads of financial data using getSymbols. 
#Based ona set of tickers and a time period, the function will download the data for 
#each ticker and return a report of the process, along with the actual data in the 
#long dataframe format. The main advantage of the function is that it automatically 
#recognizes the source of the dataset from the ticker and structures the resulting data
#from different sources in the long format. A caching system is also presente, 
#making it very fast.

help("BatchGetSymbols")
args(BatchGetSymbols)

tickers <- c('FB','MMM')
first.date <- Sys.Date()-30
last.date <- Sys.Date()
l.out <- BatchGetSymbols(tickers = tickers,
                         first.date = first.date,
                         last.date = last.date, do.cache=FALSE)
print(l.out$df.control)
print(l.out$df.tickers)

################################################################################
# set dates
first.date <- Sys.Date() - 60
last.date <- Sys.Date()
freq.data <- 'daily'
# set tickers
tickers <- c('FB','MMM','PETR4.SA','abcdef')

l.out <- BatchGetSymbols(tickers = tickers, 
                         first.date = first.date,
                         last.date = last.date, 
                         freq.data = freq.data,
                         cache.folder = file.path(tempdir(), 
                                                  'BGS_Cache') ) # cache in tempdir()

print(l.out$df.control)

#install.packages('ggplot2')
#library(ggplot2)

p <- ggplot(l.out$df.tickers, aes(x = ref.date, y = price.close))
p <- p + geom_line()
p <- p + facet_wrap(~ticker, scales = 'free_y') 
print(p)

################################################################################

#get.clean.data
#Get clean data from yahoo/google

help("get.clean.data")

df.sp500 <- get.clean.data('^GSPC',
                           first.date = as.Date('2010-01-01'),
                           last.date = as.Date('2019-02-01'))
df.sp500


################################################################################

#GetFTSE100Stocks 
#Function to download the current components of the FTSE100 index from Wikipedia

#This function scrapes the stocks that constitute the FTSE100 index from the 
#wikipedia page at <https://en.wikipedia.org/wiki/FTSE_100_Index#List_of_FTSE_100_companies>.

df.FTSE100 <- GetFTSE100Stocks()
df.FTSE100
print(df.FTSE100$tickers)

################################################################################

#GetSP500Stocks 
#Function to download the current components of the SP500 index from Wikipedia

df.SP500 <- GetSP500Stocks()
df.SP500
print(df.SP500$Tickers)

################################################################################
#EJEMPLOS PRÁCTICOS 
################################################################################

# Instalemos la libreria "readxl" 
#install.packages("readxl")
library(readxl)
library("FinCal")

Wacc = 0.1419

datos.desde.xls2  <- read_excel("Datos2.xlsx") 
datos.desde.xls2

# Definimos esta variable como el flujo de caja del Proyecto 1
fcn2=datos.desde.xls2$`FCN`
fcn2

# Retorna el valor presente de el flujo de caja
pv.uneven(r = Wacc, cf = fcn2)
# Regresa la tasa interna de retorno del Proyecto 1
irr(fcn2)

# Comparación de dos estructuras de deuda utilizando la funcion PMT
#Estructura de 50% de prestamo y 50% financiamiento propio
pmt(r = 0.165, n = 5, pv = 326775, fv = 0, type=0)

#Estructura de 15% de prestamo y 85% financiamiento propio.
pmt(r = 0.165, n = 5, pv = 98033, fv = 0, type=0)


#Importamos desde excel los flujos de efectivo de 3 diferentes proyectos.
#Cada proyecto tiene una distinta inversión inicial
datos.desde.xls3  <- read_excel("Proyectos.xlsx") 
datos.desde.xls3

#Cargamos los datos de cada Proyecto
PA=datos.desde.xls3$`PROYECTO A`
PA

PB=datos.desde.xls3$`PROYECTO B`
PB

PC=datos.desde.xls3$`PROYECTO C`
PC

#Valor presente neto de los tres proyectos dado una tasa de descuento.
VANPA=npv(0.07,PA)
VANPB=npv(0.07,PB)
VANPC=npv(0.07,PC)
VANPA
VANPB
VANPC

#Un inversionista puede comparar los diferentes proyectos para decidir en cual invertir
max(c(VANPA,VANPB,VANPC))


#Media ponderada del retorno de una cartera en especifico.
Retornos= c(0.4,0.7,0.9)
Portafolios = c(0.1, 0.4, 0.5)

wpr(r=Retornos, w=Portafolios)

################################################################################
###########################EJEMPLO SIMULACION#################################

#Por ejemplo una compañia estudia la introduccion de un nuevo producto: computadoras
#Entre los elementos de simulacion se pueden incluir:
##Cantidad de unidades a producir
##Precio de mercado
##Costos unitarios de produccion
##Costos unitarios de venta
##Precio de compra de maquinaria para fabricar nuevo producto
##Costo de capital

#################################################################################
#Parametros
#################################################################################

nSim=10000 #Numero de simulaciones
nT=10 #Numero de periodos del cashflow
tasa_desc=0.18 #Tasa de descuento (costo de capital)


#################################################################################
#Funcion para calcular el cash flow
#################################################################################
#q= cantidad ofertada
#p= precio de mercado del producto
#cp= costo unitario de produccion
#cv= costo unitario de ventas
#kT= cambio en el capital de trabajo
#ISR= tasa fiscal
#dep= depreciacion de maquinaria

cash_flow=function(q,p,cp,cv,kT,ISR,dep) {
    FCN = (q*p-q*(cv+cp)-dep)*(1-ISR)+dep-kT
    return(FCN) #Devuelve el cash flow de un periodo
}

#################################################################################
#Simulacion proceso AR(1) sobre el precio de mercado de computadoras
#################################################################################

#Como no podemos definir nuestro precio de mercado, se hace un proceso AR(1) 
#sobre el precio historico del producto

#Obtenemos de excel los precios historicos de computadoras 
#con una periodicidad mensual de febrero 1992 a noviembre 2019
#un total de 334 observaciones


Datos=read.csv("Precio_electronicos.csv")
#Definimos nuestro precio como todos los datos de la columna correspondiente a
#los precios de computadoras
Precio=Datos$A34HNO

#Graficamos los precios de las computadoras
x11();plot(Precio,type="l",xlab="t",col="#00aebc")

#Calculamos un AR(1)
Modelo_AR= ar.ols(Precio,aic=TRUE,order.max=1)
Modelo_AR

#El modelo AR(1) de los precios es: Yt= intercepto + rho*Yt-1+epsilont

#Le damos el valor al intercepto del Modelo AR(1)
intercepto=Modelo_AR$x.intercept

#Le damos valor al coeficiente del Modelo AR(1)
rho=Modelo_AR$ar

#El numero de observaciones usadas para estimar el Modelo AR(1)
obs=Modelo_AR$n.obs

#Definimos a sigma del error como la desv estandar de los residuos
sigma=sd(Modelo_AR$resid[2:obs])

#Funcion para simular el precio de computadoras
simular_AR1=function(intercept,rho_sim){
    epsilon_sim=rnorm(1,mean=0,sd=sigma) #Simulamos epsilon
    y=intercept+rho_sim*Precio[obs]+epsilon_sim
    
    return(y)
}

Precio_sim=simular_AR1(intercepto,rho)
Precio_sim


#################################################################################
#SIMULACION DE VPNs DE DISTINTOS ESCENARIOS DEL PROYECTO 
#################################################################################

#Vector vacio donde se van a guardar los VPNs
vec_vpn=rep(NaN,nSim)

#Vector vacio donde se van a guardar las diferentes inversiones iniciales
inv_inic= rep(NaN,nSim)

#Para cada simulacion
for (t in 1:nSim){
    #Sabemos que nuestra inversion inicial estara entre 100,000 y 1,000,000
    inv_inic[t]=sample(100000:1000000,1) #Simulamos la inversion inicial
    #Vector vacio en donde se va a guardar cada cashflow por el numero de periodos nT
    vec_cashflow=rep(NaN,nT)
    #El primer elemento del cashflow va a ser la inversion inicial pero en negativo
    vec_cashflow[1]=-inv_inic[t]
    #La depreciacion es el 20% de la inversion (maquinaria que vamos a comprar)
    depreciacion=-vec_cashflow[1]*0.2
    #El impuesto
    ISR=0.25
    
    for (i in 2:nT){
        #Simulamos las siguientes variables:
        
        #Sabemos que la cantidad del producto a ofertar va a estar entre 1,000 y 700 unidades al año
        q=cantidad=sample(100:700,1)
        
        
        #Sabemos el rango de nuestro cambio en el capital de trabajo
        ckt=cambio_Ktrabajo=sample(-2000:2000,1)
        
        #Como no podemos definir nuestro precio de mercado, se simula el precio de mercado
        p=simular_AR1(intercepto,rho)
        
        #Sabemos que nuestro costo unitario de produccion es el 60% del precio
        cp=costo_unitario_prod=0.60*p
        
        #Sabemos que nuestro costo unitario de venta es el 25% del precio
        cv=costo_unitario_venta=0.25*p
        
        #Cada cashflow se agrega al vector de cash flows de nT periodos
        vec_cashflow[i]=cash_flow(q,p,cp,cv,ckt,ISR,depreciacion)
        
    }
    #Se calcula el VPN para cada vector de cashflows para 10,000 simulaciones
    vec_vpn[t]=npv(r=tasa_desc,cf=vec_cashflow)
    
}

vec_vpn

#Media de VPNs 
mean(vec_vpn)

#Graficamos la distribucion de los VPNs
hist(vec_vpn,col="#f39200")

#Vector vacio donde se va a guardar 1 si el VPN es positivo y 0 si es negativo
vec_prob=rep(NaN,nSim)

#Funcion de probabilidad que el VPN sea menor a un numero
Menor = function(a){
    for (i in 1:nSim) {
        if (vec_vpn[i] < a)
            vec_prob[i]=1
        else
            vec_prob[i]=0
    }
    Probabilidad = sum(vec_prob)/nSim
    return(Probabilidad)
}

#La probabilidad que el VPN sea negativo
Menor(0)


#Funcion de probabilidad que el VPN sea mayor a un numero
Mayor = function(a){
    for (i in 1:nSim) {
        if (vec_vpn[i] > a)
            vec_prob[i]=1
        else
            vec_prob[i]=0
    }
    Probabilidad = sum(vec_prob)/nSim
    return(Probabilidad)
}

#La probabilidad que el VPN sea positivo
Mayor(0)

#La probabilidad que el VPN sea mayor a 500,000
Mayor(500000)

#################################
# EJEMPLO ANALISIS SENSIBILIDAD #
# Variable: Precio del Producto #
#################################


vec_vpn2=rep(NaN,nSim) #Creamos un vector que va a guardar todos los VPN por cada simulacion

inv_ini2=-sample(50000:200000,1) #Esta es la inversion inicial
q2=sample(100:700,1)
p2=simular_AR1(intercepto,rho)
cp2=0.60*p2 #Costo unitario de producción FIJO
cv2=0.25*p2 #Costo unitario por venta FIJO
ckt2=sample(-2000:2000,1) #Cambio de capital trabajo FIJO
depreciacion2=-inv_ini2*0.2 #Esta es la depreciacion de la maquinaria que se va a comprar con la inversion inicial
ISR=0.25

vec_precio=rep(NaN,nSim)

for (t in 1:nSim){
    vec_cashflow=rep(NaN,nT) #En este vector se guarda cada cashflow por la cantidad de periodos
    vec_cashflow[1]=-inv_ini2 #Valor inicial de la inversión
    vec_precio[t]=simular_AR1(intercepto,rho) #Vector de precios que se simulara para el analisis de sensibilidad
    
    for (i in 2:nT){
        
        #Agregamos al vector de cashflows el calculo del cashflow por cada periodo (nT)    
        vec_cashflow[i]=cash_flow(q2,vec_precio[t],cp2,cv2,ckt2,ISR,depreciacion2)
        
        
    }
    #Agregamos al vector de VPNs el calculo del VPN por cada vector de cashflow
    vec_vpn2[t]=npv(r=tasa_desc,cf=vec_cashflow)
    
}
vec_vpn2 #Cambios en el valor presente neto ante cambio en el precio

# Gráficas de sensibilidad de precios
x11();plot(vec_precio,vec_vpn2,type="l",xlim=c(2000,8000),xlab = "Precio",ylab="VPN", main = "Análisis de sensibilidad de precio")



