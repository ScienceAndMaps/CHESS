# Precipitation data from: https://catalogue.ceh.ac.uk/documents/b745e7b1-626c-4ccc-ac27-56582e77b900
# PET data from: https://catalogue.ceh.ac.uk/documents/931357be-7a5d-496a-a3db-5c89c3080d30

require(ncdf4)
require(raster)

years <- 2006:2015 # choose your range

wd <- paste0(dirname(rstudioapi::getSourceEditorContext()$path),"/") # if not running in RStudio, set wd to directory of this script, e.g. wd <- 'C:/Dir/'

if (!dir.exists(paste0(wd,"Outputs"))) {dir.create(paste0(wd,"Outputs"))}

for (year in years) {
  
  pet <- list.files(paste0(wd,"GIS_Data/CHESS/"),pattern = paste0("peti_wwg_",year))
  prec <- list.files(paste0(wd,"GIS_Data/CHESS/"),pattern = paste0("precip_",year))
  
  for (i in 1:length(prec)) {
    
    prec_month <- stack(paste0(wd,"GIS_Data/CHESS/",prec[i]))
    prec_month <- prec_month*86400 # convert from kg/m2/s to mm/day
    pet_month <- stack(paste0(wd,"GIS_Data/CHESS/",pet[i]))
    
    for (j in 1:nlayers(prec_month)) {
      
      eff_rain_day <- prec_month[[j]] - pet_month[[j]]
      if (i+j==2) {daily_sums <- eff_rain_day}
      daily_sums <- daily_sums + eff_rain_day
      daily_sums[daily_sums<0] <- 0
      print(paste0(year, "-", i,"-",j))
    }
    
  }
  
writeRaster(daily_sums,paste0(wd,"Outputs/","CHESS_eff_rain_",year,".tif"))
  
}
