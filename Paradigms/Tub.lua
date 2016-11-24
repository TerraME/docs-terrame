Tub = Model{
    water = 40,
    flow = 5,
    finalTime = 8,
    execute = function(model)
        model.water = model.water - model.flow
    end,
    init = function (model)
        model.chart = Chart{
            target = model,
            select = "water"
        }

        model.timer = Timer{
            Event{action = model},
            Event{action = model.chart}
        }
    end -- init()
} -- Model

Tub:run()

---------------------------
tub = Tub{}

tub:run()
tub.chart:save("tub.png")

---------------------------
instance = Tub{
    finalTime = 12
}

instance:run()
instance.chart:save("tub-12.png")

---------------------------
Tub = Model{
    water = 40,
    flow = 5,
    finalTime = 8,
    execute = function(model)
        model.water = model.water - model.flow
    end,
    init = function (model)
        model.chart = Chart{
            target = model,
            select = "water"
        }

        model.timer = Timer{
            Event{action = model},
            Event{action = model.chart, period = 0.1}
        }

    end -- init()
} -- Model

tub = Tub{}

tub:run()
tub.chart:save("tub-period.png")

clean()
