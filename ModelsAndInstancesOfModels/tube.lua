
Tube = Model{
    initialWater    = Choice{min = 10, default = 200},
    finalTime       = Choice{min = 1, default = 10},
    flow            = Choice{min = 1, default = 20},
    observingStep   = Choice{min = 0.1, max = 1, step = 0.1, default = 1},
    checkZero       = false,
	init = function() end
}

Tube:configure()
