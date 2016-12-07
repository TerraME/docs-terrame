--*******************Final Project**********************
-- ******Sex, culture and conflict in Sugarscape********
--CST-317: Introduction to Earth System Modelling
--Date: 23/09/2016
--Students:
--Andre R. Goncalves
--Frederico F. Avila
--******************************************************
-- Sugarscape

import("logo")

Sugarscape = Model{
	finalTime = 2500,
	initPop = 400,
	
	init = function(model)
		-- updates cellular space
		model.cs = CellularSpace{
			file = filePath("default.pgm", "logo"),
			attrname = "maxSugar"
		}

		-- Creates a von Neuman neihborhood extended up to 6 cells
		model.cs:createNeighborhood{
			strategy = "mxn",
			m = 13,
			filter = function(cell, candidate)
				-- if neigh is located in same line or colunm
				if cell.x == candidate.x or cell.y == candidate.y then
					return true -- is neigh
				else
					return false -- not neigh
				end
			end
		}
		
		-- Initial sugar
		forEachCell(model.cs,function(cell)
			cell.sugar = cell.maxSugar -- sugar equals maxsugar to initialize cell
			cell.howFit = 1.4 -- average vision (3.5) by average metabolism (2.5) init
		 end)
		-- Cellular space execution
		model.cs.execute = function()

			forEachCell(model.cs,function(cell)
				-- Rule G1: sugargrows 1 per time step
				cell.sugar = cell.sugar + 1
				if cell.sugar > cell.maxSugar then
					cell.sugar = cell.maxSugar
				end
				-- Fit function
				if cell:isEmpty() then
					cell.howFit = 0
				else
					cell.howFit= cell:getAgent().vision / cell:getAgent().metabolism
				end
			end)
		end
		
		-- Random function
		local random = Random()
		local sex = Random{0,10} -- woman, man
		
		-- Defining agents
		model.agent = Agent{
			-- Defining agent attributes
			init = function(agent)
				agent.sugar        = random:integer(5, 25)
				agent.metabolism   = random:integer(1, 4)
				agent.vision       = random:integer(1, 6)
				agent.age          = 0
				agent.dieby        = random:integer(60, 100) -- maximum age
				agent.sex          = sex:sample()
				agent.initSugar    = agent.sugar -- initial sugar
				agent.fertility    = false
				agent.fertileStart = random:integer(12, 15) -- initial fertile period
				agent.fertileEnd   = random:integer(40, 50) + agent.sex -- initial fertile period
				agent.kids         = {} -- list of sons for inheritance
			end,
			-- Agents dynamics
			execute = function(self)
				
				-- Rule S: Find a mate and reproduce
				local mates = {} --potential mates
				local emptycell = {} -- in beginning there is no empty cell
				local sexAge = self.age > self.fertileStart and self.age < self.fertileEnd
				-- updates ferility from sexAge and wealth
				if sexAge and self.sugar>2*self.initSugar then
					self.fertility  = true
				end
				-- neighborhood will depend on agents vison
				forEachNeighbor(self:getCell(),function(c,n)
					-- local agent and distance to neigh
					local agent = c:getAgent()
					local neighbor = n:getAgent()
					local distx  = math.abs(n.x - c.x) -- horizontal distance
					local disty  = math.abs(n.y - c.y) -- vertical distance
					-- if distance to neigh is within agents vision
					if math.max(distx,disty) <= agent.vision then
						-- if there is a potential mate
						if not n:isEmpty()
						and agent.fertility
						and neighbor.fertility
						and agent.sex ~= neighbor.sex then
							table.insert(mates,neighbor) -- append to table
						elseif n:isEmpty() then
							table.insert(emptycell,n)
						end
					end
				end)

				-- Find a mate and reproduce
				for i = 1, #mates do
					local partner = mates[i]

					if #emptycell > 0 then -- if there is empty cells
						table.remove(emptycell, 1) -- exclude empty cell from list
					else
						-- look for an empty space in partner neighbors
						forEachNeighbor(partner:getCell(),function(c, n) --scan partner neighbors
							-- local agent and distance to neigh
							local agent = c:getAgent()
							local distx  = math.abs(n.x - c.x) -- horizontal distance
							local disty  = math.abs(n.y - c.y) -- vertical distance
							-- if distance to neigh is within agents vision and empty
							if math.max(distx,disty) <= agent.vision and n:isEmpty() then
								nest = n -- updates nest
							end
						end)
					end

					if nest then -- reproduce if there is a place to put children
						child = self:reproduce() -- reproduce
						child:move(nest) -- move to empty cell
						-- average genetic transmitance - not yet Mendel's law
						child.vision = math.floor((self.vision + partner.vision) / 2)
						child.metabolism = math.floor((self.metabolism + partner.metabolism) / 2)
						child.sugar = (self.sugar + partner.sugar) / 2 -- child got parents sugar
						self.sugar = self.sugar / 2 -- deplet half of parents sugar
						partner.sugar = partner.sugar / 2
						table.insert(self.kids, child) -- append to kids list
						table.insert(partner.kids, child) -- append to kids list
					end
				end
				
				-- Rule M: Move to the best neighbor and get all the sugar
				-- gets agent actual cell and creates neighs table
				local cell = self:getCell()
				local neighs = {cell} -- cells to move
				-- neighborhood will depend on agents vison
				forEachNeighbor(self:getCell(),function(c, n)
					-- local agent and distance to neigh
					local agent = c:getAgent()
					local distx  = math.abs(n.x - c.x) -- horizontal distance
					local disty  = math.abs(n.y - c.y) -- vertical distance
					-- if distance to neigh is within agents vision
					if math.max(distx,disty) <= agent.vision then
						-- if finds empty neigh with more sugar: replace element
						if n.sugar > neighs[1].sugar and n:isEmpty() then
							neighs = {n}
						-- if finds empty neigh with same sugar: append element
						elseif n.sugar == neighs[1].sugar and n:isEmpty() then
							table.insert(neighs,n)
						end
					end
				end)
				-- Rule M: Move to the best neighbor and get all the sugar
				self:move(Random(neighs):sample()) -- move
				self.sugar = self.sugar + self:getCell().sugar -- collect sugar
				self:getCell().sugar = 0 -- deplet cell
				
				-- Consumes sugar according to metabolism
				self.sugar = self.sugar - self.metabolism
				
				-- Get old
				self.age = self.age + 1
				
				-- die
				if self.sugar < 0 then
					self:die()
				elseif self.age >= self.dieby then
					--self:reproduce() --only for chapter II
					-- Rule I: Inheritance
					if #self.kids > 0 then
						local share = self.sugar / #self.kids
						for i = 1, #self.kids do
							local each = self.kids[i]
							if each then -- if that kid is still alive
								each.sugar = each.sugar + share
							end
						end
					end
					self:die()
				end
			end
		}
		-- Creates society
		model.society = Society{
			instance = model.agent,
			quantity = model.initPop,
			--Define wealth function
			wealth  = function(self)
				local sum = 0
				forEachAgent(self,function(agent)
					sum = sum + agent.sugar
				end)
				return sum / #self
			end,
			fit  = function(self)
				local sum = 0
				forEachAgent(self,function(agent)
					sum = sum + (agent.vision / agent.metabolism)
				end)
				return sum / #self
			end
		}
		-- Creates a group o Agents to execute
		model.group = Group{
			target = model.society,
			select = function(agent) return agent.sugar >= 0 end
		}
		-- Randomize the group each time step
		model.group:randomize()
		
		--Wealth chart
		model.chart1 = Chart{
			target = model.society,
			select = "wealth",
			title = "Wealth"
		}
		-- Population chart
		model.chart2 = Chart{
			target = model.society,
			title = "Population",
			yLabel = "# Society"
		}
		--Visibility chart
		model.chart3 = Chart{
			target = model.society,
			select = "fit",
			title = "Fit"
		}
		-- Links the cellular space to society
		model.env = Environment{
			model.cs,
			model.society
		}
		-- Places each agent in a random cell
		model.env:createPlacement()
		
		-- Agents position map
		model.map1 = Map{
			target = model.cs,
			grouping = "placement", -- agents inside cells
			min = 0,
			max = 1,
			slices= 2,
			color = "Blues"
		 }
		-- Actual sugar map
		model.map2 = Map{
			target = model.cs,
			select = "sugar",
			min = 0,
			max = 4,
			slices= 5,
			color = "Reds"
		 }
		-- Agents evolution map
		model.map3 = Map{
			target = model.cs,
			select = "howFit",
			min = 0,
			max = 6,
			slices= 6,
			color = {"white", "red", "red", "blue", "blue", "blue"}
		}

		-- Executing the model
		model.timer = Timer{
			Event{action = model.cs},
			Event{action = function()
				model.group:rebuild()
				model.group:randomize()
				model.group:execute()
			end},
			Event{action = model.map1},
			Event{action = model.map2},
			Event{action = model.map3},
			Event{action = model.chart3},
			Event{action = model.chart2},
			Event{start = model.finalTime, priority = "low", action = function()
				model.map1:save("sugar_selection_ch3.bmp")
				model.chart1:save("sugar_wealth_ch3.bmp")
				model.chart2:save("sugar_society_ch3.bmp")
				model.chart3:save("sugar_fit_ch3.bmp")
				print("Final population = "..#model.society)
				print("Final Fit = "..model.society:fit())
				print("Final Wealth = "..model.society:wealth())
			end}
		}
	end
}

Sugarscape:run()
