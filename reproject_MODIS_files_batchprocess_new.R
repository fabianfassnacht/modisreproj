require(rts)
require(MODIS)

long2UTM <- function(long) {
  (floor((long + 180)/6) %% 60) + 1
}


setwd("E:/KIT_Forschung/21_Annika_Masterarbeit/MODIS_Tibet/selected")
lut <- read.table("modis_latitudes.txt", sep="", header=T)
mod <- list.files(pattern=".hdf")

i=1

for(i in 1:length(mod)){

  hdfName <- mod[i]
  filen <- strsplit(hdfName, ".hdf")
  filen2 <- paste(filen, "_UTM.tif", sep="")
  
  get_utm <- strsplit(filen2, ".h")
  get_utm2 <- as.character(get_utm[[1]][2])
  get_utm3 <- substr(get_utm2, 1, 2)
  get_utm4 <- substr(get_utm2, 4, 5)
  
  get_utm_h <- as.numeric(get_utm3)
  get_utm_v <- as.numeric(get_utm4)
  
  lut1 <- lut[lut$ih == get_utm_h,]
  lut2 <- lut1[lut1$iv == get_utm_v,]
  
  long_f <- (lut2[,4] + lut2[,3])/2
  
  MRTpath = "F:/MODISSoft/bin"
  utm_1 <- long2UTM(long_f)
  utm_z <- paste("+", utm_1, sep="")
  
  reprojectHDF(hdfName, filen2, MRTpath, bands_subset = "0 1 1 0 0 0 0 0 0 0 0 1", resample_type="NEAREST_NEIGHBOR", proj_type="UTM", proj_params = "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0" ,datum='WGS84', utm_zone=utm_z, pixel_size="250")
  
}


# 
# #import packages
# library(foreach)
# library(doParallel)
# 
# #setup parallel backend to use 8 processors
# cl<-makeCluster(4)
# registerDoParallel(cl)
# 
# i=1
# 
# #loop
# system.time(
#   test <- foreach(i = 1:length(mod), .packages=c("rts")) %dopar% {
# 
#     hdfName <- mod[i]
#     filen <- strsplit(hdfName, ".hdf")
#     filen2 <- paste(filen, "_UTM.tif", sep="")
#     
#     get_utm <- strsplit(filen2, ".h")
#     get_utm2 <- as.character(get_utm[[1]][2])
#     get_utm3 <- substr(get_utm2, 1, 2)
#     get_utm4 <- substr(get_utm2, 4, 5)
#     
#     get_utm_h <- as.numeric(get_utm3)
#     get_utm_v <- as.numeric(get_utm4)
#     
#     lut1 <- lut[lut$ih == get_utm_h,]
#     lut2 <- lut1[lut1$iv == get_utm_v,]
#     
#     long_f <- (lut2[,4] + lut2[,3])/2
#     
#     MRTpath = "F:/MODISSoft/bin"
#     utm_1 <- long2UTM(long_f)
#     utm_z <- paste("+", utm_1, sep="")
# 
#     reprojectHDF(hdfName, filen2, MRTpath, bands_subset = "0 1 1 0 0 0 0 0 0 0 0 1", resample_type="NEAREST_NEIGHBOR", proj_type="UTM", proj_params = "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0" ,datum='WGS84', utm_zone=utm_z, pixel_size="250")
# 
#   }
# )
# 
# stopCluster(cl)
