-- Soil degredation function
function sd(cell)
    if (cell.forest == 3 and cell.soil > 0) then
        cell.soil = cell.soil * 0.85
    elseif (cell.forest == 2 and cell.soil < cell.initSoil) then
        cell.soil = cell.soil * 1.02
    elseif (cell.forest == 1 and cell.soil < cell.initSoil) then
        cell.soil = cell.soil * 1.03
    end
    return cell.soil
end