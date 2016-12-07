require("print_r")

function addInitalCrop(agent, Cellspace)
    local agentCell = agent:getCell()
    local noCropps = true
    
    forEachNeighbor(agentCell, function(agentCell, neighbor)
        neighbor.forest = 2
        if next(neighbor.relate) == nil and neighbor.soil ~= -9999 and noCropps and neighbor.color == 0 then
            table.insert(neighbor.relate, agent) -- table shows to which agent a cropped cell is related
            table.insert(agent.croppedCells, neighbor) -- table shows all cells which are related to the agent
            neighbor.forest = 3
            noCropps = false
            neighbor.color = 80
            return true
        end
    end)
 
    if noCropps then
        killVillage(agent)
        return false
    end
end

function addCropp(agent, Cellspace)
    local agentCell = agent:getCell()
    local noNewCropps = true
    
    if noNewCropps then
        forEachCell(Cellspace, function(neighbor)
            if next(neighbor.relate) == nil and neighbor.soil ~= -9999 and neighbor.color == 0 and noNewCropps and dfCells(agent, neighbor) < 1.5 then
                table.insert(neighbor.relate, agent) -- table shows to which agent a cropped cell is related
                table.insert(agent.croppedCells, neighbor) -- table shows all cells which are related to the agent
                neighbor.forest = 3
                noNewCropps = false
                neighbor.color = 80
            end
        end)
    end
    
    if noNewCropps then
        forEachCell(Cellspace, function(neighbor)
            if next(neighbor.relate) == nil and neighbor.soil ~= -9999 and neighbor.color == 0 and noNewCropps and dfCells(agent, neighbor) < 2.5 then
                table.insert(neighbor.relate, agent) -- table shows to which agent a cropped cell is related
                table.insert(agent.croppedCells, neighbor) -- table shows all cells which are related to the agent
                neighbor.forest = 3
                noNewCropps = false
                neighbor.color = 80
            end
        end)
    end
    
    if noNewCropps then
        forEachCell(Cellspace, function(neighbor)
            if next(neighbor.relate) == nil and neighbor.soil ~= -9999 and neighbor.color == 0 and noNewCropps and dfCells(agent, neighbor) < 3.5 then
                table.insert(neighbor.relate, agent) -- table shows to which agent a cropped cell is related
                table.insert(agent.croppedCells, neighbor) -- table shows all cells which are related to the agent
                neighbor.forest = 3
                noNewCropps = false
                neighbor.color = 80
            end
        end)
    end


    if noNewCropps then
        return false
    end
end

function leaveCropp(agent)
    


end