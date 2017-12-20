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

import("publish")
local gis = getPackage("gis")

local file = File("amazon.tview")
file:deleteIfExists()

local temporalDir = Directory("amazon")
if temporalDir:exists() then temporalDir:delete() end

local proj = gis.Project{
	title = "Deforestation Scenarios",
	author = "Carneiro, H.",
	file = file,
	clean = true,
--	amazon_2005 = "amazonia_2005.shp",
	amazon_2010 = "amazonia_2010.shp",
	amazon_2015 = "amazonia_2015.shp",
	amazon_A_2020 = "amazonia_A_2020.shp",
--	amazon_A_2025 = "amazonia_A_2025.shp",
	amazon_A_2030 = "amazonia_A_2030.shp",
--	amazon_A_2035 = "amazonia_A_2035.shp",
--	amazon_A_2040 = "amazonia_A_2040.shp",
	amazon_B_2020 = "amazonia_B_2020.shp",
--	amazon_B_2025 = "amazonia_B_2025.shp",
	amazon_B_2030 = "amazonia_B_2030.shp",
--	amazon_B_2035 = "amazonia_B_2035.shp",
--	amazon_B_2040 = "amazonia_B_2040.shp",
--	amazon_C_2020 = "amazonia_C1_2020.shp",
--	amazon_C_2025 = "amazonia_C1_2025.shp",
--	amazon_C_2030 = "amazonia_C1_2030.shp",
--	amazon_C_2035 = "amazonia_C1_2035.shp",
--	amazon_C_2040 = "amazonia_C1_2040.shp"
}

local app = Application{
	base = "roadmap",
	project = proj,
	output = temporalDir,
	clean = true,
	simplify = false,
	scenario = {
		A = "Deforestation scenario A.",
		B = "Deforestation scenario B.",
--		C = "Deforestation scenario C."
	},
	amazon = View {
		title = "Deforestation",
		description = "Amount of deforestation in hectares. Deforestation scenarios for Brazilian Amazonia from AMAZALERT project (http://luccme.ccst.inpe.br/deploy/projetos/amazalert/) using 25 x25km cells.",
		select = "value",
		color = "Spectral",
		slices = 10,
		time = "snapshot"
	}
}

file:deleteIfExists()

