-- travel costs for trading
function tc(agent, cellSpace)
    local testing = false 
    local pWF = 0-- Waterflow multiplikator
    local pS  = 0-- Slope multiplicator
    
    local totalCells = 0
    local totalSlope = 0
    local totalFlow = 0
    
    local out = 0 -- overall travell costs
    
    for _, agentNet in pairs(agent.network) do
        
        function calc(travelCell)
            if travelCell.waterLevel ~= -9999 then
                totalCells = totalCells + 1
                totalSlope = totalSlope + math.abs(travelCell.slope)
                totalFlow = totalFlow + travelCell.waterLevel
            end
            if testing then cellSpace:getCell(Coord { x = cellX, y = cellY }).color = 70 end 
            -- mark cells as travelled if testing is enabled
        end
        
            

        local cellX = agent:getCell():getX()
        local cellY = agent:getCell():getY()
        
        local netX = agentNet:getCell():getX()
        local netY = agentNet:getCell():getY()
        
        if cellX > netX then
            while cellX > netX do
                cellX = cellX - 1
                travelCell = cellSpace:getCell(Coord { x = cellX, y = cellY })
                calc(travelCell)
            end
            
            if cellY > netY then
                while cellY > netY do
                    cellY = cellY - 1
                    travelCell = cellSpace:getCell(Coord { x = cellX, y = cellY })
                    calc(travelCell)
                end
                
            elseif cellY < netY then
                while cellY < netY do
                    cellY = cellY + 1
                    travelCell = cellSpace:getCell(Coord { x = cellX, y = cellY })
                    calc(travelCell)
                end
                
            elseif cellY == netY then
                -- Destination cell is reached already
            end
            
            -- set values for cell to initial to not run into elseif
            cellX = agent:getCell():getX()
            cellY = agent:getCell():getY()
            
        elseif cellX < netX then
            while cellX < netX do
                cellX = cellX + 1
                travelCell = cellSpace:getCell(Coord { x = cellX, y = cellY })
                calc(travelCell)
            end
            
            if cellY > netY then
                while cellY > netY do
                    cellY = cellY - 1
                    travelCell = cellSpace:getCell(Coord { x = cellX, y = cellY })
                    calc(travelCell)
                end
            
            elseif cellY < netY then
                while cellY < netY do
                    cellY = cellY + 1
                    travelCell = cellSpace:getCell(Coord { x = cellX, y = cellY })
                    calc(travelCell)
                end
            
            elseif cellY == netY then
                -- Destination cell is reached already
            end
            
            -- set values for cell to initial to not run into elseif
            cellX = agent:getCell():getX()
            cellY = agent:getCell():getY()
            
        elseif cellX == netX then
            if cellY > netY then
                while cellY > netY do
                    cellY = cellY - 1
                    travelCell = cellSpace:getCell(Coord { x = cellX, y = cellY })
                    calc(travelCell)
                end
                
             
            elseif cellY < netY then
                while cellY < netY do
                    cellY = cellY + 1
                    travelCell = cellSpace:getCell(Coord { x = cellX, y = cellY })
                    calc(travelCell)
                end
            end
        end
    end    
    
    
    totalSlope = math.abs(totalSlope)
    totalFlow = math.abs(totalFlow)
    
    pS = 2
    pWF = 0.01
    
    out = (pS * totalSlope - pWF * totalFlow)
    
    if next(agent.network) ~= nil then
        if out < 0 then
            out = 1
        end
        
        if testing then
            print("Slope: "..totalSlope)
            print("water: "..totalFlow)
            print("Cells: "..totalCells)
            print("Out: "..out)
        end
        
        return out
    end
    return 1
end
