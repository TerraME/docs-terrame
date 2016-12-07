require("print_r")

-- migrate to a new village
function migrate(agent, cellspace)
    if agent.population > 80 and agent.age > 10 then
        -- get all possible cells that could host the agent
        local suit_cells = Trajectory { 
                    target = cellspace, 
                    select = function(cell) 
                        return cell.es >= 1000 and cell.waterLevel < 1500 
                               and cell.soil > 3 and math.abs(cell.slope) < 150 
                               and cell.color ~= 80 and cell.color ~= 2
                    end
        }
        -- are there suitable cells?
        if (suit_cells:size() > 0 ) then
            local newplace = suit_cells:sample()
            local child = agent:reproduce()
            child.population = math.floor(agent.population / 2)
            agent.population = math.floor(agent.population / 2)
            
            --decrease birthrate as potentially more young people leave the village
            agent.birthRate = 1.01
            child:move (newplace)
            newplace.color = 2
            local notDied = addInitalCrop(child, cellspace)
            if notDied then
                addCropp(child, cellspace)
                addCropp(child, cellspace)
            end
            cellspace:notify()
        end
    end
end