
SIR = Model{
	susceptible = 9998,
	infected = 2,
	recovered = 0,
	duration = 2,
	contacts = 6,
	finalTime = 30,
	probability = 0.25,
	init = function(model)
		model.chart = Chart{
			target = model,
			select = {"susceptible", "infected", "recovered"},
			color = {"green", "red", "blue"}
		}
		
		local total = model.susceptible + model.infected + model.recovered
		local alpha = model.contacts * model.probability 

		model.timer = Timer{
			Event{action = function()
				local prop = model.susceptible / total

				local newInfected = model.infected * alpha * prop
				local newRecovered = model.infected / model.duration
				model.susceptible = model.susceptible - newInfected
				model.recovered = model.recovered + newRecovered
				model.infected = model.infected + newInfected - newRecovered
			end},
			Event{action = model.chart}
		}
	end
}

SIR:run()

instance = SIR{}

instance:run()

instance.chart:save("sir-basic.png")

instance = SIR{
	duration = 4,
	contacts = 2,
	finalTime = 80
}

instance:run()

instance.chart:save("sir-instance.png")

env = Environment{
	SIR{},
	SIR{duration = 4},
	SIR{duration = 8}
}

clean()

chart = Chart{
	target = env,
	select = "infected",
}

timer = Timer{
	Event{action = chart}
}

env:add(timer)

env:run()

chart:save("sir-scenario.png")

SIR:configure()


