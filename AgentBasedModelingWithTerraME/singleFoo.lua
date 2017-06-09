singleFooAgent = Agent{
	size = 10,
	name = "foo",
	execute = function(self)
		self.size = self.size + 1
		self:walk()
	end
}

cs = CellularSpace{
	xdim = 10
}

cs:createNeighborhood{} -- Moore neighborhood as default

e = Environment{
	cs,
	singleFooAgent
}

e:createPlacement{} -- random

map = Map{
	target = cs,
	grouping = "placement",
	value = {0, 1},
	color = {"gray", "blue"}
}

t = Timer{
	Event{action = singleFooAgent},
	Event{action = map}
}

t:run(100)

map:save("singleFoo.png")

