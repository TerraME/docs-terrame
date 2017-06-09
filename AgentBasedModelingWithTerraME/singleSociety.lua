
myAgent = Agent{
	name = "nonfoo",
	execute = function(self)
		self:walkIfEmpty()

		forEachNeighbor(self:getCell(), function(neigh)
			if neigh:isEmpty() then return end

			if neigh:getAgent().name == "foo" then
				print("Found a foo agent in the neighborhood")
			end
		end)
	end
}

mySociety = Society{
	instance = myAgent,
	quantity = 50
}

mySociety:sample().name = "foo"

cell = Cell{
	owner = function(self)
		if self:isEmpty() then
			return "none"
		else
			return self:getAgent().name
		end
	end
}

cs = CellularSpace{
	xdim = 20,
	instance = cell
}

cs:createNeighborhood{
	strategy = "vonneumann",
	wrap = true
}

env = Environment{mySociety, cs}

env:createPlacement{}

map = Map{
	target = cs,
	select = "owner",
	value = {"none", "foo", "nonfoo"},
	color = {"gray", "blue", "yellow"},
	grid = true
}

t = Timer{
	Event{action = mySociety},
	Event{action = map}
}

t:run(100)

map:save("singleSociety.png")

