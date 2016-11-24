
Fire = Model{
    finalTime = 50,
    dim = 50,
    init = function(model)
        model.cell = Cell{
            state = "forest",
            execute = function(cell)
                if cell.past.state == "burning" then
                    cell.state = "burned"
                elseif cell.past.state == "forest" then
					forEachNeighbor(cell, function(_, neigh)
						if neigh.past.state == "burning" then
                        	cell.state = "burning"
						end
                    end)
                end
            end
        }

        model.cs = CellularSpace{
            xdim = model.dim,
            instance = model.cell,
        }

        model.cs:sample().state = "burning"
        model.cs:createNeighborhood{strategy = "vonneumann"}

        model.chart = Chart{
            target = model.cs,
            select = "state",
            value = {"forest", "burning", "burned"},
            color = {"green", "red", "brown"}
        }

        model.map = Map{
            target = model.cs,
            select = "state",
            value = {"forest", "burning", "burned"},
            color = {"green", "red", "brown"}
        }

        model.timer = Timer{
            Event{action = model.cs},
            Event{action = model.chart},
            Event{action = model.map}
        }
    end
}

Fire:run()
