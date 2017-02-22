function histogram(groups)
	counter = DataFrame{c1 = {} , c2 = {}, c3 = {}, c4 = {}}
	max = 1

	forEachElement(groups, function(idx, group)
		forEachAgent(group, function(agent)
			local dist = math.ceil(agent:workdistance())

			if dist > max then
				max = dist
			end
		end)
	end)

	forEachElement(groups, function(idx, group)
		local size = #group

		for i = 0, max do
			counter[i][idx] = 0
		end

		forEachAgent(group, function(agent)
			local dist = math.ceil(agent:workdistance())
			counter[idx][dist] = counter[idx][dist] + 1 / size
		end)
	end)

	chart = Chart{
		target = counter,
		xLabel = "Distance",
		yLabel = "Proportion"
	}
end

function counter(class, placement)
	return function(cell)
		local count = 0

		forEachAgent(cell, placement, function(agent)
			if agent.class == class then
				count = count + 1
			end
		end)

		return count -- if removing this line, a strange error appears
	end
end

cell = Cell{
	c1h = counter("c1", "house"), c1w = counter("c1", "workplace"),
	c2h = counter("c2", "house"), c2w = counter("c2", "workplace"),
	c3h = counter("c3", "house"), c3w = counter("c3", "workplace"),
	c4h = counter("c4", "house"), c4w = counter("c4", "workplace")
}

priority = {
	c1 = 4,
	c2 = 3,
	c3 = 2,
	c4 = 1
}

groupedWork = {
	c1 = true,
	c2 = false,
	c3 = true,
	c4 = false
}

citizen = Agent{
	class = Random{c1 = 0.1, c2 = 0.2, c3 = 0.3, c4 = 0.4},
	workdistance = function(self)
		return self:getCell("house"):distance(self:getCell("workplace"))
	end,
	priority = function(self)
		return priority[self.class]
	end,
	workGrade = function(self, workplace)
		local count = 0
		local quantity = 0

		forEachNeighbor(workplace, "workplace", function(_, neigh)
			forEachAgent(neigh, "workplace", function(agent)
				quantity = quantity + 1

				if agent.class == self.class then
					count = count + 1
				end
			end)
		end)

		if groupedWork[self.class] then
			return count / quantity
		else
			return (quantity - count) / quantity
		end
	end,
	houseGrade = function(self, house)
		local count = 0
		local quantity = 0

		forEachNeighbor(house, "house", function(_, cell)
			forEachAgent(cell, "house", function(agent)
				quantity = quantity + 1

				if agent.class == self.class then
					count = count + 1
				end
			end)
		end)

		return count / quantity
	end,
	updateHouse = function(self)
		local candidate = city:sample()
		local current = self:getCell("house")
		local count = 0

		local currentGrade = self:houseGrade(current)
		local newGrade     = self:houseGrade(candidate)

		if newGrade > currentGrade and self:workdistance() > candidate:distance(self:getCell("workplace")) then
			local agents = candidate:getAgents("house")
			local exchange

			forEachElement(agents, function(_, agent)
				if self:priority() > agent:priority() then
					exchange = agent
					return false
				end
			end)

			if exchange then
				self:move(candidate, "house")
				exchange:move(current, "house")
			end
		end
	end,
	updateWork = function(self)
		local candidate = city:sample()
		local current = self:getCell("workplace")
		local count = 0

		local currentGrade = self:workGrade(current)
		local newGrade     = self:workGrade(candidate)

		if newGrade > currentGrade and self:workdistance() > candidate:distance(self:getCell("house")) then
			local exchange

			forEachAgent(candidate, "workplace", function(agent)
				if self:priority() > agent:priority() then
					exchange = agent
					return false
				end
			end)

			if exchange then
				self:move(candidate, "workplace")
				exchange:move(current, "workplace")
			end
		end
	end,
	execute = function(self)
		if Random():number() > 0.8 then
			self:updateWork()
		elseif Random():number() > 0.8 then
			self:updateHouse()
		end
	end
}

city = CellularSpace{
	xdim = 20,
	instance = cell
}

city:createNeighborhood{
	name = "house",
	self = true
}

city:createNeighborhood{
	name = "workplace",
	strategy = "mxn",
	m = 5,
	self = true
}

society = Society{
	instance = citizen,
	quantity = 3200
}

max = 8

env = Environment{city, society}
env:createPlacement{strategy = "random", max = max, name = "house"}
env:createPlacement{strategy = "random", max = max, name = "workplace"}

maph1 = Map{target = city, select = "c1h", min = 0, max = max, slices = 11, color = "Blues"}
maph2 = Map{target = city, select = "c2h", min = 0, max = max, slices = 11, color = "Blues"}
maph3 = Map{target = city, select = "c3h", min = 0, max = max, slices = 11, color = "Blues"}
maph4 = Map{target = city, select = "c4h", min = 0, max = max, slices = 11, color = "Blues"}

mapw1 = Map{target = city, select = "c1w", min = 0, max = max, slices = 11, color = "Reds"}
mapw2 = Map{target = city, select = "c2w", min = 0, max = max, slices = 11, color = "Reds"}
mapw3 = Map{target = city, select = "c3w", min = 0, max = max, slices = 11, color = "Reds"}
mapw4 = Map{target = city, select = "c4w", min = 0, max = max, slices = 11, color = "Reds"}

timer = Timer{
	Event{action = society},
	Event{action = maph1}, Event{action = maph2}, Event{action = maph3}, Event{action = maph4},
	Event{action = mapw1}, Event{action = mapw2}, Event{action = mapw3}, Event{action = mapw4},
	Event{action = function(ev) print(ev:getTime()) end}
}

histogram(society:split("class"))
timer:run(300)
histogram(society:split("class"))

