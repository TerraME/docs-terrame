tmepath = os.getenv("TME_PATH_1_3_0")
package.path = package.path .. ";"..tmepath.."/contrib/courselib/?.lua;"

require("loadData")
require("es")
require("npp")
require("r")
require("ag")
require("addCrop")
require("bca")
require("n")
require("migrate")
require("forest")
require("agent")
require("ri")
require("drain")
require("evaporation")
require("sd")
require("step")
abm  = require ("abm")
ca   = require ("ca")
laux = require ("laux")
colorbar = require("colorbar")

-- load basis data 
local soilData = loadData("soil")
local demData = loadData("dem")
local orderData = loadData("order") -- contains an order based on the elevation starting with highest point on map
local precipData = loadData("precip")
local tempData = loadData("temp")
local slopeData = loadData("slope")

-- Basic parameters 
local YDIM = #soilData
local XDIM = #soilData[1]
local step = 0

mayasim = abm.Model {
    -- define a cell space
    cells = CellularSpace {
        xdim = XDIM,
        ydim = YDIM,
        neighborhood = {
            strategy = "moore",
            self     = false,
            wrap     = false
        },
        instance = {es = 0, color = 0, soil = 0, forest = 0}
    },
        
    -- define our agents
    
    society = Society {
            instance = Agent {
                init = function (self)   -- called once when the agent is created
                    self.population = 100
                    self.croppedCells = {}
                    self.bca = 0
                    self.network = {}
                    self.ri = 0
                    self.birthRate = 1.2
                    self.age = 0
                end
            },
            quantity = 50,
            placement = "random",
            max_agents_per_cell = 1
        },
        
    
    init =  function (mayasim)
    end,
    
    changes = function (mayasim)
        -- initial conditions based on model assumptions
        if step == 0 then
            -- generate initial model conditions
            forEachCell(mayasim.cells, function(cell)
                -- get coordinates from current cell to find slot in data tables
                local x = cell:getX() + 1
                local y = cell:getY() + 1
                
                -- store data into each cell
                cell.soil = tonumber(soilData[y][x])
                cell.initSoil = tonumber(soilData[y][x])
                cell.dem = tonumber(demData[y][x])
                cell.temp = tonumber(tempData[y][x])
                cell.initPrecip = tonumber(precipData[y][x])
                cell.precip = tonumber(precipData[y][x])
                cell.slope = tonumber(slopeData[y][x])
                cell.color = 0 -- is there an agent?
                cell.relate = {} -- if cropped show which agents uses it
                cell.notDisturbed = 0
                
                -- store additional/calculated information
                cell.step = 0
                cell.waterLevel = 0
                if cell.initPrecip ~= -9999 then 
                    cell.forest = 1
                    cell.npp = 0
                    cell.ag = 0
                    cell.es = 0
                else 
                    cell.forest = -9999 
                    cell.npp = -9999 
                    cell.ag = -9999 
                    cell.es = -9999 
                end
                
                cell:notify()
            end)
            
           initalForestDisturbance(mayasim.cells)
        end
        
        if step == 3 then
            io.write("Start placing inital Mayavillages")
            forEachAgent(mayasim.society, function(agent)
                found = false
                while not found do
                    cell = mayasim.cells:sample()
                    if(cell.es >= 1000 and cell.waterLevel < 1500 and cell.soil > 3 and math.abs(cell.slope) < 150 and cell.color ~= 80 and cell.color ~= 2) then
                        agent:move(cell, "placement")
                        io.write(".")
                        found = true -- if found suitable position
                        addInitalCrop(agent, mayasim.cells)
                        cell.color = 2
                    end
                end
            end)
            print("\nPlacing initial Mayavillages finished!")
        end
        
        forEachCell(mayasim.cells, function(cell)
            -- Update current step for each cell
            stepCell(cell)
            
            if cell.soil ~= -9999 then 
                -- Soil degredation for each time step 5% if cropped
                sd(cell)
                
                -- Update current npp for each cell
                cell.npp = npp(cell)
                
                -- Update current ag for each cell
                cell.ag = agF(cell)
                
                -- Let it rain to get current waterlevel values (stored in r.lua)
                rWaterLevel(cell)
                
                -- Calcualte ecosystem services
                cell.es = es(cell)
                
                -- Update WaterLevel accoring to drain
                drain(cell)
                
                -- Update WaterLevel accoring to evaporation
                evaporation(cell)
                
                -- forest regeneration if not disturbed
                forestRegeneration(cell)
            end
        end)
        
        if step > 3 then
            forEachAgent(mayasim.society, function(agent)
                -- migrate if overpopulated
                migrate(agent, mayasim.cells)
                
                -- Calculate population change
                agent.population = popChange(agent)
                
                -- Calculate benefit of agricultural yield
                agent.bca = bca(agent)
                
                -- Calculate network size
                n(agent, mayasim.society)
                
                -- Calculate real income per capita
                agent.ri = ri(agent, mayasim.society, mayasim.cells)
                
                -- Forest disturbance based on agents
                forestDisturbance(agent, mayasim.cells)
                
                if agent.ri < 1000 then
                    addCropp(agent, mayasim.cells)
                end
                
                if agent.ri > 1000 then
                    leaveCropp(agent, mayasim.cells)
                end
                
                -- color new villages
                agent:getCell().color = 2
                
                -- village gets erased if not enough people life there
                killVillage(agent)
            end)
        end
        
        -- Let water flow to neighbor cells if necessary
        -- just called once as a specific order is needed, which is realized internally by the "order"-parameter in the function wf(cellSpace, order)
        wf(mayasim.cells, orderData)
        
        if step > 140 then
            forEachAgent(mayasim.society, function(agent)
                 agent.birthRate = 1
             end)
         end
        
        step = step + 1
        print("Society Size: " .. mayasim.society:size())
        print("Model Step: " .. step)
        mayasim.cells:notify()
    end  
}

require("observer")

mayasim:run(600)


