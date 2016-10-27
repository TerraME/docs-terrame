
Sugarscape = Model{
    mapFile        = "sugar-map.csv",
    agents = {
        quantity   = 10,
        wealth     = Choice{min = 5, max = 25},
        metabolism = Choice{min = 1, max = 4}
    },
    block = {
        xmin       = 0,
        xmax       = math.huge,
        ymin       = 0,
        ymax       = math.huge
    },
    interface = function()
        return {
            {"string", "agents"},
            {"block"}
        }
    end,
	init = function()
    	-- ...
	end
}

Sugarscape:configure()
