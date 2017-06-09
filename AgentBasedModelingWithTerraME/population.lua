
reproduce = Random{p = 0.1}

person = Agent{
	age = Random{mean = 30, sd = 4},
	children = Random{lambda = 2},
	execute = function(self)
		self.age = self.age + 1

		if self.age < 50 and reproduce:sample() then
			self.children = self.children + 1
		end
	end
}

population = Society{
	instance = person,
	quantity = 100
}

chart = Chart{
	target = population,
	select = "children"
}

t = Timer{
	Event{action = chart},
	Event{action = population}
}

t:run(30)

chart:save("population.png")
