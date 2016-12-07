require("df")

function maxdf(cell)
    local maxDistance = 0
    
    forEachNeighbor(cell, function(cell, neighbor) 
        local distance = df(neighbor)
        if(distance > maxDistance) then
            maxDistance = distance
        end
    end)
    return maxDistance
end
