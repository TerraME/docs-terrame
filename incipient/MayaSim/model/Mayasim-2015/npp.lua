-- Calculate Net primary productivity
function npp(cell)
    local out = 0
    local nppRain = ( 3000 * ( 1 - math.exp( -0.000664 * cell.precip/2)))
    local nppTemp = ( 3000 / ( 1 + math.exp(  1.315000 - (0.119 * cell.temp/10))))
    
    if (nppRain < nppTemp) then out = nppRain
    else out = nppTemp end
    
    if out < 1600 then out = 1600 end
    
    return out
end

-- cell.temp in Celsius??? --> cell.temp - 273? functioniert aber nicht :D