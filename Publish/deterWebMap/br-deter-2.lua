-- TODO:
-- 150km resolucao
-- atributo agregado para colorir mapa
-- atributos para grafico
-- fazer grafico aparecer
-- pegar os nomes dos municipios que tem intersecao com a celula

import("publish")

Application{
 	key = "AIzaSyA1coAth-Bo7m99rnxOm2oOBB88AmaSbOk",
	project = "amaz_final.tview",
	base = "roadmap",
	title	= "DETER celular mensal",
	description = "Esta aplicação mostra os dados do DETER acumulados por mês em uma representação celular com resolução de 150x150km, para o ano de 2020.",
	output	= "deterWebMap",
    --[[
    aml = View{
		description = "Legal Amazon area. This area was initially established by "..link("http://www2.camara.leg.br/legin/fed/lei/1950-1959/lei-1806-6-janeiro-1953-367342-publicacaooriginal-1-pl.html", "Brazilian Law 1806")..". It covers all the states from the North region in Brazil, plus Mato Grosso and part of Maranhao. PRODES monitors deforestation within this area. It contains almost all Amazon biome, except by part of Maranhao state. The areas in Legal Amazon outside Amazon biome belong to Cerrado biome.",
		title = "Legal Amazon",
		color = "white",
		transparency = 1,
		visible = false
	},
    --]]
    --[[
    	bioma = View{
		description = "Brazilian Amazon biome. It covers approximately half the area of Brazil. The definition of Amazon biome is officially provided by "..link("https://ww2.ibge.gov.br/home/presidencia/noticias/21052004biomashtml.shtm", "IBGE")..".",
		title = "Amazon Biome",
		color = "green",
		transparency = 0.6,
		visible = false
	},
--]]
	deter = View{
        value = {"1muitobaixo", "2baixo", "3medio", "4alto", "5muitoalto"},
--        label = {"Muito Baixo", "Baixo", "Medio", "Alto", "Muito Alto"}, -- BUG: ele reordena a legenda alfabeticamente
        color = {"green", "greenyellow", "yellow", "orange", "red"},
		select  = "status",
		time = "snapshot",
        transparency = 0.2,
		description = "DETER mensal 2020",
	},
}
