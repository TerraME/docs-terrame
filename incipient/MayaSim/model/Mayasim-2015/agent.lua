require("print_r")
-- birthRate fixed at 15%
-- deathRate connected to Real income per capita () ri.lua
-- migrationRate connected to Real income per capita () ri.lua

function popChange(agent)
    
    local testing = false
    agent.age = agent.age + 1
    -- birth rate based on static value from paper   
    local birthRate = agent.birthRate
    -- death rate based on real income per capita max 0.25 at ri = 1 and 0.05 at ri > 1000
    local deathRate = 1 - (0.250029 - 0.00028575510787255317 * agent.ri)
    -- migration rate based on real income per capita max 0.15 at ri = 1 and 0.05 at ri > 1000
    local migrationRate = 1 - (0.150014 - 0.00014287755393627663 * agent.ri)
    
    if deathRate > 1 then
        deathRate = 0.95
    end
    
    if migrationRate > 1 then
        migrationRate = 0.99
    end

    if agent.age > 80 and agent.birthRate == 1.2 then
        agent.birthRate = 1.05
    end
        
    local out = agent.population
    out = math.floor(out * birthRate * deathRate * migrationRate)
    
    if testing then
        print("Before: " .. agent.population)
        print("After: " .. out)
        print("Birth: " .. birthRate)
        print("Death: " .. deathRate)
        print("Migration: " .. migrationRate)
        print("Income: " .. agent.ri)
        print("----------------------------------")
    end
    
    return out
end

-- delete Villages without population
function killVillage(agent)
    if agent.population < 10 then
        for _, cropp in pairs(agent.croppedCells) do
            cropp.forest = 2
            cropp.color = 0
            cropp.relate = {}
        end
        
        local cell = agent:getCell()
        cell.color = 0
        cell.forest = 2
        agent:die()
    end
end