
require(rgdal)

# past values
shape <- readOGR(dsn = ".", layer = "observadoPLANO_D_SceA_total_pol")
table = shape@data

for(i in c(2005, 2010, 2015))
{
  tabletmp = table
  tabletmp = data.frame(value = tabletmp[,paste("D_Ext", i, sep="")])

  shape@data = tabletmp

  writeOGR(shape, dsn = ".", layer = paste("amazonia_", i, sep=""), driver="ESRI Shapefile", overwrite = TRUE)
}

# future values
for(scenario in c("A", "B", "C1"))
{
  shape <- readOGR(dsn = ".", layer = paste("observadoPLANO_D_Sce", scenario, "_total_pol", sep=""))
  table = shape@data

  for(i in c(2020, 2025, 2030, 2035, 2040))
  {
    tabletmp = table
    tabletmp = data.frame(value = tabletmp[,paste("D_Ext", i, sep="")])
  
    shape@data = tabletmp
  
    writeOGR(shape, dsn = ".", layer = paste("amazonia_", scenario, "_", i, sep=""), driver="ESRI Shapefile", overwrite = TRUE)
  }
}
