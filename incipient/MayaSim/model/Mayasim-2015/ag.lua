require("npp")
require("sp")
require("s")
require("wf")
require("sd")

local testing = false

-- Agricultural productivity function
function agF(cell)
    -- Functionparameters from original netLogo code
    local pNPP = 0.05 -- Net primary productivity
    local pSP = 100    -- Soil productivity [index 1 - 100]
    local pS = 0.02  -- Slope in %
    local pWF = 0.1   -- water flow

    local out = 0
    out = (pNPP * npp(cell)) + (pSP * sp(cell)) - (pS * s(cell)) - (pWF * cell.waterLevel)
    
    -- testing
    if testing then
        print("npp: "..npp(cell))
        print("SP: "..sp(cell))
        print("s: "..s(cell))
        print("wf: "..cell.waterLevel)
        print("sd: "..sd(cell))
        print("out: "..out)
    end
    
    return out
end