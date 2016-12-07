local testing = false

-- Benefit of agricultural yield
function bca(agent)
    -- Functionparameters from original netLogo code
    local k = 1
    local alpha = 1
    local y = 1
    local o = 500
    local ny = 100 -- annual costs for agriculture

    local out = 0
    
    for _, croppedCell in pairs(agent.croppedCells) do
        
        out = out + (k * (alpha * y * croppedCell.ag) - ny ) - ((o * dfCells(agent, croppedCell))/math.log(agent.population))
        
        -- testing
        if testing then
            print("ID: "..croppedCell.id)
            print("AG: "..croppedCell.ag)
            print("df: "..dfCells(agent, croppedCell))
            print("popLog: "..math.log(agent.population))
            print("out: "..out)
        end
    end
    
    if out < 0 then
        out = 0
    end
    
    return out
end