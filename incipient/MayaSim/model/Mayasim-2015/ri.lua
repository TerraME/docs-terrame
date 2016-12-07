require("bca")
require("es")
require("tc")
require("ag")

-- real icome per capita
function ri(agent, society, cellSpace)
    local testing = false
    
    -- Functionparameters from original netLogo code
    local pAG = 10-- paraeter agricultural producitvity
    local pES = 1-- paraeter ecosystem services
    local pTR = 10-- parameter for trade costs

    local out = 0
    
    out = ((pAG * bca(agent) + pES * esSum(agent) + pTR * n(agent, society)/tc(agent, cellSpace)) / agent.population) * 20
    
    if out < 0 then
        out = 0
    end
    
    if testing then
        bca1 = pAG * bca(agent)
        es1 = pES * esSum(agent)
        n1 = n(agent, society)
        tc1 = tc(agent, cellSpace)
        
        
        print("bca1: ".. bca1)
        print_r(agent.croppedCells)
        print("es1: ".. es1)
        print("n1: ".. n1)
        print("tc1: ".. tc1)
        print("out1: ".. out)
        print("------------------------------")
    end

    return out
end
