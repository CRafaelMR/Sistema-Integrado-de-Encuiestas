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

do "C:\Users\cmenesesr\Desktop\SIE\depuracion_directorio.do" 
cd "$DTA\Encuestas respondidas/"


foreach formato in establecimientos empresas{
local i = 2015
foreach BASE in 2015_1 2016_unido 2017_1 2018_unido {



use `BASE'_`formato'_resumido.dta, clear
ds, not(type string)
egen Totalgeneral=rowtotal(`r(varlist)')
rename Totalgeneral total_general
drop if rut_emp =="Total general"
tab total_general /*total_general if rut_emp != "Total general"*/
hist total_general if total_general<=50, discrete ti(`BASE'_`formato') title("Encustas por año a `formato' en año `i'") xlabel(0(5)50) ytitle("Proporción") xtitle("Respuestas por rut") saving("$GRA/histograma_respuestas_`BASE'_`formato'.gph", replace)
graph export "$GRA/histograma_respuestas_`BASE'_`formato'.pdf" , as(pdf) replace
drop total_general 



/*
if `formato'= "establecimientos"{
label var CRIADEROSDEAVES "ECA"
label var CRIADEROSDECERDOS "ECD"
label var EGACOYUNTURAL "EGA"
label var ENCUESTADEESPECTACULOSPÚBLICO "EPP"
label var ENCUESTADEFERIASDEGANADO  "EFG"
label var ENCUESTAMATADERODEGANADO "EMG"
label var ENCUESTAMATADEROSDEAVES "EMA"
label var ENCUESTAMENSUALDEALOJAMIENTO "EMAloj" 
label var ENCUESTAMENSUALDECORREOS "EMC"
label var ENCUESTAMENSUALDEPLAZASDEPE "peajes"
label var ENCUESTAMENSUALMOLIENDADETRI "EMMT"
label var ENCUESTANACIONALANUALDEMINER "ENAM"
label var ENCUESTANACIONALDELAINDUSTRI "ENAI"
label var ÍNDICEDEVENTASDESUPERMERCADO "ISUP"
label var MANUFACTURACOYUNTURAL "ManufCuy"
label var MINERÍACONYUNTURAL "MineCuy"}
else{
display(5)
}
*/

ds, not( type string)
foreach encuesta of var `r(varlist)'{
replace `encuesta'=0 if `encuesta'==.
tab `encuesta'

}
*correlate _all, wrap
*ds, not( type string)
*pwcorr  `r(varlist)' , star(.01)
*ds, not( type string)
*graph matrix  `r(varlist)', half
pwcorr `r(varlist)', star(.01)
*preserve
matrix dissimilarity clubD = , variables Jaccard dissim(oneminus)
clustermat wardslinkage clubD, name(clubwav) clear labelvar(Sigla_encuesta)
cluster dendrogram clubwav, labels(Sigla_encuesta) xlabel(, angle(90) labsize(*.75)) title("Encustas a `formato' en año `i'") ytitle("Similitud")
graph export "$GRA\Arbol_`BASE'_`formato'.pdf" , as(pdf) replace
cluster generate cluster = group(1/10),  ties(more)
save "datos_cluster_crudos_`BASE'_`formato'.dta" ,replace
*restore
local i = `i'+1
}
graph combine "$GRA/histograma_respuestas_2015_1_`formato'.gph" "$GRA/histograma_respuestas_2016_unido_`formato'.gph" "$GRA/histograma_respuestas_2017_1_`formato'.gph" "$GRA/histograma_respuestas_2018_unido_`formato'.gph", xcom r(2) altshrink saving(Histograma_Empresas, replace)
graph export "$GRA/histograma_respuestas_`BASE'_`formato'.pdf" , as(pdf) replace

}


foreach formato in establecimientos empresas{
local i = 2015
foreach BASE in 2015_1 2016_unido 2017_1 2018_unido {
dis `i'
use `BASE'_`formato'_resumido.dta, clear
ds, not(type string)
egen Totalgeneral=rowtotal(`r(varlist)')
rename Totalgeneral total_general
tab rut_emp if total_general==0
drop if rut_emp =="Total general"
tab total_general
*tab total_general if total_general>=10
*tab rut_emp if total_general>=5

local i = `i'+1
}
}



foreach formato in establecimientos empresas{
use "2015_1_`formato'.dta",clear
local i = 2015
foreach BASE in 2016_unido 2017_1 2018_unido {
local i = `i'+1
append using "`BASE'_`formato'.dta", force
}
save `formato'_unido.dta, replace
export excel using "$DTA\Encuestas respondidas/`formato'_unido.xlsx", replace firstrow(variables) 

*export excel using "$DTA\Encuestas respondidas/grupos_`formato'.xls", replace firstrow(variables) 

}


foreach formato in establecimientos empresas{
use "`formato'_unido.dta", clear
gen placeholder=1
collapse (sum) cell = placeholder, by(rut_emp SIGLA_ENCUESTA )
replace SIGLA_ENCUESTA="ImasD" if SIGLA_ENCUESTA=="I+D"
replace SIGLA_ENCUESTA="IRICMO" if SIGLA_ENCUESTA=="IR-ICMO"
reshape wide cell, i(rut_emp) j(SIGLA_ENCUESTA) string
egen total_general= rowtotal(cell*)
rename cell* *
ds, not( type string)

save "`formato'_unido_resumido.dta" , replace


tab total_general/*total_general if rut_emp != "Total general"*/
hist total_general if total_general<=50, discrete ti( "Encuestas respondidas por rut por `formato'") xtitle("Cantidad") ytitle("proporción") xlabel(0(5)50)/*saving("$GRA/histograma_respuestas_`BASE'_`formato'.pdf", replace asis ) */
graph export "$GRA/histograma_respuestas_`formato'.pdf" , as(pdf) replace


drop total_general

ds, not( type string)
foreach encuesta of var `r(varlist)'{
replace `encuesta'=0 if `encuesta'==.
tab `encuesta'

}
matrix dissimilarity clubD = , variables Jaccard dissim(oneminus)
display "Matriz"
clustermat wardslinkage clubD, name(clubwav) clear labelvar(Sigla_encuesta)
display "cluster"
cluster dendrogram clubwav, labels(Sigla_encuesta) xlabel(, angle(90) labsize(*.75)) title("Encustas a `formato' entre 2015 y 2018") ytitle("nivel de similitud")
graph export "$GRA\Arbol_unido_`formato'.pdf" , as(pdf) replace
cluster generate cluster = group(1/10),  ties(more)
save "datos_cluster_crudos_unido_`formato'.dta" ,replace
}


local i = 2014
foreach BASE in 2015_1 2016_unido 2017_1 2018_unido unido{
local i =`i' +1 
foreach formato in establecimientos empresas{
use "datos_cluster_crudos_`BASE'_`formato'.dta", clear
keep Sigla_encuesta cluster6
if `i'<=2018{
rename cluster6 grupo_`i'
	}
else{
rename cluster6 agregados
			}
save "datos_cluster_filtrados_`BASE'_`formato'.dta", replace
}
}



foreach formato in establecimientos empresas{
use "datos_cluster_2015_1_`formato'.dta",clear
local i = 2015
foreach BASE in 2016_unido 2017_1 2018_unido unido{
local i = `i'+1
merge 1:1 Sigla_encuesta using "datos_cluster_filtrados_`BASE'_`formato'.dta", gen(relevancia`i')

erase "datos_cluster_filtrados_`BASE'_`formato'.dta"
}
save grupos_`formato'.dta, replace
export excel using "$DTA\Encuestas respondidas/grupos_`formato'.xlsx", replace firstrow(variables) 

}
use grupos_empresas.dta, clear
*waverage

foreach formato in establecimientos empresas{
use `formato'_unido.dta, clear
egen rut = group(rut_emp)

table AÑO  ,content(n rut )  concise

table AÑO  ,by(periodicidad) content(n rut )  concise

table nombre_de_encuesta AÑO ,by(periodicidad) content(n rut )  concise
table SIGLA_ENCUESTA AÑO ,by(periodicidad) content(n rut )  concise

}


use empresas_unido_resumido.dta, clear
drop if total_general<=4
ds, not( type string)
foreach encuesta of var `r(varlist)'{
replace `encuesta'=0 if `encuesta'==.
tab `encuesta'
}

use empresas_unido.dta, clear
*bys rut_emp: gen comunass= group( rut_emp, comuna_unidad_estadistica)
bysort rut_emp AÑO nombre_de_encuesta ciiu_rev4: gen comunass=_N
*bysort rut_emp nombre_de_encuesta: egen sucursales=max(comunass) 


import excel "C:\Users\cmenesesr\Desktop\20191118_Matriz_Encuestas_Económicas.xlsx", sheet("Matriz_Encuestas_Económicas") cellrange(A2:AF65) firstrow clear
rename SIGLA SIGLA_ENCUESTA
save "$DTA/catastro.dta", replace

use 2018_unido.dta, clear
merge m:1 SIGLA_ENCUESTA using "$DTA/catastro.dta"
/*
matrix dissimilarity clubD = , variables Jaccard dissim(oneminus)
clustermat waverage clubD, name(clubwav) clear labelvar(question)
cluster dendrogram clubwav, labels(question) xlabel(, angle(90) labsize(*.75)) title(Weighted-average linkage clustering) ytitle(1 - Jaccard similarity, suffix)
