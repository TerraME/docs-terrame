
import("gis")

project = Project{
	file = "amaz.tview",
	clean = true,
	deter = "amz300_4326.shp",
}

local content = {
		A = "This is application sample that show you a dynamic graphic, click on about the graphic label to turn on and turn off the graphic data",
	}

import("publish")

Application{
	project = "amaz.tview",
	base = "roadmap",
	title	= "Teste de dados Temporais",
	description = "Small application with some data",
	output	= "graphicWebMap",

	deter = View{
		color = "PuBuGn",
		select  = "col",
		description = "Dados de teste",
		report = function(cell)
			local report = Report{
				title = "Col "..cell.col,
				print(cell.col),
			}

			------ Text block ---------
			report:addHeading("First Graphic application")
			report:addText(content.A)
			report:addSeparator()

			------ Creat Graphic -----------
			local GRAPHIC01 = {
				id = 0, -- madatory start at zero
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

			return report
		end
	},
}
