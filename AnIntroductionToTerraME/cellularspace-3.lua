cell = Cell{
    state = Random{min = 1, max = 3},
	value = function(self)
		return self.x * self.state
	end
}

space = CellularSpace{
    instance = cell,
    xdim = 30
}

map = Map{
	target = space,
	select = "value",
	min = 0,
	max = 90,
	slices = 5,
	color = "RdPu"
}

map:save("cellularspace-3.png")


