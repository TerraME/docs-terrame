
init = function(model)
	model.cell = Cell{
		state = Random{"healthy", "infectious", "immune", "infected"},
		execute = function(cell)
			local ageOfHealthy    = 0
			local ageOfImmune     = 0
			local ageOfInfected   = 0
			local ageOfInfectious = 0
			local timeToRevive    = 0
			local turnInfectious  = 0
			local infectNeigh     = 1
			forEachNeighbor(cell, function(cell, neigh)
				local sample = cell:sample():getNeighborhood()

				if cell.state == "healthy"  then
					model.qHealthy = model.qHealthy +1 
					ageOfHealthy = ageOfHealthy + 1  
					if ageOfHealthy > model.healthyLifespan then  
						cell.state = "dead"
						model.qDead = model.qDead +1 
						model.qHealthy = model.qHealthy -1 
						ageOfHealthy = 0 
					end

					if neigh.past.state == "infectious" then 
						infectNeigh = infectNeigh +1
						if infectNeigh > 3 then 
							cell.state = "infected"
							model.qInfected = model.qInfected +1
							model.qHealthy = model.qHealthy -1 
						end
					end
				elseif cell.state == "infected" then
					model.qInfected = model.qInfected +1		  
					turnInfectious = turnInfectious + 1 
					ageOfInfected = ageOfInfected + 1

					if ageOfInfected > model.infectedLifespan then
						cell.states = "dead"
						model.qDead = model.qDead + 1
						model.qInfected = model.qInfected - 1
						ageOfInfected = 0
					end

					if turnInfectious > model.infectiousTime  then  
						cell.state = "infectious" 
						model.qInfected = model.qInfected -1	
						model.qInfectious = model.qInfectious +1 
						turnInfectious = 0 
					end
				
					if neigh.past.state == "immune" then
						model.qInfected = model.qInfected -1	
						model.qDead = model.qDead + 1
						
						cell.state = "dead"
					end
				elseif cell.state == "infectious" then
					model.qInfectious = model.qInfectious +1
					ageOfInfectious = ageOfInfectious + 1
					if ageOfInfectious > model.infectiousLifespan then
						cell.states = "dead"
						model.qDead = model.qDead + 1
						model.qInfectious = model.qInfectious - 1
						ageOfInfectious = 0
					end
						
					if neigh.past.state == "immune" then
						model.qInfectious = model.qInfectious -1
						model.qDead = model.qDead +1
						cell.state = "dead"
					end
				elseif cell.state == "immune" then
					model.qImmune = model.qImmune + 1 --increment total immune cells
			  
					ageOfImmune = ageOfImmune + 1 --increment current age of cell
					if ageOfImmune > model.immLifespan then -- if true, cell change state to Dead
						cell.state = "dead"
						ageOfImmune = 0 -- reset variable to restart the condition.
						model.qDead = model.qDead + 1 --increment total dead cells
						model.qImmune = model.qImmune -1 --decrement total immune cells
					end
				elseif cell.state == "dead" then
					model.qDead = model.qDead + 1
					timeToRevive = timeToRevive + 1

					if timeToRevive >= model.reviveTime  and neigh.past.state == "healthy"  then
						model.qDead = model.qDead -1
						model.qHealthy = model.qHealthy +1
						cell.state = "healthy"
						timeToRevive = 0
					elseif timeToRevive >= model.reviveTime  and neigh.past.state == "immune"  then
						model.qDead = model.qDead -1
						model.qImmune = model.qImmune +1 
						cell.state = "healthy"
						timeToRevive = 0
					end

					if neigh.past.state == "infected" then
						model.qInfectious = model.qInfectious + 1
						model.qDead = model.qDead -1
						cell.state = "infectious"
					end
				end
			end)
		end
	}

	model.cs = CellularSpace{
		xdim = model.dim,
		instance = model.cell
	}

	model.cs:createNeighborhood()

	model.chart = Chart{
		target = model,
		select = {"qHealthy", "qInfected", "qImmune", "qDead", "qInfectious"},
		color = {"green", "red", "blue", "black", "orange"}
	}
	
	model.map = Map{
		target = model.cs,
		select = "state",
		value = {"healthy", "infected", "immune", "dead", "infectious"},
		color = {"green", "red", "blue", "black", "orange"}
	}

	model.timer = Timer{
		Event{action = model.cs},
		Event{action = model.map},
		Event{action = model.chart}
	}
end

Influenza = Model{
	qHealthy = 0,
	qDead = 0,
	qImmune = 0,
	qInfected = 0,
	qInfectious = 0,
	dim = 20,
	finalTime = 150,
	healthyLifespan = 55, 
	immLifespan = 55,
	infectedLifespan = 55,
	infectiousLifespan = 64,
	infectiousTime = 20,
	reviveTime = 30,
	init = init
}

env = Environment{
	scenario1 = Influenza{healthyLifespan = 3,  immLifespan = 1,  infectedLifespan = 3,  reviveTime = 5},
	scenario2 = Influenza{healthyLifespan = 70, immLifespan = 95, infectedLifespan = 82, reviveTime = 20}
}

env:run()
--Influenza:run()

