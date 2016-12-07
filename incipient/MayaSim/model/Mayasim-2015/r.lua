require("rc")
require("df")
require("maxdf")
require("cl")

-- Calculation of the current precipitation
function r(cell)
    -- As its not explained how the "localized rainfall effect based on cleared land" is calculated, the multiplicator is 0 to make it nonrelevant
    local delta = 0
    cell.precip = cell.initPrecip * rc(cell) * (maxdf(cell) / df(cell)) + delta * cl(cell)
    return cell.precip
end

-- Calculation of the current Waterlevel based on Waterlevel on t = t-1 and current precipitation
function rWaterLevel(cell)
    -- As its not explained how the "localized rainfall effect based on cleared land" is calculated, the multiplicator is 0 to make it nonrelevant
    local delta = 0
    cell.precip = cell.initPrecip * rc(cell) * (maxdf(cell) / df(cell)) + delta * cl(cell)
    if cell.initPrecip ~= -9999 then
        cell.waterLevel = cell.waterLevel + cell.precip
    else
        cell.waterLevel = -9999
    end
end