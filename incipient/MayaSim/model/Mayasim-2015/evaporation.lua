-- calculates the drain for a cell
function evaporation(cell)
    
    local evaporationTemper = cell.temp
    local evaporationClimax = 0.4
    local evaporationSecond = 0.5
    local evaporationCroppe = 0.6
    
    if     cell.forest == 1 then cell.waterLevel = cell.waterLevel * (1 - evaporationClimax)
    elseif cell.forest == 2 then cell.waterLevel = cell.waterLevel * (1 - evaporationSecond)
    elseif cell.forest == 3 then cell.waterLevel = cell.waterLevel * (1 - evaporationCroppe) end 
end