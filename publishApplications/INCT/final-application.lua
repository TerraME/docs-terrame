-------------------------------------------------------------------------------------------
-- TerraME - a software platform for multiple scale spatially-explicit dynamic modeling.
-- Copyright (C) 2001-2017 INPE and TerraLAB/UFOP -- www.terrame.org

-- This code is part of the TerraME framework.
-- This framework is free software; you can redistribute it and/or
-- modify it under the terms of the GNU Lesser General Public
-- License as published by the Free Software Foundation; either
-- version 2.1 of the License, or (at your option) any later version.

-- You should have received a copy of the GNU Lesser General Public
-- License along with this library.

-- The authors reassure the license terms regarding the warranties.
-- They specifically disclaim any warranties, including, but not limited to,
-- the implied warranties of merchantability and fitness for a particular purpose.
-- The framework provided hereunder is on an "as is" basis, and the authors have no
-- obligation to provide maintenance, support, updates, enhancements, or modifications.
-- In no event shall INPE and TerraLAB / UFOP be held liable to any party for direct,
-- indirect, special, incidental, or consequential damages arising out of the use
-- of this software and its documentation.
--
-------------------------------------------------------------------------------------------

-- @example Implementation of a simple Application using Prodes data
-- from a WMS.

import("gis")
import("publish")

local file = File("prodes.tview")
local baseproj = {title = "Prodes", file = file, clean = true}

local source = "wms"
local basemap = "amazon:"
local service = "http://35.198.39.192/geoserver/wms"

local layers = {
	"deforestationMask",
	"prodes_2000", "prodes_2005", "prodes_2010", "prodes_2015",
	"dam_1970", "dam_1980", "dam_1990", "dam_2000", "dam_2005", "dam_2010", "dam_2015",
	"conservationUnits_1970", "conservationUnits_1980", "conservationUnits_1990", "conservationUnits_2000", "conservationUnits_2005", "conservationUnits_2010", "conservationUnits_2015",
	"indigenousLand_1970", "indigenousLand_1980", "indigenousLand_1990", "indigenousLand_2000", "indigenousLand_2005", "indigenousLand_2010", "indigenousLand_2015",
	"roads_1970", "roads_1980", "roads_1990", "roads_2000", "roads_2005", "roads_2010", "roads_2015",
	"settlements_1970", "settlements_1980", "settlements_1990", "settlements_2000", "settlements_2005", "settlements_2010", "settlements_2015"
}

file:deleteIfExists()
local proj = Project(baseproj)

print("Loading layers from 'WMS'...")

local current = 1
local size = #layers
forEachElement(layers, function(_, name)
	print("Loading layer '"..name.."' (".. current .."/".. size ..")")
	Layer{
		project = proj,
		source = source,
		service = service,
		name = name,
		map = basemap..name
	}

	current = current + 1
end)

print("Loading layers from 'file'...")
print("Loading layer 'amazon' (1/2)")

Layer{
	project = proj,
	name = "amazon",
	file = "limiteAML.shp"
}

print("Loading layer 'amazon' (2/2)")

Layer{
	project = proj,
	name = "biome",
	file = "BiomaAmazonia.shp"
}


local popUp = [[
<table style="width:100%">
<tr>
    <td style="width: 85%">This application explores the evolution of infrastructure, territorial units, and deforestation in the Brazilian Amazon. It is a Google Maps application that gathers data collected from different sources, including INPE, Ministry of Environment, National Water Agency, and IBGE. The left panel can be used to select the data to be visualized, while the bottom panel manages time. This application is a contribution of the Brazilian National Institute of Science and Technology (INCT) for Climate Change funded by ]]..link("www.cnpq.br", "CNPq")..[[ Grant Number 573797/2008-0 and ]]..link("http://www.fapesp.br/en/", "FAPESP")..[[ Grant Number 2008/57719-9.</td>
    <td style="width: 15%" align="right"><img src="http://www.inct.provisorio.ws/img/main-menu-logo.png"/></td>
</tr>

</table>
]]

link = function(http, value) return value.." ("..http..")" end

Application{
	key = "AIzaSyA1coAth-Bo7m99rnxOm2oOBB88AmaSbOk",
	title = "Brazilian Amazon",
	project = proj,
	description = popUp,
	output = "INCTWebMap",
	base = "terrain",
	simplify = false,
	clean = true,
	logo = "inct.png",
	template = {navbar = "#32884D", title = "white"},
	order = {"dam", "roads", "prodes", "deforestationMask", "conservationUnits", "indigenousLand", "settlements", "biome", "amazon"},
	amazon = View{
		description = "Legal Amazon area. This area was initially established by "..link("http://www2.camara.leg.br/legin/fed/lei/1950-1959/lei-1806-6-janeiro-1953-367342-publicacaooriginal-1-pl.html", "Brazilian Law 1806")..". It covers all the states from the North region in Brazil, plus Mato Grosso and part of Maranhao. PRODES monitors deforestation within this area. It contains almost all Amazon biome, except by part of Maranhao state. The areas in Legal Amazon outside Amazon biome belong to Cerrado biome.",
		title = "Legal Amazon",
		color = "white",
		transparency = 1,
		visible = false
	},
	biome = View{
		description = "Brazilian Amazon biome. It covers approximately half the area of Brazil. The definition of Amazon biome is officially provided by "..link("https://ww2.ibge.gov.br/home/presidencia/noticias/21052004biomashtml.shtm", "IBGE")..".",
		title = "Amazon Biome",
		color = "green",
		transparency = 0.6,
		visible = false
	},
	deforestationMask = View{
		title = "Mask",
		description = "PRODES deforestation mask. It defines areas that are not mapped by "..link("http://www.obt.inpe.br/OBT/assuntos/programas/amazonia/prodes", "PRODES")..". They include regions that were never pristine forest, as well as water bodies. Note, for example, the areas within Legal Amazon that does not belong to Amazon biome, most of them are cerrado areas. In PRODES, water bodies and non-forest areas are two separated classes, but they were combined here for simplification purposes.",
		color = {{174, 87, 165}},
		label = {"Non-forest"},
		transparency = 0.6,
		visible = false,
	},
	settlements = View{
		title = "INCRA Settlements",
		description = "Rural settlements. Each settlement is a set of agricultural units, whose original rural property belonged to a single owner. Each of these units, called parcels, lots or glebas (in portuguese), is delivered by "..link("http://www.incra.gov.br", "INCRA")..", Brazilian's National Institute of Colonization and Agrarian Reform, to a family with no economic conditions to acquire and maintain a rural property by its own means. Source: "..link("http://acervofundiario.incra.gov.br/acervo/acv.php", "INCRA")..".",
		color = {"#F6C567"},
		label = {"Settlement"},
		time = "snapshot",
		transparency = 0.2,
		visible = false
	},
	indigenousLand = View{
		title = "Indigenous lands",
		description = "Indigenous areas with several status. The map includes identified, declared, delimited, reserved, regularized, and homologated areas. Source: "..link("http://www.funai.gov.br/index.php/shape", "FUNAI")..".",
		color = {{214, 133, 137}},
		label = {"Indigenous land"},
		time = "snapshot",
		transparency = 0.2,
		visible = false
	},
	conservationUnits = View{
		title = "Conservation units",
		description = "Federal and state conservation units. Each type of conservation unit has its own "..link("http://www.mma.gov.br/informma/itemlist/category/34-unidades-de-conservacao", "land use rules")..", such as integral protection or sustainable use. Source: "..link("http://www.icmbio.gov.br/portal/geoprocessamentos/51-menu-servicos/4004-downloads-mapa-tematico-e-dados-geoestatisticos-das-uc-s", "ICMBIO")..".",
		color = {"#D3FFBE", "#E9FFBE"},
		label = {"Federal", "State"},
		time = "snapshot",
		transparency = 0.2,
		visible = false
	},
	prodes = View{
		title = "Deforestation",
		description = "Clear-cut deforestation. This data comes from "..link("http://www.obt.inpe.br/OBT/assuntos/programas/amazonia/prodes", "PRODES").." project. An area marked as deforestation will always belong to this class in PRODES because it might regenerate but will never become pristine forest again. This application uses only data from the digital version of PRODES, avaliable for the year 2000 onwards. Before 2000, no deforestation is shown in the application. Note that Google's satellite data available for the background is newer than the latest PRODES data available in the application (2015).",
		color = {"#FF0000"},
		label = {"Deforestation"},
		transparency = 0.3,
		time = "snapshot"
	},
	roads = View{
		description = "Federal roads. Source: "..link("http://www.dnit.gov.br/mapas-multimodais/shapefiles", "DNIT")..".",
		transparency = 0.1,
		color = {"#6E6E6E", "#732600"},
		label = {"Paved", "Non-paved"},
		time = "snapshot",
		visible = false
	},
	dam = View{
		title = "Hidroeletric plants",
		description = "Hidroeletric plants in operation. Source: "..link("http://www.ana.gov.br.", "ANA")..".",
		color = {"#00A1E2"},
		label = {"Hidroeletric plants"},
		time = "snapshot",
		visible = false
	}
}

file:deleteIfExists()
