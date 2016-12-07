function cl(cell)
    local out = 0
    forEachNeighbor(cell, function(cell, neighbor) 
        if neighbor.cropped == true and neighbor.initPrecip ~= -9999 then
            out = out + tonumber(neighbor.precip)
        end
    end)
    return out
end
