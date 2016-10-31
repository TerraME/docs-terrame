cell = Cell{
    state = Random{"alive", "dead"}
}

space = CellularSpace{
    instance = cell,
    xdim = 10
}

map = Map{
	target = space,
	select = "state",
	value = {"alive", "dead"},
	color = {"blue", "gray"}
}

map:save("cellularspace-2.png")


