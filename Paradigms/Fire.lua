
Fire = Model{
    finalTime = 50,
    dim = 50,
    init = function(model)
        model.cell = Cell{
            state = "forest",
            execute = function(self)
                if self.past.state == "burning" then
                    self.state = "burned"
                elseif self.past.state == "forest" then
                    forEachNeighbor(self, function(_, neigh)
                        if neigh.past.state == "burning" then
                            self.state = "burning"
                        end
                    end)
                end
            end
        }

        model.cs = CellularSpace{
            xdim = model.dim,
            instance = model.cell,
        }

        model.cs:createNeighborhood{strategy = "vonneumann"}
        model.cs:sample().state = "burning"

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

--Fire:run()

------------------------

fire = Fire{}
fire:run()
fire.chart:save("fire-chart.png")
clean()
