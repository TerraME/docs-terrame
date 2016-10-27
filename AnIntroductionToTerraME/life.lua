-- Game of Life example for TerraME tutorial.

init = function(model)
	model.cell = Cell{
		state = Random{alive = model.probability, dead = 1 - model.probability},
		execute = function(cell)
			local alive = 0

			forEachNeighbor(cell, function(_, neigh)
				if neigh.past.state == "alive" then
					alive = alive + 1
				end
			end)

			if alive < 2 then -- loneliness
				cell.state = "dead"
			elseif alive > 3 then -- overpopulation
				cell.state = "dead"
			elseif alive == 3 then -- reproduction
				cell.state = "alive"
			end
		end
	}

	model.cs = CellularSpace{
		xdim = model.dim,
		instance = model.cell
	}

	model.cs:createNeighborhood{wrap = true}

	model.map = Map{
		target = model.cs,
		select = "state",
		value = {"dead", "alive"},
		color = {"black", "white"}
	}

	model.timer = Timer{
		Event{action = model.cs},
		Event{action = model.map}
	}
end

Life = Model{
	finalTime = 100,
	dim = 30,
	probability = 0.5,
	init = init
}

Life:run()
