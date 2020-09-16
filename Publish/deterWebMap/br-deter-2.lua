-- TODO:
-- 150km resolucao
-- atributo agregado para colorir mapa
-- atributos para grafico
-- fazer grafico aparecer
-- pegar os nomes dos municipios que tem intersecao com a celula

import("publish")

Application{
	project = "amaz_final.tview",
	base = "roadmap",
	title	= "DETER acumulado",
	description = "Esta aplicação mostra os dados do DETER acumulados para o ano de 2020, em uma resolução de 150x150km.",
	output	= "deterWebMap",

	deter = View{
        value = {"low", "medium", "high"},
        color = {"blue", "yellow", "red"},
		select  = "status",
		time = "snapshot",
		description = "DETER acumulado 2020",
	},
}
