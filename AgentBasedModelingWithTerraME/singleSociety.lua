
myAgent = Agent{
    name = "nonfoo",
    age = Random{min = 0, max = 10, step = 1},
    execute = function(self)
        self.age = self.age + 1

        local cell = self:getCell():getNeighborhood():sample()
        if cell:isEmpty() then
            self:move(cell)
        end

        forEachNeighbor(cell, function(neigh)
			if neigh:isEmpty() then return end

            if neigh:getAgent().name == "foo" then
                print("Found a foo agent")
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

cs:createNeighborhood{} -- Moore neighborhood as default

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

t:run(10)

map:save("singleSociety.png")

