
--- Round a number given its value and a precision.
-- @arg num A number.
-- @arg idp The number of decimal places to be used.
-- @usage round(2.34566, 3)
function round(num, idp)
    -- ...
end 


--- A second order function to numerically solve ordinary 
-- differential equations with a given initial value.
-- @arg attrs.method the name of a numeric algorithm to 
-- solve the ordinary differential equations.
-- @arg attrs.equation A differential equation or a vector of equations.
-- @arg attrs.a The beginning of the interval.
-- @arg attrs.b The end of the interval.
-- @usage v = integrate {
--     -- ...
-- }
function integrate(attrs)
    -- ...
end

--- Create neighborhood.
-- @tabular strategy
-- Strategy & Description & Compulsory Arguments & 
-- Optional Arguments \
-- "coord" & A bidirected relation. & target & name \
-- "function" & A Neighborhood based on a function. & 
-- filter & name \
-- "moore"(default) & Eight touching Cells. & &
-- name, self, wrap \    
-- "vonneumann" & Rook Neighborhood. & & name, self, wrap
function createNeighborhood()
	-- ...
end

