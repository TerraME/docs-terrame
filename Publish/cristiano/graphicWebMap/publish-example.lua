local content = {
		A = "This is application sample that show you a dynamic graphic, click on about the graphic label to turn on and turn off the graphic data",
	}

import("publish")

Application{
	project = filePath("temporal-data.tview", "publish"),
	base = "roadmap",
	title	= "Teste de dados Temporais",
	description = "Small application with some data",
	output	= "graphicWebMap",


	data = View{
		color = "RdYlGn",
		select  = "id_1",
		description = "Dados de teste",
		report = function(cell)
			local report = Report{
				title = cell.id_1,
				print(cell.id_1),
			}

			------ Text block ---------
			report:addHeading("First Graphic application")
			report:addText(content.A)
			report:addSeparator()

			------ Creat Graphic -----------
			local GRAPHIC01 = {
				id = 0, -- madatory start at zero
				title = "Data of "..cell.id_1,
				columns = {
						"area01",
						"area02",
						"area03",
						"area04",
						"area05",
						"area06",
						"area07",
						"area08",
						"area09",
						"area10",
					}, --end columns
				values = {
						{
						"dg dÁrea", -- label of graphic
						cell.dg_darea06,
						cell.dg_darea07,
						cell.dg_darea08,
						cell.dg_darea09,
						cell.dg_darea10,
						cell.dg_darea11,
						cell.dg_darea12,
						cell.dg_darea13,
						cell.dg_darea14,
						cell.dg_darea15,
						},

						{
						"d Área", -- label of graphic
						cell.d_area02,
						cell.d_area03,
						cell.d_area04,
						cell.d_area05,
						cell.d_area06,
						cell.d_area07,
						cell.d_area08,
						cell.d_area09,
						cell.d_area10,
						cell.d_area11,
						},

						{
						"mcwd", -- label of graphic
						cell.mcwd06,
						cell.mcwd07,
						cell.mcwd08,
						cell.mcwd09,
						cell.mcwd10,
						cell.mcwd11,
						cell.mcwd12,
						cell.mcwd13,
						cell.mcwd14,
						cell.mcwd15,
						},

					} -- end values
				} -- end table
			report:addGraphic(GRAPHIC01)

			return report
		end
	},

}