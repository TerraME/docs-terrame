require("df")

-- calcualte networksize for an agent --> get number of agent in specified radius
function n(agent, society)
    local testing = false
    local maxTradeDistance = 10
    agent.network = {}
    local out = 0
    
    forEachAgent(society, function(agentNet)
        if agent ~= agentNet then
            
            if testing then
                print("AgentX: ".. agent:getCell():getX())
                print("AgentY: ".. agent:getCell():getY())
                print("NetX: ".. agentNet:getCell():getX())
                print("NetY: ".. agentNet:getCell():getY())
                print("Distance: ".. dfAgents(agent, agentNet)) 
            end
            
            if dfAgents(agent, agentNet) < maxTradeDistance then
                table.insert(agent.network, agentNet)
                out = out + 1
            end
        end
    end)
    
    return out -- return for other functions returns number of connections
end
