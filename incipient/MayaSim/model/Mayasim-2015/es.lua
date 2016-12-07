require("ag")
require("r")
require("wf")
require("esd")

local testing = false

function es(cell)
    local pAG = 1
    local pR  = 1
    local pWF = 0.1 -- water flow
    local pF  = 1
    
    local out = 0
    out = math.floor((pAG * agF(cell)) + (pR * r(cell)) + (pWF * cell.waterLevel) + (pF * cell.forest) - esd(cell))
    
    -- testing
    if testing then
        print("ag: "..ag(cell))
        print("r: "..r(cell))
        print("wf: "..cell.waterLevel)
        print("forest: "..cell.forest)
        print("out: "..out)
    end
    
    return out
end

function esSum(agent)
    local pAG = 1
    local pR  = 1
    local pWF = 0.1 -- water flow
    local pF  = 1
    for _, croppedCell in pairs(agent.croppedCells) do
        
        out = math.floor((pAG * agF(cell)) + (pR * r(cell)) + (pWF * cell.waterLevel) + (pF * cell.forest) - esd(cell))
        
        -- testing
        if testing then
            print("ag: "..ag(cell))
            print("r: "..r(cell))
            print("wf: "..cell.waterLevel)
            print("forest: "..cell.forest)
            print("out: "..out)
        end
    
        if out < 0 then
            out = 0
        end
    end
    return out
end