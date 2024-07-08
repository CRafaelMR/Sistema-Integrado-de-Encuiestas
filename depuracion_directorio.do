clear all
set more off
capture log 
set matsize 800
set excelxlsxlargefile on

*Definimos directorios: asignamos un nombre
global DTA "C:\Users\cmenesesr\Desktop\SIE\Datos_SIE"
global LOG "C:\Users\cmenesesr\Desktop\SIE\LOG"
global OUT "C:\Users\cmenesesr\Desktop\SIE\OUTPUT"
global GRA "C:\Users\cmenesesr\Desktop\SIE\GRAPH"


cd "$DTA\Encuestas respondidas/"
foreach EXCEL in 2015_1 2016_1 2016_2 2016_3 2017_1 2018_1 2018_2 2018_3{
import excel "$DTA\Encuestas respondidas/`EXCEL'", sheet("Consulta") firstrow clear
scalar define N_1_`EXCEL' = _N
*eliminamos respuestas de encuestas que fueron reescritas luego o que fueron accidentlamente enviadas a ruts no aplicables

*drop dup1
*duplicates t rut_emp rol ciiu_rev3 ciiu_rev4 nombre_de_encuesta comuna_unidad_estadistica, gen(dup1)
*gen CODIGO = rut_emp*dup1
*drop dup2
*gsort CODIGO -fecha_actualizacion, g(dup2)
*gen IND = _n
*gsort rut_emp rol comuna_unidad_estadistica -fecha_actualizacion, g(dup2)
destring comuna_unidad_estadistica, replace

replace comuna_unidad_estadistica = 0 if comuna_unidad_estadistica ==.

*drop respuestas



tostring rut_emp, replace
sum DIA if estado_gestion== "NO EXIGIBLE"
scalar define no_exigibles_`EXCEL' = r(N)
scalar define prop_no_exigibles_`EXCEL' = no_exigibles_`EXCEL'/N_1_`EXCEL' 
*drop if estado_gestion== "NO EXIGIBLE"
replace estado_gestion ="EXIGIBLE" if estado_gestion =="EXIJIBLE"
scalar define N_2_`EXCEL' = _N
*porcentaje de base que se pierde
display (N_1_`EXCEL'-N_2_`EXCEL')/N_1_`EXCEL' 
*generacion de abreviacion
gen SIGLA_ENCUESTA = .
tostring SIGLA_ENCUESTA, replace
foreach year in "2014" "2015" "2016" "2017" "2018"{
display `year'
replace periodicidad= "MENSUAL" if periodicidad=="ABRIL"|periodicidad=="DICIEMBRE"|periodicidad=="NOVIEMBRE" 
replace SIGLA_ENCUESTA = "EMT" if nombre_de_encuesta=="ENCUESTA MENSUAL MOLIENDA DE TRIGO"
replace SIGLA_ENCUESTA = "ETC" if nombre_de_encuesta=="ENCUESTA TRIMESTRAL DE LA CONSTRUCCIÓN"
 replace SIGLA_ENCUESTA = "EMG" if nombre_de_encuesta== "ENCUESTA MATADERO DE GANADO"
 replace SIGLA_ENCUESTA = "EMA" if nombre_de_encuesta== "ENCUESTA MATADERO DE AVES"
replace SIGLA_ENCUESTA = "ETC" if nombre_de_encuesta== "ENCUESTA TRIMESTRAL DE LA CONSTRUCCIÓN"
replace SIGLA_ENCUESTA = "I+D" if nombre_de_encuesta== "ENCUESTA SOBRE GASTO Y PERSONAL EN INVESTIGACIÓN Y DESARROLLO (I+D) - AÑO `year'"
	replace nombre_de_encuesta= " ENCUESTA SOBRE GASTO Y PERSONAL EN INVESTIGACIÓN Y DESARROLLO" if SIGLA_ENCUESTA== "I+D"
replace SIGLA_ENCUESTA="ELE" if nombre_de_encuesta=="ENCUESTA LONGITUDINAL A EMPRESAS" |nombre_de_encuesta== "ENCUESTA LONGITUDINAL DE EMPRESAS"
	replace nombre_de_encuesta="ENCUESTA LONGITUDINAL DE EMPRESAS" if SIGLA_ENCUESTA=="ELE"
replace SIGLA_ENCUESTA="ER" if nombre_de_encuesta=="ENCUESTA ANUAL DE RADIOS"
replace SIGLA_ENCUESTA="EPP" if nombre_de_encuesta=="ENCUESTA DE ESPECTACULOS PÚBLICOS"
replace SIGLA_ENCUESTA="ETRAN" if nombre_de_encuesta=="ENCUESTA DE SERVICIOS DE TRANSPORTE DE CARGA" |nombre_de_encuesta=="ENCUESTA DE SERVICIOS DE TRANSPORTE DE PASAJEROS" 
replace SIGLA_ENCUESTA="IR-ICMO" if nombre_de_encuesta=="ENCUESTA ESTRUCTURAL DE REMUNERACIONES Y COSTO DE LA MANO DE OBRA Y EMPLEO"


replace nombre_de_encuesta ="ENCUESTA DE INNOVACIÓN EN EMPRESAS" if nombre_de_encuesta=="10A ENCUESTA DE INNOVACIÓN EN EMPRESAS"
replace nombre_de_encuesta ="ENCUESTA DE INNOVACIÓN EN EMPRESAS" if nombre_de_encuesta=="NOVENA ENCUESTA DE INNOVACIÓN A EMPRESAS"
*replace nombre_de_encuesta="" if SIGLA_ENCUESTA=="IR-ICMO"
replace SIGLA_ENCUESTA = "INNOVA" if nombre_de_encuesta=="ENCUESTA DE INNOVACIÓN EN EMPRESAS"

replace SIGLA_ENCUESTA="TIC" if nombre_de_encuesta=="ENCUESTA TIC A EMPRESAS `year'" 
	replace nombre_de_encuesta="ENCUESTA TIC A EMPRESAS" if nombre_de_encuesta=="ENCUESTA TIC A EMPRESAS `year'"

replace SIGLA_ENCUESTA="ISUP" if nombre_de_encuesta=="SISTEMA DE SUPERMERCADOS SECCION INVENTARIOS" | nombre_de_encuesta=="SISTEMA DE SUPERMERCADOS SECCION VENTAS"


replace SIGLA_ENCUESTA="ENIA" if nombre_de_encuesta=="ENCUESTA NACIONAL DE LA INDUSTRIA MANUFACTURERA - AÑO `year'"
	replace nombre_de_encuesta="ENCUESTA NACIONAL DE INDUSTRIA ANUAL" if SIGLA_ENCUESTA=="ENIA"
 
replace SIGLA_ENCUESTA="ECOM" if nombre_de_encuesta=="ENCUESTAS ANUALES DE COMERCIO, SERVICIO Y TURISMO"
	replace nombre_de_encuesta="ENCUESTA ESTRUCTURAL DE COMERCIO" if SIGLA_ENCUESTA=="ECOM"

replace SIGLA_ENCUESTA="EMAT" if nombre_de_encuesta=="ENCUESTA MENSUAL DE ALOJAMIENTO TURÍSTICO"
replace SIGLA_ENCUESTA="IICOM" if nombre_de_encuesta=="SISTEMA DE COMERCIO SECCION VENTAS" | nombre_de_encuesta=="SISTEMA DE COMERCIO SECCION INVENTARIOS"
replace SIGLA_ENCUESTA="IPMAN" if nombre_de_encuesta=="SISTEMA DE MANUFACTURA"

replace SIGLA_ENCUESTA="IPEGA" if nombre_de_encuesta=="SISTEMA DE EGA" 
replace SIGLA_ENCUESTA="ENAM" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE MINERÍA - AÑO `year'"
	replace nombre_de_encuesta="ENCUESTA NACIONAL ANUAL DE MINERÍA" if SIGLA_ENCUESTA=="ENAM"
replace SIGLA_ENCUESTA="EMC" if nombre_de_encuesta=="ENCUESTA MENSUAL DE CORREOS"
replace SIGLA_ENCUESTA="EILM" if nombre_de_encuesta=="INDUSTRIA LÁCTEA MENOR"

replace SIGLA_ENCUESTA="ENAES" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS SANITARIAS AGUA POTABLE - AÑO `year'"
	replace nombre_de_encuesta="ENCUESTA ANUAL DE SERVICIOS SANITARIOS DE AGUA POTABLE" if SIGLA_ENCUESTA=="ENAES"
replace SIGLA_ENCUESTA="ENADG" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS DE GAS - AÑO `year'"
	replace nombre_de_encuesta="ENCUESTA ANUAL DE GAS CONSOLIDADO EMPRESA" if SIGLA_ENCUESTA=="ENADG"
	
replace SIGLA_ENCUESTA="ENADE" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS GENERADORAS DE ELECTRICIDAD - AÑO `year'"
	replace nombre_de_encuesta="ENCUESTA NACIONAL ANUAL DE EMPRESAS GENERADORAS DE ELECTRICIDAD" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS GENERADORAS DE ELECTRICIDAD - AÑO `year'"
replace SIGLA_ENCUESTA="ENAER" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS DE SERVICIOS DE GESTIÓN DE DESECHOS - AÑO `year'"
	replace nombre_de_encuesta="ENCUESTA ANUAL DE GESTIÓN DE DESECHOS" if SIGLA_ENCUESTA=="ENAER"
replace SIGLA_ENCUESTA="ENADD" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS DISTRIBUIDORAS DE ELECTRICIDAD - AÑO `year'"
	replace nombre_de_encuesta="ENCUESTA ANUAL DE DISTRIBUCIÓN DE ELECTRICIDAD" if SIGLA_ENCUESTA=="ENADD"
	
	
	
replace SIGLA_ENCUESTA="ENADT" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS TRANSMISORAS DE ELECTRICIDAD - AÑO `year'"
	replace nombre_de_encuesta="ENCUESTA ANUAL DE TRANSMISIÓN DE ELECTRICIDAD" if SIGLA_ENCUESTA=="ENADT"
replace SIGLA_ENCUESTA="IIMCU" if nombre_de_encuesta=="SISTEMA DE MINERÍA"
	replace nombre_de_encuesta="Encuesta Mensual de Inventarios de la Minería del Cobre" if SIGLA_ENCUESTA=="IIMCU"

	replace SIGLA_ENCUESTA="ICT" if nombre_de_encuesta=="ICT LEVANTAMIENTO"|nombre_de_encuesta=="ICT REPUESTO" |nombre_de_encuesta=="ICT SERVICIO"
replace SIGLA_ENCUESTA="ECA" if nombre_de_encuesta=="CRIADEROS DE AVES"
	replace nombre_de_encuesta="ENCUESTA DE CRIADEROS DE AVES" if SIGLA_ENCUESTA=="ECA"
replace SIGLA_ENCUESTA="EMPP" if nombre_de_encuesta=="ENCUESTA MENSUAL DE PLAZAS DE PEAJE"
replace SIGLA_ENCUESTA="EMT" if nombre_de_encuesta=="ENCUESTA MENSUAL DE TELEFONIA"
replace SIGLA_ENCUESTA="ETRAN" if nombre_de_encuesta=="ENCUESTA TRANSPORTE URBANO DE PASAJEROS"
	replace nombre_de_encuesta="ENCUESTA ANUAL DE SERVICIOS DE TRANSPORTE_TRANSPORTE DE PASAJEROS" if SIGLA_ENCUESTA=="ETRAN"
*replace SIGLA_ENCUESTA= "" if nombre_de_encuesta==""
replace SIGLA_ENCUESTA= "ECC" if nombre_de_encuesta=="CRIADEROS DE CERDOS"
replace SIGLA_ENCUESTA= "IPEGA" if nombre_de_encuesta=="EGA COYUNTURAL"
replace SIGLA_ENCUESTA= "INNOVA" if nombre_de_encuesta=="NOVENA ENCUESTA DE INNOVACIÓN A EMPRESAS"
replace SIGLA_ENCUESTA= "INNOVA" if nombre_de_encuesta=="DÉCIMA ENCUESTA DE INNOVACIÓN A EMPRESAS"
replace SIGLA_ENCUESTA= "INNOVA" if nombre_de_encuesta=="10A ENCUESTA DE INNOVACIÓN EN EMPRESAS"
replace SIGLA_ENCUESTA= "ISUP" if nombre_de_encuesta=="ÍNDICE DE VENTAS DE SUPERMERCADOS"
replace SIGLA_ENCUESTA= "IVS" if nombre_de_encuesta=="ÍNDICE DE VENTAS SECTORES DE SERVICIOS"

replace SIGLA_ENCUESTA= "IIMAN" if nombre_de_encuesta=="MANUFACTURA COYUNTURAL"
replace SIGLA_ENCUESTA= "IPMIN" if nombre_de_encuesta=="MINERÍA CONYUNTURAL"
replace SIGLA_ENCUESTA= "EFG" if nombre_de_encuesta=="ENCUESTA DE FERIAS DE GANADO"
replace SIGLA_ENCUESTA= "EMA" if nombre_de_encuesta=="ENCUESTA MATADEROS DE AVES"
replace SIGLA_ENCUESTA= "EIC" if nombre_de_encuesta=="INDUSTRIA DE CECINAS"
replace SIGLA_ENCUESTA= "ETRAN" if nombre_de_encuesta=="ENCUESTA ANUAL DE SERVICIO DE TRANSPORTE PASAJEROS"
replace SIGLA_ENCUESTA= "ETRAN" if nombre_de_encuesta=="ENCUESTA ANUAL DE SERVICIO TRANSPORTE CARGA"
replace SIGLA_ENCUESTA= "IAC" if nombre_de_encuesta=="ÍNDICE DE VENTAS DE COMERCIO AL POR MENOR"
	replace nombre_de_encuesta="Encuesta Mensual de Comercio" if nombre_de_encuesta=="ÍNDICE DE VENTAS DE COMERCIO AL POR MENOR"
replace SIGLA_ENCUESTA= "ESERV" if nombre_de_encuesta=="SISTEMA DE SERVICIOS"
replace SIGLA_ENCUESTA= "IIMAN" if nombre_de_encuesta=="SISTEMA DE MANUFACTURA SECCION INVENTARIOS"
replace SIGLA_ENCUESTA= "IPMAN" if nombre_de_encuesta=="SISTEMA DE MANUFACTURA SECCION VENTAS EMPRESA"
replace SIGLA_ENCUESTA= "IPMAN" if nombre_de_encuesta=="SISTEMA DE MANUFACTURA SECCION PRODUCCIÓN FÍSICA"
replace SIGLA_ENCUESTA= "IPMAN" if nombre_de_encuesta=="SISTEMA DE MANUFACTURA SECCION VENTAS ESTABLECIMIENTO"
replace SIGLA_ENCUESTA= "IPP" if nombre_de_encuesta=="FORMULARIO DE EMPADRONAMIENTO Y LEVANTAMIENTO DE PRECIOS PRODUCTOR IPP NACIONAL Y EXPORTACIÓN - INDUSTRIA MANUFACTURERA"
replace SIGLA_ENCUESTA= "ENADT" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS DISTRIBUIDORAS DE ELECTRICIDAD - AÑO 2017"
replace SIGLA_ENCUESTA= "ENADG" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS DE GAS - AÑO 2017"
replace SIGLA_ENCUESTA= "ENIA" if nombre_de_encuesta=="ENCUESTA NACIONAL INDUSTRIAL ANUAL - AÑO 2017"
replace SIGLA_ENCUESTA= "ENAER" if nombre_de_encuesta=="ENCUESTA NACIONAL ANUAL DE EMPRESAS DE SERVICIOS DE GESTIÓN DE RESIDUOS - AÑO 2017"
*FORMULARIO DE EMPADRONAMIENTO Y LEVANTAMIENTO DE PRECIOS PRODUCTOR IPP NACIONAL Y EXPORTACIÓN - INDUSTRIA MANUFACTURERA
replace periodicidad="BIENAL" if SIGLA_ENCUESTA=="INNOVA"

}

egen respuestas = group(rut_emp rol nombre_de_encuesta comuna_unidad_estadistica vig_lev_fecha_inicio)
bys respuestas : egen maxima_fecha = max(fecha_actualizacion)
bys respuestas : egen minima_fecha = min(fecha_actualizacion)
gen tiempo_tomado = maxima_fecha-minima_fecha
format maxima_fecha %tdnn/dd/CCYY
drop if maxima_fecha != fecha_actualizacion
duplicates drop respuestas, force
tab nombre_de_encuesta if SIGLA_ENCUESTA == "."


drop if estado_gestion!="EXIGIBLE"
drop respuestas maxima_fecha
save "`EXCEL'.dta", replace
*export excel using "$DTA\Encuestas respondidas/`EXCEL'_modificado.xls", firstrow(variables) replace
}
display N_2_2015_1+ N_2_2016_1+ N_2_2016_2 +N_2_2016_3 +N_2_2017_1 +N_2_2018_1+ N_2_2018_2 +N_2_2018_3

use "2016_1.dta", clear
append using "2016_2.dta", force
destring region_gerencia, replace
destring provincia_gerencia, replace
destring comuna_gerencia, replace
append using "2016_3.dta", force
save "2016_unido.dta", replace
*export excel using "$DTA\Encuestas respondidas/2016_unida.xls", firstrow(variables) replace

use "2018_1.dta", clear
append using "2018_2.dta", force
destring region_gerencia, replace
destring provincia_gerencia, replace
destring comuna_gerencia, replace
destring ciiu_rev3, replace
append using "2018_3.dta", force
save "2018_unido.dta", replace
export excel using "$DTA\Encuestas respondidas/2018_unida.xls", firstrow(variables) replace


*Separacion de la base de datos entre establecimientos y organizaciones(Empresas, municipalidades, organizaciones sin fines de lucro, etc). La separacion es por unidad estadistica y no por encuesta.
foreach BASE in 2015_1 2016_unido 2017_1 2018_unido{
use "`BASE'.dta", clear
drop if unidad_estadistica=="ESTABLECIMIENTO MINERO"|unidad_estadistica=="ESTABLECIMIENTO MANUFACTURERO"|unidad_estadistica=="ESTABLECIMIENTO"| unidad_estadistica=="EXPLOTACION AGROPECUARIA"
egen respuestas = group(rut_emp rol nombre_de_encuesta vig_lev_fecha_inicio)
bys respuestas : egen maxima_fecha = max(fecha_actualizacion)
format maxima_fecha %tdnn/dd/CCYY
drop if maxima_fecha != fecha_actualizacion
duplicates drop respuestas, force
drop maxima_fecha respuestas
drop tipo_recepcion analista analista_fono analista_email DIA MES 
save "`BASE'_empresas.dta", replace
*export excel using "$DTA\Encuestas respondidas/`BASE'_empresas.xls", firstrow(variables) replace

}
foreach BASE in 2015_1 2016_unido 2017_1 2018_unido 2019_1{
use "`BASE'.dta", clear
keep if unidad_estadistica=="ESTABLECIMIENTO MINERO"|unidad_estadistica=="ESTABLECIMIENTO MANUFACTURERO"|unidad_estadistica=="ESTABLECIMIENTO"| unidad_estadistica=="EXPLOTACION AGROPECUARIA"
drop tipo_recepcion analista analista_fono analista_email DIA MES 
save "`BASE'_establecimientos.dta", replace
*export excel using "$DTA\Encuestas respondidas/`BASE'_establecimientos.xls", replace firstrow(variables) 

}

foreach EXCEL in 2015_1 2016_unido 2017_1 2018_unido{
foreach formato in establecimientos empresas{
use "`EXCEL'_`formato'.dta", clear
gen placeholder=1
*replace SIGLA_ENCUESTA="ImasD" if nombre_de_encuesta=="ENCUESTA SOBRE GASTO Y PERSONAL EN INVESTIGACIÓN Y DESARROLLO"
collapse (sum) cell = placeholder, by(rut_emp SIGLA_ENCUESTA )
replace SIGLA_ENCUESTA="ImasD" if SIGLA_ENCUESTA=="I+D"
replace SIGLA_ENCUESTA="IRICMO" if SIGLA_ENCUESTA=="IR-ICMO"
reshape wide cell, i(rut_emp) j(SIGLA_ENCUESTA) string
rename cell* *
*ds, not( type string)
*foreach encuesta of var `r(varlist)'{
*replace `encuesta'=0 if `encuesta'>=500
*}
save "`EXCEL'_`formato'_resumido.dta" , replace
}
}
*importamos la version expandida de tabla dinamica de excel.
*se podria empezar a afinar a partir de el sigte comando

/*
 use 2015_1_empresas, replace
gen cuenta =1
collapse (count) cuenta, by(SIGLA_ENCUESTA rut_emp) 
encode SIGLA_ENCUESTA, gen(codgigo_encuesta) label(nombresitos)
tab SIGLA_ENCUESTA, gen(encuesta_)
 
scalar define lista = r(r)
foreach var of var encuesta_1-encuesta_`r(r)'{
replace `var'=cuenta if `var'!=0
}
///
foreach v in  {
        local l`v' : variable label `v'
            if `"`l`v''"' == "" {
            local l`v' "`v'"
        }
}
///
 collapse (sum) encuesta_1-encuesta_`r(r)', by(rut_emp)
 ///
foreach v of var * {
        label var `v' "`l`v''"
}
///
egen total = rowtotal(_all)
matrow(nombres)
foreach EXCEL in 2015_1 2016_unido 2017_1 2018_unido{
foreach formato in establecimientos empresas{
import excel "$DTA\Encuestas respondidas/`EXCEL'_`formato'", sheet("resumen") firstrow clear

save `EXCEL'_`formato'_resumido.dta, replace
}
}
