-- TODO:
-- 150km resolucao
-- atributo agregado para colorir mapa
-- atributos para grafico
-- fazer grafico aparecer
-- pegar os nomes dos municipios que tem intersecao com a celula

local content = {
		A = "This is application sample that show you a dynamic graphic, click on about the graphic label to turn on and turn off the graphic data",
	}

import("publish")

Application{
	project = "amaz.tview",
	base = "roadmap",
	title	= "DETER acumulado",
	description = "Esta aplicação mostra os dados do DETER acumulados para o ano de 2020, em uma resolução de 150x150km.",
	output	= "graphicWebMap",

	deter_up = View{
        value = {"low", "medium", "high"},
        color = {"blue", "yellow", "red"},
		select  = "status",
		description = "DETER acumulado 2020",
		report = function(cell)
			local report = Report{
				title = "Col "..cell.col.."x"..cell.row
			}

			------ Text block ---------
			report:addHeading("First Graphic application")
			report:addText(content.A)
			report:addSeparator()

			------ Creat Graphic -----------
			local GRAPHIC01 = {
--				id = 0, -- madatory start at zero
				title = "Data of "..cell.col,
				columns = {
						"area01",
						"area02",
					}, --end columns
				values = {
						{
						"dg dÁrea", -- label of graphic
						cell.ArDS0620,
						cell.ArDS0520,
						},

						{
						"d Área", -- label of graphic
						cell.ArDS0620,
						cell.ArDS0520,
						},

						{
						"mcwd", -- label of graphic
						cell.ArDS0620,
						cell.ArDS0520,
						},

					} -- end values
				} -- end table
			report:addGraphic(GRAPHIC01)
            report:addText("Values: "..cell.ArDS0520..", "..cell.ArDS0620)

			return report
		end
	},
}
