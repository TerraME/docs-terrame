-- calculates distance between current cell and top left corner
function df(cell)
    local distance = 0
    local currentCellX = cell:getX()
    local currentCellY = cell:getY()
    
    local topWestCellX = 1
    local topWestCellY = 1
    
    distance = math.sqrt((currentCellX - topWestCellX)^2 + (currentCellY - topWestCellY)^2)
    return distance
end

-- calculates distance between an agent and a given cell
function dfCells(agent, cell)
    local distance = 0
    
    local cellX = cell:getX()
    local cellY = cell:getY()
    
    local agentX = agent:getCell():getX()
    local agentY = agent:getCell():getY()
    
    distance = math.sqrt((cellX - agentX)^2 + (cellY - agentY)^2)
    return distance
end

-- calculates distance between two agents
function dfAgents(agent1, agent2)
    local distance = 0
    
    local agent1X = agent1:getCell():getX()
    local agent1Y = agent1:getCell():getY()
    
    local agent2X = agent2:getCell():getX()
    local agent2Y = agent2:getCell():getY()
    
    distance = math.sqrt((agent1X - agent2X)^2 + (agent1Y - agent2Y)^2)
    return distance
end

function dfTwoCells(cell1, cell2)
    local distance = 0
    
    local cell1X = cell:getX()
    local cell1Y = cell:getY()
    
    local cell2X = cell:getX()
    local cell2Y = cell:getY()    
    
    distance = math.sqrt((cell1X - cell2X)^2 + (cell1Y - cell2Y)^2)
    return distance
end
