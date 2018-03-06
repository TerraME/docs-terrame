
import("ca")
import("calibration")

repetitions = {1, 5, 20}
str_repetitions = {}

local results = {}

forEachElement(repetitions, function(_, value)
	Random{seed = 70374981}
	table.insert(str_repetitions, tostring(value))

	local m = MultipleRuns{
		model = Fire,
		repetition = value,
		parameters = {
			empty = Choice{min = 0.2, max = 1, step = 0.01},
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

	results[tostring(value)] = m.summary.data_.average
	results.empty = m.summary.data_.empty
end)

chart = Chart{
    target = results,
    select = str_repetitions,
	color = {"darkRed", "darkGreen", "blue"},
    xAxis = "empty"
}

chart:save("result-forest.png")

