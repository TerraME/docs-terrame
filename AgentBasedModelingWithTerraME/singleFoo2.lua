singleFooAgent = Agent{
    execute = function(self)
		self:getCell().washere = "yes"
        self:walk()
    end
}

cell = Cell{
	washere = "no",
	state = function(self)
		if self:isEmpty() then
			return self.washere
		else
			return "foo"
		end
	end
}

cs = CellularSpace{
    xdim = 10,
	instance = cell
}

cs:createNeighborhood{} -- Moore neighborhood as default

e = Environment{
    cs,
    singleFooAgent
}

e:createPlacement{} -- random

map = Map{
    target = cs,
    select = "state",
	value = {"no", "yes", "foo"},
	color = {"lightGray", "gray", "blue"}
}

t = Timer{
    Event{action = singleFooAgent},
    Event{action = map}
}

t:run(100)

map:save("singleFoo2.png")

