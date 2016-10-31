
amazonia = CellularSpace{
    file = filePath("amazonia.shp", "base"),
    xy = {"Col", "Lin"},
	as = {defor = "defor_10"}
}


map = Map{
	target = amazonia,
	select = "defor",
	min = 0,
	max = 1,
	slices = 8,
    color = "RdYlGn",
    invert = true
}

map:save("amazonia.png")

