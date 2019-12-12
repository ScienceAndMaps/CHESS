# CHESS data: https://eip.ceh.ac.uk/chess

require("filesstrings")

vars <- c("precip","peti") # choose from: dtr, huss, pet, peti, precip, psurf, rlds, sfcWind, tas
years <- 1986:2005 # choose range
months <- c("01","02","03","04","05","06","07","08","09","10","11","12") # choose months
server <- "http://gds-ldb.nerc-lancaster.ac.uk/thredds" # server location
data_folder <- "CHESS" # folder to put data into (from script location)

wd <- paste0(dirname(rstudioapi::getSourceEditorContext()$path),"/") # if not running in RStudio, set wd to directory of this script, e.g. wd <- 'C:/Dir/'

for (var in vars) {
  
  for (year in years) {
    
    for (month in months) {
      
      if (var=="pet" | var=="peti") {
        file <- paste0("chess_",var,"_wwg_",year,month,".nc")
        url <- paste0(server,"/fileServer/",toupper(var),"Detail02/",file)
      } else {
        file <- paste0("chess_",var,"_",year,month,".nc")
        url <- paste0(server,"/fileServer/public-CHESSDrivingData",var,"Detail02/",file)
      }
      path1 <- tempfile(fileext = ".nc") # create temp file
      download.file(url, path1, mode="wb") # download
      file.rename(path1,paste0(dirname(path1),"/",file)) # rename
      newpath <- paste0(dirname(path1),"/",file) # path to wd / file
      file.move(newpath, paste0(wd,data_folder)) # move to path
      
    }
    
  }
  
}
