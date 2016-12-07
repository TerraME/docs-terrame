require("explodeString")
require("print_r")

local soil = {}
local dem = {}
local precip = {}
local temp = {}
local slope = {}
local order = {}

local soilOut = {{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}}
local demOut = {{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}}
local precipOut = {{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}}
local tempOut = {{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}}
local slopeOut = {{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}}

-- read data from .asc files into lua tables
function loadData(filename)
    io.write("Reading "..filename.." started...")
    local file = io.open("../data/".. filename ..".asc")
    local readOn = true
    local count = 1
    while(readOn) do
        local line = file:read("*line")
        if line == nil then 
            readOn = false 
        else
            if     filename == "dem"    then dem[count]    = explode(" ", line) 
            elseif filename == "temp"   then temp[count]   = explode(" ", line)
            elseif filename == "soil"   then soil[count]   = explode(" ", line)
            elseif filename == "precip" then precip[count] = explode(" ", line)
            elseif filename == "slope"  then slope[count]  = explode(" ", line)
            elseif filename == "order"  then order[count]  = explode(" ", line) end
            count = count + 1
        end  
    end
    
    if     filename == "dem"    then
        for i=10, 974, 10 do
            io.write(".")
            for j=10, 896, 10 do
                demOut[i/10][j/10] = dem[i][j]
            end
        end
    elseif filename == "temp"   then
        for i=10, 974, 10 do
            io.write(".")
            for j=10, 896, 10 do
                tempOut[i/10][j/10] = temp[i][j]
            end
        end
    elseif filename == "soil"   then
        for i=10, 974, 10 do
            io.write(".")
            for j=10, 896, 10 do
                soilOut[i/10][j/10] = soil[i][j]
            end
        end
    elseif filename == "precip"   then
        for i=10, 974, 10 do
            io.write(".")
            for j=10, 896, 10 do
                precipOut[i/10][j/10] = precip[i][j]
            end
        end
    elseif filename == "slope"   then
        for i=10, 974, 10 do
            io.write(".")
            for j=10, 896, 10 do
                slopeOut[i/10][j/10] = slope[i][j]
            end
        end
    end
    
    if     filename == "dem"    then print("\nReading dem finished!")return demOut
    elseif filename == "temp"   then print("\nReading temp finished!")return tempOut
    elseif filename == "soil"   then print("\nReading soil finished!")return soilOut
    elseif filename == "precip" then print("\nReading precip finished!")return precipOut
    elseif filename == "slope"  then print("\nReading slope finished!")return slopeOut 
    elseif filename == "order"  then print("\nReading order finished!")return order end
end