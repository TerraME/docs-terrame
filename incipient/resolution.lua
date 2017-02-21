
function counter(class, placement)
	return function(self)
		local count = 0

		local agents = self:getAgents(placement)

		if not agents then return 0 end

		for i = 1, #agents do
			if agents[i].class == class then
				count = count + 1
			end
		end

		return count -- if removing this line, a strange error appears
	end
end

cell = Cell{
	c1h = counter("c1", "house"),
	c2h = counter("c2", "house"),
	c3h = counter("c3", "house"),
	c4h = counter("c4", "house"),
	c1w = counter("c1", "workplace"),
	c2w = counter("c2", "workplace"),
	c3w = counter("c3", "workplace"),
	c4w = counter("c4", "workplace")
}

cellspace = CellularSpace{
	xdim = 50,
	instance = cell
}

cellspace:createNeighborhood{
	name = "neighhouse"
}

cellspace:createNeighborhood{
	name = "neighworkplace",
	strategy = "mxn",
	m = 5,
	n = 5,
	inmemory = false
}

citizen = Agent{
	class = Random{c1 = 0.1, c2 = 0.2, c3 = 0.3, c4 = 0.4},
	workdistance = function(self)
		return self:getCell("house"):distance(cell:getCell("workplace"))
	end,
	updateWork = function(self)
		local cell = cellspace:sample()
		local count = 0

		forEachNeighborAgent(cell, "workplace", function(agent)
			if agent.class == self.class then
				count = count + 1
			end
		end)

			
	end
}

society = Society{
	instance = citizen,
	quantity = 500
}

env = Environment{cellspace, society}
env:createPlacement{strategy = "random", max = 10, name = "house"}
env:createPlacement{strategy = "random", max = 10, name = "workplace"}

placements = {"h", "w"}
groups = {"c1", "c2", "c3", "c4"}

for i = 1, 3 do
	map = Map{
		target = cellspace,
		select = groups[i].."h",
		min = 0,
		max = 10,
		slices = 11,
		color = "Blues"
	}

	map = Map{
		target = cellspace,
		select = groups[i].."w",
		min = 0,
		max = 10,
		slices = 11,
		color = "Reds"
	}
end

