clear all
set more off
capture log 
set matsize 800

*Definimos directorios: asignamos un nombre
global DTA "C:\Users\cmenesesr\Desktop\SIE\Datos_SIE"
global LOG "C:\Users\cmenesesr\Desktop\SIE\LOG"
global OUT "C:\Users\cmenesesr\Desktop\SIE\OUTPUT"
global GRA "C:\Users\cmenesesr\Desktop\SIE\GRAPH"



import excel "$DTA\Diagnóstico Encuestas Economicas.xlsx", sheet("Encuestas") firstrow clear
save "DiagnosticoEncuestas.dta", replace

cd "$DTA"
import excel "$DTA\GES_DIRECTORIO_190806.xlsx", sheet("GES_DIRECTORIO") firstrow clear
save "directorio2018.dta", replace

import excel "$DTA\BDD_SCCE.xlsx", sheet("BDD_SCCE") firstrow clear
save "directorio2017.dta", replace
append using "directorio2018.dta", gen(timeskip)


tostring rut_emp, replace
replace ano_lev=year(fecha_levantamiento)
replace SIGLA_ENCUESTA="EMMT" if nombre_de_encuesta=="ENCUESTA MENSUAL MOLIENDA DE TRIGO"
replace SIGLA_ENCUESTA="ETC" if nombre_de_encuesta=="ENCUESTA TRIMESTRAL DE LA CONSTRUCCIÓN"
replace SIGLA_ENCUESTA="INNOVA" if nombre_de_encuesta=="ENCUESTA DE INNOVACIÓN EN EMPRESAS"
 replace SIGLA_ENCUESTA="EMG" if nombre_de_encuesta== "ENCUESTA MATADERO DE GANADO"
 replace SIGLA_ENCUESTA="EMA" if nombre_de_encuesta== "ENCUESTA MATADERO DE AVES"
replace SIGLA_ENCUESTA="ETC" if nombre_de_encuesta== "ENCUESTA TRIMESTRAL DE LA CONSTRUCCIÓN"
replace SIGLA_ENCUESTA="I+D" if nombre_de_encuesta== "ENCUESTA SOBRE GASTO Y PERSONAL EN INVESTIGACIÓN Y DESARROLLO (I+D) - AÑO 2016"
	replace nombre_de_encuesta= " ENCUESTA SOBRE GASTO Y PERSONAL EN INVESTIGACIÓN Y DESARROLLO" if SIGLA_ENCUESTA== "I+D"
replace SIGLA_ENCUESTA="ELE" if nombre_de_encuesta=="ENCUESTA LONGITUDINAL A EMPRESAS"
	replace nombre_de_encuesta="ENCUESTA LONGITUDINAL DE EMPRESAS" if SIGLA_ENCUESTA=="ELE"
replace SIGLA_ENCUESTA="EAR" if nombre_de_encuesta=="ENCUESTA ANUAL DE RADIOS"
replace SIGLA_ENCUESTA="EEP" if nombre_de_encuesta=="ENCUESTA DE ESPECTACULOS PÚBLICOS"
replace SIGLA_ENCUESTA="ETRAN" if nombre_de_encuesta=="ENCUESTA DE SERVICIOS DE TRANSPORTE DE CARGA" |nombre_de_encuesta=="ENCUESTA DE SERVICIOS DE TRANSPORTE DE PASAJEROS" 
replace SIGLA_ENCUESTA="IR-ICMO" if nombre_de_encuesta=="ENCUESTA ESTRUCTURAL DE REMUNERACIONES Y COSTO DE LA MANO DE OBRA Y EMPLEO"

*replace nombre_de_encuesta="" if SIGLA_ENCUESTA=="IR-ICMO"

replace SIGLA_ENCUESTA="TIC" if nombre_de_encuesta=="ENCUESTA TIC A EMPRESAS 2015" 
	replace nombre_de_encuesta="ENCUESTA TIC A EMPRESAS" if nombre_de_encuesta=="ENCUESTA TIC A EMPRESAS 2015"

replace SIGLA_ENCUESTA="ISUP" if nombre_de_encuesta=="SISTEMA DE SUPERMERCADOS SECCION INVENTARIOS" | nombre_de_encuesta=="SISTEMA DE SUPERMERCADOS SECCION VENTAS"


replace SIGLA_ENCUESTA="ENIA" if nombre_de_encuesta=="ENCUESTA NACIONAL DE LA INDUSTRIA MANUFACTURERA - AÑO 2016"
	replace nombre_de_encuesta="ENCUESTA NACIONAL DE INDUSTRIA ANUAL" if SIGLA_ENCUESTA=="ENIA"
 
replace SIGLA_ENCUESTA="ECOM" if nombre_de_encuesta=="ENCUESTAS ANUALES DE COMERCIO, SERVICIO Y TURISMO"
	replace nombre_de_encuesta="ENCUESTA ESTRUCTURAL DE COMERCIO" if SIGLA_ENCUESTA=="ECOM"

replace SIGLA_ENCUESTA="EMAT" if nombre_de_encuesta=="ENCUESTA MENSUAL DE ALOJAMIENTO TURÍSTICO"
replace SIGLA_ENCUESTA="IICOM" if nombre_de_encuesta=="SISTEMA DE COMERCIO SECCION VENTAS" | nombre_de_encuesta=="SISTEMA DE COMERCIO SECCION INVENTARIOS"
replace SIGLA_ENCUESTA="IPMAN" if nombre_de_encuesta=="SISTEMA DE MANUFACTURA"

replace SIGLA_ENCUESTA="IPEGA" if nombre_de_encuesta=="SISTEMA DE EGA" 
replace SIGLA_ENCUESTA="ENAM" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE MINERÍA - AÑO 2016"
	replace nombre_de_encuesta="ENCUESTA NACIONAL ANUAL DE MINERÍA" if SIGLA_ENCUESTA=="ENAM"
replace SIGLA_ENCUESTA="Correos" if nombre_de_encuesta=="ENCUESTA MENSUAL DE CORREOS"
replace SIGLA_ENCUESTA="ILM" if nombre_de_encuesta=="INDUSTRIA LÁCTEA MENOR"

replace SIGLA_ENCUESTA="EAGUA" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS SANITARIAS AGUA POTABLE - AÑO 2016"
	replace nombre_de_encuesta="ENCUESTA ANUAL DE SERVICIOS SANITARIOS DE AGUA POTABLE" if SIGLA_ENCUESTA=="EAGUA"
replace SIGLA_ENCUESTA="EGAS" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS DE GAS - AÑO 2016"
	replace nombre_de_encuesta="ENCUESTA ANUAL DE GAS CONSOLIDADO EMPRESA" if SIGLA_ENCUESTA=="EGAS"
	
replace SIGLA_ENCUESTA="EGENER" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS GENERADORAS DE ELECTRICIDAD - AÑO 2016"
	replace nombre_de_encuesta="ENCUESTA NACIONAL ANUAL DE EMPRESAS GENERADORAS DE ELECTRICIDAD" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS GENERADORAS DE ELECTRICIDAD - AÑO 2016"
replace SIGLA_ENCUESTA="ESGD" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS DE SERVICIOS DE GESTIÓN DE DESECHOS - AÑO 2016"
	replace nombre_de_encuesta="ENCUESTA ANUAL DE GESTIÓN DE DESECHOS" if SIGLA_ENCUESTA=="ESGD"
replace SIGLA_ENCUESTA="EEDES" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS DISTRIBUIDORAS DE ELECTRICIDAD - AÑO 2016"
	replace nombre_de_encuesta="ENCUESTA ANUAL DE DISTRIBUCIÓN DE ELECTRICIDAD" if SIGLA_ENCUESTA=="EEDES"
	
replace SIGLA_ENCUESTA="ETRANS" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS TRANSMISORAS DE ELECTRICIDAD - AÑO 2016"
	replace nombre_de_encuesta="ENCUESTA ANUAL DE TRANSMISIÓN DE ELECTRICIDAD" if SIGLA_ENCUESTA=="ETRANS"
replace SIGLA_ENCUESTA="IPMIN" if nombre_de_encuesta=="SISTEMA DE MINERÍA"
	replace nombre_de_encuesta="ENCUESTA DE CRIADEROS DE AVES" if SIGLA_ENCUESTA=="IPMIN"
replace SIGLA_ENCUESTA="ICT" if nombre_de_encuesta=="ICT LEVANTAMIENTO"|nombre_de_encuesta=="ICT REPUESTO" |nombre_de_encuesta=="ICT SERVICIO"
replace SIGLA_ENCUESTA="ECAVES" if nombre_de_encuesta=="CRIADEROS DE AVES"
	replace nombre_de_encuesta="ENCUESTA DE CRIADEROS DE AVES" if SIGLA_ENCUESTA=="ECAVES"
replace SIGLA_ENCUESTA="EMPP" if nombre_de_encuesta=="ENCUESTA MENSUAL DE PLAZAS DE PEAJE"
replace SIGLA_ENCUESTA="Telefonía" if nombre_de_encuesta=="ENCUESTA MENSUAL DE TELEFONIA"
replace SIGLA_ENCUESTA="ETRAN" if nombre_de_encuesta=="ENCUESTA TRANSPORTE URBANO DE PASAJEROS"
	replace nombre_de_encuesta="ENCUESTA ANUAL DE SERVICIOS DE TRANSPORTE_TRANSPORTE DE PASAJEROS" if SIGLA_ENCUESTA=="ETRAN"


merge m:m nombre_de_encuesta using "DiagnosticoEncuestas.dta", update
tab nombre_de_encuesta if _merge==1
drop if rut_emp==""

replace periodicidad="ANUAL" if SIGLA_ENCUESTA=="ENIA"|SIGLA_ENCUESTA=="EAGUA"|SIGLA_ENCUESTA=="EAR"|SIGLA_ENCUESTA=="ECOM"|SIGLA_ENCUESTA=="EDISTRIB"|SIGLA_ENCUESTA=="EGAS"|SIGLA_ENCUESTA=="EGENER"|SIGLA_ENCUESTA=="ESDG"|SIGLA_ENCUESTA=="ENAM"|SIGLA_ENCUESTA=="ETRAN"|SIGLA_ENCUESTA=="ETRANS"|SIGLA_ENCUESTA=="I+D"|SIGLA_ENCUESTA=="INNOVA"|SIGLA_ENCUESTA=="IR-ICMO"|SIGLA_ENCUESTA=="TIC"|SIGLA_ENCUESTA=="EEDES"|SIGLA_ENCUESTA=="ESGD"
replace periodicidad="MENSUAL" if SIGLA_ENCUESTA=="EFG"|SIGLA_ENCUESTA=="EMA"|SIGLA_ENCUESTA=="EMAT"|SIGLA_ENCUESTA=="EMG"|SIGLA_ENCUESTA=="EMPP"|SIGLA_ENCUESTA=="IAC"|SIGLA_ENCUESTA=="ICT"|SIGLA_ENCUESTA=="IICOM"|SIGLA_ENCUESTA=="IIMAN"|SIGLA_ENCUESTA=="Correos"|SIGLA_ENCUESTA=="IPEGA"|SIGLA_ENCUESTA=="IPMAN"|SIGLA_ENCUESTA=="IPMIN"|SIGLA_ENCUESTA=="IPP"|SIGLA_ENCUESTA=="ISUP"|SIGLA_ENCUESTA=="IVS"|SIGLA_ENCUESTA=="Telefonía"|SIGLA_ENCUESTA=="EMMT" /*|SIGLA_ENCUESTA=="IPP"*/
replace periodicidad="BIENAL" if SIGLA_ENCUESTA=="ELE"
replace periodicidad="SEMESTRAL" if SIGLA_ENCUESTA=="EEP"|SIGLA_ENCUESTA=="EIC"|SIGLA_ENCUESTA=="ECRIACER"|SIGLA_ENCUESTA=="ECAVES"
replace periodicidad="TRIMESTRAL" if SIGLA_ENCUESTA=="ILM"| SIGLA_ENCUESTA=="ETC"
*replace periodicidad="SEMANAL" if nombre_de_encuesta=="FORMULARIO DE PRECIOS PRODUCTOR IPP - AGRICULTURA" & timeskip==0 |nombre_de_encuesta=="FORMULARIO DE PRECIOS PRODUCTOR IPP - INDUSTRIA"&timeskip==0

replace AREA="REMUNERACIONES" if SIGLA_ENCUESTA=="IR-ICMO"
replace AREA="TRANSPORTE Y COMUNICACIONES" if SIGLA_ENCUESTA=="TIC"
replace AREA="TRANSPORTE Y COMUNICACIONES" if SIGLA_ENCUESTA=="ICT"
replace AREA="COMERCIO" if SIGLA_ENCUESTA=="ISUP"
replace AREA="COMERCIO" if SIGLA_ENCUESTA=="IICOM"
replace AREA="MANUFACTURA" if nombre_de_encuesta=="SISTEMA DE MANUFACTURA"
replace AREA="TRANSPORTE Y COMUNICACIONES" if nombre_de_encuesta=="ENCUESTA ANUAL DE RADIOS"
replace AREA="TRANSPORTE Y COMUNICACIONES" if nombre_de_encuesta=="ENCUESTA ANUAL DE RADIOS"
replace AREA="TRANSPORTE Y COMUNICACIONES" if nombre_de_encuesta=="ENCUESTA MENSUAL DE TELEFONIA"
replace AREA="ELECTRICIDAD, GAS Y AGUA" if nombre_de_encuesta=="SISTEMA DE EGA"| SIGLA_ENCUESTA=="ETRANS"|SIGLA_ENCUESTA=="EEDES"|SIGLA_ENCUESTA=="EGENER"| SIGLA_ENCUESTA=="EDISTRIB"
replace AREA="IPP" if SIGLA_ENCUESTA=="IPP"
replace AREA="SERVICIOS" if nombre_de_encuesta=="SISTEMA DE SERVICIOS"
replace AREA="AGROPECUARIAS" if nombre_de_encuesta=="CRIADEROS DE CERDOS"| nombre_de_encuesta=="ENCUESTA MATADERO DE GANADO"| nombre_de_encuesta=="ENCUESTA MATADEROS DE AVES"| nombre_de_encuesta=="ENCUESTA MENSUAL MOLIENDA DE TRIGO"| nombre_de_encuesta=="INDUSTRIA LÁCTEA MENOR"| SIGLA_ENCUESTA=="EIC"
replace AREA="CONSTRUCCIÓN" if nombre_de_encuesta=="ENCUESTA TRIMESTRAL DE LA CONSTRUCCIÓN"

drop if nombre_de_encuesta=="ENCUESTA DE ESPECTACULOS PÚBLICOS"
tab SIGLA_ENCUESTA if AREA==""
 tab periodicidad, gen(periodicidad_)
 
 

foreach i of num 10/18{
replace periodo_referencia = 20`i' if periodo_referencia==`i'
}
foreach i of num 0/9{
replace periodo_referencia = 200`i' if periodo_referencia==`i'
}





*para poder saber cuales observaciones se repiten, las comparamos por todos sus valores y si estan repetidas al no considerar la diferencia de bases pero si al hacerlo, esa diferencia vale la pena de eliminar
duplicates t ano_lev nom_unidad_estadistica unidad_estadistica rut_emp nombre_de_encuesta comuna_unidad_estadistica razonsocial_emp, gen(dup1)
duplicates t ano_lev nom_unidad_estadistica unidad_estadistica rut_emp nombre_de_encuesta comuna_unidad_estadistica razonsocial_emp timeskip, gen(dup2)


gen dupp=dup1-dup2
tab dupp
*en teoria la version de timeskip==0 tiene menos variables
drop if dupp==1 & timeskip==0
drop dup1 dup2 dupp
*foreach i of num 1/6{
*mean nruts if periodicidad_`i'==1

*}

tab periodo_referencia
*drop nruts
*drop ncusetas
by rut_emp, sort: gen nruts = _n if SIGLA_ENCUESTA!=""
by rut_emp, sort: egen ncuestas = max(nruts) 
*replace nruts= sum(nruts)
*replace nruts= nruts[_N]
tab ncuestas periodicidad
mean nruts
preserve
collapse ncuestas, by(rut_emp)
mean ncuestas
restore

save "directorioUnido.dta", replace
