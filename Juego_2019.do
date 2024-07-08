clear all
set more off
capture log 
set matsize 800

*Definimos directorios: asignamos un nombre
global DTA "D:\SIE\Datos_SIE"
global LOG "D:\SIE\LOG"
global OUT "D:\SIE\OUTPUT"
global GRA "D:\SIE\GRAPH"

cd "$DTA"
import excel "$DTA\Encuestas respondidas/2019_1", sheet("Consulta") firstrow clear
gen fecha_levantamiento = mdy(MES, DIA, AÑO)
format fecha_levantamiento fecha* %tddd/nn/CCYY
egen respuestas = group(rut_emp rol nombre_de_encuesta comuna_unidad_estadistica vig_lev_fecha_inicio)
bys respuestas : egen maxima_fecha = max(fecha_actualizacion)
drop if maxima_fecha!=fecha_actualizacion
duplicates drop respuestas, force

drop respuestas maxima_fecha
save "$DTA/Encuestas respondidas/2019_1.dta", replace

import excel "$DTA\Directorio_bianca", sheet("hoja") firstrow clear
tostring SIGLA_ENCUESTA, replace
tab nombre_de_encuesta if SIGLA_ENCUESTA==""
replace SIGLA_ENCUESTA="EMT" if nombre_de_encuesta=="ENCUESTA MENSUAL MOLIENDA DE TRIGO"
replace SIGLA_ENCUESTA="ETC" if nombre_de_encuesta=="ENCUESTA TRIMESTRAL DE LA CONSTRUCCIÓN"

replace estado_no_exigible="FUERA DE MARCO" if estado_no_exigible=="FUERA DE MARCO"|estado_no_exigible=="FUERA MARCO"
replace estado_no_exigible="FUERA DE AMBITO" if estado_no_exigible=="FUERA AMBITO"|estado_no_exigible=="FUERA DE AMBITO"|estado_no_exigible=="FUERA DE ÁMBITO"
replace estado_no_exigible="FIN O CAMBIO DE GIRO" if estado_no_exigible=="CAMBIO DE GIRO"|estado_no_exigible=="TERMINO DE GIRO"|estado_no_exigible=="TÉRMINO DE GIRO"
replace estado_no_exigible="CIERRE" if estado_no_exigible=="QUEBRADA"| estado_no_exigible=="CIERRE DE PLANTA"
save "$DTA\Directorio_bianca.dta", replace
*use "$DTA/Encuestas respondidas/2019_1.dta", clear
*merge 1:1 fecha_levantamiento nombre_de_encuesta vig_lev_fecha_inicio rut_emp using "$DTA\Directorio_bianca", gen(repet)
*replace fecha_levantamiento = date(fecha_levantamiento, "DMY")
use "Directorio_bianca.dta", clear
drop if unidad_estadistica=="ESTABLECIMIENTO MINERO"|unidad_estadistica=="ESTABLECIMIENTO MANUFACTURERO"|unidad_estadistica=="ESTABLECIMIENTO"| unidad_estadistica=="EXPLOTACION AGROPECUARIA"
save "Directorio_bianca_empresas.dta", replace

use "Directorio_bianca.dta", clear
keep if unidad_estadistica=="ESTABLECIMIENTO MINERO"|unidad_estadistica=="ESTABLECIMIENTO MANUFACTURERO"|unidad_estadistica=="ESTABLECIMIENTO"| unidad_estadistica=="EXPLOTACION AGROPECUARIA"
save "Directorio_bianca_establecimientos.dta", replace

