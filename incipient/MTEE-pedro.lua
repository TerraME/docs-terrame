local function hasHuman(agents)
	local result = false
	forEachElement(agents, function(idx, agt)
		if agt.name == "human" then
			result = true
		end
	end)

	return result
end

local function hasVector(agents)
	local result = false
	forEachElement(agents, function(idx, agt)
		if agt.name == "vector" then
			result = true
		end
	end)

	return result
end

local function numHumans(agents)
	local count = 0
	forEachElement(agents, function(idx, agt)
		if agt.name == "human" then
			count = count + 1
		end
	end)

	return count
end

local function numVectors(agents)
	local count = 0
	forEachElement(agents, function(idx, agt)
		if agt.name == "vector" then
			count = count + 1
		end
	end)

	return count
end

local function numInState(society, state)
	local count = 0
	forEachAgent(society, function(agent)
		if agent.state == state then
			count = count + 1
		end
	end)

	return count
end

local function infectVector(agents, vector)
	forEachElement(agents, function(idx, agt)
		if agt.name == "human" and agt.state == "infected" and agt.incubationTime >= agt.incubationPeriod then
			if vector.state ~= "infected" then
				vector.state = "infected"
				return 
			end
		end
	end)
end

MTEE = Model{
	finalTime = 120,
	bitsPerDay = 1,
	numberOfHumans = 10000,
	numberOfVectors = 10000,
	humanRenewRate = 10, -- %
	maxDensityVectorPerHuman = 2,
	maxVectorAge = 40,
	cellSpaceSize = 65,
	asymptomaticPercentage = 65, -- %
	humanMobilityRate = 50, -- %
	choiceOfTargetPercentage = 70, -- %
	init = function(model)
		model.cell = Cell{
			state = Random{empty = 0.10, public = 0.045, house = 0.855},
			HumansState = function(self)
				local agents = self:getAgents("human")
				local state = "empty"
				if hasHuman(agents) then
					forEachElement(agents, function(idx, agt)
						if agt.name == "human" and agt.state == "infected" then
							state = "infected"
						end
					end)

					if state == "empty" then
						forEachElement(agents, function(idx, agt)
							if agt.name == "human" and agt.state == "recovered" then
								state = "recovered"
							end
						end)
					end

					if state == "empty" then
						forEachElement(agents, function(idx, agt)
							if agt.name == "human" and agt.state == "susceptible" then
								state = "susceptible"
							end
						end)
					end
				end

				return state
			end,
			VectorsState = function(self)
				local agents = self:getAgents("vector")
				local state = "empty"
				if hasVector(agents) then
					forEachElement(agents, function(idx, agt)
						if agt.name == "vector" and agt.state == "infected" then
							state = "infected"
						end
					end)

					if state == "empty" then
						forEachElement(agents, function(idx, agt)
							if agt.name == "vector" and agt.state == "susceptible" then
								state = "susceptible"
							end
						end)
					end
				end

				return state
			end
		}

		model.cs = CellularSpace{
			xdim = model.cellSpaceSize,
			instance = model.cell
		}

		model.cs:createNeighborhood()

		model.human = Agent{
			name = "human",
			state = "susceptible",
			incubationTime = 0,
			incubationPeriod = 2,
			infectivetyPeriod = 2,
			init = function(self) 
				local rand = Random{min = 0, max = 100, step = 1}:sample()
				self.asymptomatic = rand >= 100 - model.asymptomaticPercentage

				rand = Random{min = 0, max = 100, step = 1}:sample() -- The Intrinsic Incubation Period
				if rand >= 32 then
					self.incubationPeriod = Random{min = 4, max = 7, step = 1}:sample()
				end

				rand = Random{min = 0, max = 100, step = 1}:sample() -- The Invectivity Period in Humans
				if rand >= 32 then
					self.infectivetyPeriod = Random{min = 3, max = 6, step = 1}:sample()
				end
			end,
			execute = function(self)
				if self.state == "infected" then
					if self.incubationTime > (self.incubationPeriod + self.infectivetyPeriod) then
						self.state = "recovered"
					end

					self.incubationTime = self.incubationTime + 1
				end
			end
		}

		model.humans = Society{
			instance = model.human,
			quantity = model.numberOfHumans
		}

		model.humans:sample().state = "infected"

		model.vector = Agent{
			name = "vector",
			state = "susceptible",
			age = Random{min = 1, max = 40, step = 1},
			incubationTime = 0,
			incubationPeriod = 9,
			init = function(self)
				local rand = Random{min = 0, max = 100, step = 1}:sample()
				if rand > 5 then
					self.incubationPeriod = Random{min = 8, max = 10, step = 1}:sample() -- The Extrinsic Incubation Period 
				end
			end,
			execute = function(self)
				local cell = self:getCell()
				local agts = cell:getAgents("human")
				if self.state == "susceptible" then
					if hasHuman(agts) then
						infectVector(agts, self)
					else 
						forEachNeighbor(cell, function(c, neigh)
							local neighAgents = neigh:getAgents("human")
							if hasHuman(neighAgents) then
								infectVector(neighAgents, self)
							end
						end)
					end
				elseif self.incubationTime > self.incubationPeriod then
					local bits = 0
					local rand = Random{min = 0, max = 100, step = 1}:sample() -- The vector target choice (neighboor or local cell)

					if rand > 100 - model.choiceOfTargetPercentage then
						forEachElement(agts, function(idx, agt)
							if agt.name == "human" and bits < model.bitsPerDay then
								if agt.state == "susceptible" then
									agt.state = "infected"
									bits = bits + 1
								end
							end
						end)
					else
						forEachNeighbor(cell, function(c, neigh)
							local neighAgents = neigh:getAgents("human")
							forEachElement(neighAgents, function(idx, agt)
								if agt.name == "human" and bits < model.bitsPerDay then
									if agt.state == "susceptible" then
										agt.state = "infected"
										bits = bits + 1
									end
								end
							end)
						end)
					end
				end

				if self.state == "infected" then
					self.incubationTime = self.incubationTime + 1
				end
				if self.age == model.maxVectorAge then
					local child = self:reproduce()
					child:move(self:getCell(), "vector")
					self:die()
				end
				self.age = self.age + 1
			end
		}

		model.vectors = Society{
			instance = model.vector,
			quantity = model.numberOfVectors
		}

		model.env = Environment{
			model.humans,
			model.vectors,
			model.cs
		}

		model.env:createPlacement{strategy = "void", name = "vector"}
		model.env:createPlacement{strategy = "void", name = "human"}

		forEachAgent(model.humans, function(human)
			local cell = model.cs:sample()
			local Nh = Random{min = 2, max = 6, step = 1}:sample() -- Number of humans in a house
			if cell.state ~= "empty" and numHumans(cell:getAgents("human")) < Nh then
				human:enter(cell, "human")
			else
				while cell.state == "empty" or numHumans(cell:getAgents("human")) >= Nh do
					cell = model.cs:sample()
				end

				human:enter(cell, "human")
			end
		end)

		forEachAgent(model.vectors, function(vector)
			local cell = model.cs:sample()
			if hasHuman(cell:getAgents("human")) and numVectors(cell:getAgents("vector")) < numHumans(cell:getAgents("human")) * model.maxDensityVectorPerHuman then 
				vector:enter(cell, "vector")
			else
				while (not hasHuman(cell:getAgents("human"))) or numVectors(cell:getAgents("vector")) >= numHumans(cell:getAgents("human")) * model.maxDensityVectorPerHuman do
					cell = model.cs:sample()
				end
				vector:enter(cell, "vector")
			end
		end)

		model.numHumansSusceptible = function()
			return numInState(model.humans, "susceptible")
		end
		model.numHumansInfected = function()
			return numInState(model.humans, "infected")
		end
		model.numHumansRecovered = function()
			return numInState(model.humans, "recovered")
		end

		model.numVectorsSusceptible = function()
			return numInState(model.vectors, "susceptible")
		end

		model.numVectorsInfected = function()
			return numInState(model.vectors, "infected")
		end

		model.map4 = Map{
			target = model.cs,
			select = "HumansState",
			value = {"empty", "susceptible", "infected", "recovered"},
			color = {"white", "green", "red", "blue"}
		}

		model.map5 = Map{
			target = model.cs,
			select = "VectorsState",
			value = {"empty", "susceptible", "infected"},
			color = {"white", "green", "red"}
		}

		model.chart1 = Chart{
			target = model,
			select = {"numHumansSusceptible", "numHumansInfected", "numHumansRecovered"},
			color = {"green", "red", "blue"}
		}

		model.chart2 = Chart{
			target = model,
			select = {"numVectorsSusceptible", "numVectorsInfected"},
			color = {"green", "red"}
		}

		model.timer = Timer{
			Event{action = model.cs},
			Event{action = model.map4},
			Event{action = model.map5},
			Event{action = model.humans},
			Event{action = model.vectors},
			Event{action = model.chart1},
			Event{action = model.chart2},
			Event{action = function(event)
				local rand = Random{min = 0, max = 100, step = 1}:sample()
				local human = model.humans:sample()
				local cell = model.cs:sample()

				while cell.state == "empty" do
					cell = model.cs:sample()
				end

				if rand >= 100 - model.humanRenewRate then -- Human Renovation Rule
					local child = human:reproduce()
					child:move(cell, "human")
					human:die()
				end
			end},
			Event{action = function(event)
				forEachAgent(model.humans, function(human)
					local cell = model.cs:sample()
					while cell.state == "empty" do
						cell = model.cs:sample()
					end

					if human.state == "infected" then
						if human.incubationTime < human.incubationPeriod or asymptomatic then
							human:move(cell, "human")
						end 
					else
						local rand = Random{min = 0, max = 100, step = 1}:sample()
						if rand > 100 - model.humanMobilityRate then
							human:move(cell, "human")
						end
					end
				end)
			end}
		}
	end
}

MTEE:run()

