
function histogram(groups)
	counter = {}
	max = 1

	forEachElement(groups, function(idx, group)
		counter[idx] = {}

		forEachAgent(group, function(agent)
			local dist = math.ceil(agent:workdistance())

			if dist > max then
				max = dist
			end

			if not counter[idx][dist] then
				counter[idx][dist] = 1
			else
				counter[idx][dist] = counter[idx][dist] + 1
			end
		end)
	end)

	-- normalize quantities
--[[
	forEachElement(groups, function(idx, group)
		local size = #group

		for i = 1, max do
			if counter[idx][i] then	
				counter[idx][i] = counter[idx][i] / size
			end
		end
	end)
--]]
	c = Cell{}

	forEachElement(groups, function(idx)
		c[idx] = 0
	end)

	chart = Chart{
		target = c,
		xLabel = "Distance",
		yLabel = "Count"
	}

	for i = 1, max do
		forEachElement(groups, function(idx)
			if counter[idx][i] then
				c[idx] = counter[idx][i]
			else
				c[idx] = 0
			end
		end)

		chart:update(i)
	end
end

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

		forEachNeighbor(workplace, "workplace", function(_, cell)
			local agents = cell:getAgents("workplace")
	
			quantity = quantity + #agents

			for i = 1, #agents do
				if agents[i].class == self.class then
					count = count + 1
				end
			end
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
---------------------------------------------------------
			local agents = cell:getAgents("house")
	
			quantity = quantity + #agents

			for i = 1, #agents do
				if agents[i].class == self.class then
					count = count + 1
				end
			end
---------------------------------------------------------
--[[
			forEachAgent(cell, "house", function(agent)
				quantity = quantity + 1

				if agent.class == self.class then
					count = count + 1
				end
			end)
--]]
---------------------------------------------------------
		end)

		return count / quantity
	end,
	updateHouse = function(self)
		local candidate = cellspace:sample()
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
		local candidate = cellspace:sample()
		local current = self:getCell("workplace")
		local count = 0

		local currentGrade = self:workGrade(current)
		local newGrade     = self:workGrade(candidate)

		if newGrade > currentGrade and self:workdistance() > candidate:distance(self:getCell("house")) then
--------------------------------------------------------------------
--[[
			local exchange

			forEachPlacement(candidate, "workplace", function(agent)
				if self:priority() > agent:priority() then
					exchange = agent
					return false
				end
			end)
--]]
--------------------------------------------------------------------
			local agents = candidate:getAgents("workplace")
			local exchange

			forEachElement(agents, function(_, agent)
				if self:priority() > agent:priority() then
					exchange = agent
					return false
				end
			end)
--------------------------------------------------------------------

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

cellspace = CellularSpace{
	xdim = 20,
	instance = cell
}

cellspace:createNeighborhood{
	name = "house",
	self = true
}

cellspace:createNeighborhood{
	name = "workplace",
	strategy = "mxn",
	m = 5,
	n = 5,
	self = true,
	inmemory = false
}

society = Society{
	instance = citizen,
	quantity = 3200
}

max = 8

env = Environment{cellspace, society}
env:createPlacement{strategy = "random", max = max, name = "house"}
env:createPlacement{strategy = "random", max = max, name = "workplace"}

placements = {"h", "w"}
groups = {"c1", "c2", "c3", "c4"}

for i = 1, 4 do
	_G["map"..i.."h"] = Map{
		target = cellspace,
		select = groups[i].."h",
		min = 0,
		max = max,
		slices = 11,
		color = "Blues"
	}

	_G["map"..i.."w"] = Map{
		target = cellspace,
		select = groups[i].."w",
		min = 0,
		max = max,
		slices = 11,
		color = "Reds"
	}
end

timer = Timer{
	Event{action = society},
	Event{action = map1h},
	Event{action = map2h},
	Event{action = map3h},
	Event{action = map4h},
	Event{action = map1w},
	Event{action = map2w},
	Event{action = map3w},
	Event{action = map4w},
	Event{action = function(ev)
		print(ev:getTime())
	end}
}

histogram(society:split("class"))
timer:run(300)
histogram(society:split("class"))

