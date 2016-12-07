require("n") -- testing field
require("df")

--inital natural forest disturbance
function initalForestDisturbance(cellspace)
    local countCells = cellspace.ydim * cellspace.xdim
    local countDisturbance = math.floor(countCells - (countCells * (96.5/100)))
    local i = 1
    while i < countDisturbance do
        local currentCell = cellspace:sample()
        if currentCell.initPrecip ~= -9999 and currentCell.forest < 3 then
            currentCell.forest = currentCell.forest + 1
            i = i + 1
            currentCell:notify()
        end
    end
end

function forestDisturbance(agent, cellspace)
    forEachCell(cellspace, function(cell)
        if dfCells(agent, cell) < 5 and next(cell.relate) == nil and cell.soil ~= -9999 then
            cell.forest = 2
            cell.notDisturbed = cell.notDisturbed + 1
        else 
            cell.notDisturbed = 0
        end
    end)
end

function forestRegeneration(cell)
    if cell.notDisturbed >= 10 and cell.forest > 1 and cell.soil ~= -9999 then
        cell.forest = cell.forest - 1
    end
end
    