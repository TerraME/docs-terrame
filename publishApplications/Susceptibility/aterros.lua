
import("gis")

project = Project{
	file = "aterros.tview",
	clean = true,
	aterros = "aterros_c.shp",
-- so de incluir o layer abaixo o Application para de funcionar!!
--	resultado = "Resultado_Modelo_SP.shp"
}

import("publish")

Application{
    project = "aterros.tview",
	base = "terrain",
	legend = "Legenda",
	layers = "Camadas",
    title = "Susceptibilidade de aterros sanitários",
    description = "Resultados da tese de doutorado entitulada 'Modeling environmental susceptibility of municipal solid waste disposal sites in regional scale'.",
    clean = true,
    output = "VictorWebMap",
    aterros = View{
		select = {"OBJECTID", "icon"},
		icon = {"home", "forest"},
        description = "Aterros",
		report = function(cell)
			local mreport = Report{
				title = cell.Municipio,
				author = "Nascimento (2017)"
			}

			mreport:addText("F6: "..cell.F6)
			mreport:addText("Fluxo: "..cell.RSUdia14.."ton/dia")
			mreport:addText("Area: "..math.floor(cell.Area_ha).."ha")

			return mreport
		end
    },
}

