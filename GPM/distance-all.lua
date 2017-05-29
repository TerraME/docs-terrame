-- @example Computes neighborhoods based on Euclidean distances from cells to all communities.
-- It considers a neighbor only a community is less or equals than 4km from the centroid of
-- the cell. The output image shows how many neighbors each cell has.
-- @image polygon_farms_quantity.bmp

import("gpm")

local communities = CellularSpace{
	file = filePath("communities.shp", "gpm"),
	geometry = true
}

local cells = CellularSpace{
	file = filePath("cells.shp", "gpm"),
	geometry = true
}

gpm = GPM{
	origin = cells,
	destination = communities,
	strategy = "distance"
}

gpm:fill{
	strategy = "minimum",
	attribute = "dist",
	copy = "LOCALIDADE"
}

map1 = Map{
	target = cells,
	select = "dist",
	slices = 8,
	min = 0,
	max = 7000,
	color = "YlOrRd",
	invert = true
}

map1:save("distance_all_dist.png")

map2 = Map{
	target = cells,
	select = "LOCALIDADE",
	value = {"Palhauzinho", "Santa Rosa", "Garrafao", "Mojui dos Campos"},
	color = "Set1"
}
map2:save("distance_all_loc.png")

gpm:fill{
	strategy = "all",
	attribute = "d"
}

map3 = Map{
	target = cells,
	select = "d_0",
	slices = 8,
	min = 0,
	max = 10000,
	color = "YlOrRd",
	invert = true
}

map2:save("distance_all_0.png")
os.exit()
