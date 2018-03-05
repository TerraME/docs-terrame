
import("ca")
import("calibration")

mr = MultipleRuns{
	model = Fire,
	repetition = 5,
	parameters = {
		empty = Choice{min = 0.2, max = 1, step = 0.05},
		dim = 30
	},
	forest = function(model)
		return model.cs:state().forest or 0
	end,
	summary = function(result)
        local sum = 0

        forEachElement(result.forest, function(_, value)
            sum = sum + value
        end)

        return {average = sum / #result.forest}
    end
}

chart = Chart{
    target = mr.summary,
    select = "average",
	label = "average in the end",
    xAxis = "empty",
	color = "red"
}

chart:save("fire.png")

