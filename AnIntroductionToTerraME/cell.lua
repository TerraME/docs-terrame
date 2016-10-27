mycell = Cell{
    cover = "forest",
    distRoad = 52,
    distUrban = 28,
    averageDist = function(self)
        return (self.distRoad + self.distUrban) / 2
    end,
    deforest = function(self)
        self.cover = "deforested"
    end
}


print(mycell:averageDist()) -- 40
mycell.distRoad = mycell.distRoad / 2 -- cut the distance to road by half
print(mycell:averageDist()) -- 27

print(mycell.cover) -- "forest"
mycell:deforest()
print(mycell.cover) -- "deforested"

