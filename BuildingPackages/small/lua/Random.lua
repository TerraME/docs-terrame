
metaTableRandom = {
	--- Reset the seed to generate random numbers.
	-- @arg seed A positive integer number.
	-- @usage value = random:reSeed(1)
	reSeed = function(self, seed)
	    -- ...
	end
}

--- Type to generate random numbers.
-- @arg data.seed A number to generate the pseudo-random numbers.
-- Default is the current time of the system.
-- @usage random = Random()
--
-- random = Random{seed = 0}
function Random(data)
    -- ...
end


