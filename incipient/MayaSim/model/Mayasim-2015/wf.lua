require("print_r")
-- Water flow function
function wf(cellSpace, order)
    
    for k, v in pairs(order) do
        local x = tonumber(v[3]) -- x value in order table
        local y = tonumber(v[4]) -- y value in order table
        local coord = Coord { x = x, y = y} -- building a Coord to get the right cell
        local cell = cellSpace:getCell(coord)
        
        while(lowerNeighbor(cell) and cell.waterLevel > 0) do
            local current = cell.neighborhoods.neigh1:sample()
            if (((current.dem + neighbor.waterLevel / 1000) < (cell.dem + cell.waterLevel / 1000)) and neighbor.dem ~= -9999) then
                cell.waterLevel = cell.waterLevel - 1
                current.waterLevel = current.waterLevel + 1
            end
        end
        
    end
    return(lowestCell)
end

function lowerNeighbor(cell)
    forEachNeighbor(cell, function(cell, neighbor)
        if (((neighbor.dem + neighbor.waterLevel / 1000) < (cell.dem + cell.waterLevel / 1000)) and neighbor.dem ~= -9999) then
            return true
        end
    end)
    return false
end