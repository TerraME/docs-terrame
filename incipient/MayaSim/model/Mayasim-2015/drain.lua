-- calculates the drain for a cell
function drain(cell)
    
    local drainClimax = 0.3
    local drainSecond = 0.2
    local drainCroppe = 0.1
    
    if     cell.forest == 1 then cell.waterLevel = cell.waterLevel * (1 - drainClimax)
    elseif cell.forest == 2 then cell.waterLevel = cell.waterLevel * (1 - drainSecond)
    elseif cell.forest == 3 then cell.waterLevel = cell.waterLevel * (1 - drainCroppe) end
end