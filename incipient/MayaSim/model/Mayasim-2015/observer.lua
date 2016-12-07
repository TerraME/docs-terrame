local demLegend = Legend { 
    grouping = "quantil",
    slices = 12,
    precision = 1,
    maximum = 3500,
    minimum = 0,
    type = number,
    colorBar = colorbar.brewer ({0,1,2,3,4,5,6,7,8,9,10,11}, "YlOrBr")
}

local precipLegend = Legend { 
    grouping = "equalsteps",
    slices = 12,
    precision = 1,
    maximum = 4999,
    minimum = 0,
    colorBar = colorbar.brewer ({0,1}, "Blues")
}

local tempLegend = Legend { 
    grouping = "equalsteps",
    slices = 12,
    precision = 1,
    maximum = 290,
    minimum = 40,
    colorBar = colorbar.brewer ({0,1}, "Reds")
}

local waterLevelLegend = Legend { 
    grouping = "equalsteps",
    slices = 12,
    precision = 0,
    minimum = 1,
    maximum = 19999,
    colorBar = colorbar.brewer ({0,1}, "Blues")
}

local esLegend = Legend { 
    grouping = "equalsteps",
    slices = 12,
    precision = 0,
    minimum = 0,
    maximum = 11000,
    colorBar = colorbar.brewer ({0,1}, "Blues")
}

local agentLegend = Legend { 
    grouping = "uniquevalues",
    slices = 6,
    precision = 0,
    colorBar = {
        {value = 0, color = "white"},
        {value = 2, color = "red"},
        {value = 80, color = "yellow"},
    }
}

local soilLegend = Legend { 
    grouping = "equalsteps",
    slices = 10,
    precision = 0,
    minimum = 0,
    maximum = 7,
    colorBar = colorbar.brewer ({0,1}, "Oranges")
}

local forestLegend = Legend { 
    grouping = "uniquevalues",
    slices = 3,
    precision = 0,
    colorBar = colorbar.brewer ({0,2}, "Greens")
}

--[[local observer1 = Observer { 
    subject = mayasim.cells,
    type = "map",
    attributes = {"waterLevel"},
    legends = {waterLevelLegend} 
}
]]
local observer2 = Observer { 
    subject = mayasim.cells,
    type = "map",
    attributes = {"soil", "forest"},
    legends = {soilLegend, forestLegend} 
}

local observer3 = Observer { 
    subject = mayasim.cells,
    type = "map",
    attributes = {"es", "color"},
    legends = {esLegend, agentLegend} 
}