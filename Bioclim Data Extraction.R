####Extracting Bioclim data for all species####
#Aims:
##form a list of species
#extract mean range data for the bioclim variables (can choose which ones to use later maybe?)
##store the values in one csv file
##combine values with trait data (get values for individual locations)
#
#######
#make a function that gets individual data from each species then adds it to an existing csv file???
#######

#getting bioclim data
#load raster, sp, stats, utils
#in order to access the raster both the .bil and .hdr files need to be in the working directory

#move working directory
#saveto <- "/Users/lloydg/Documents/Kerkhoff Lab/Phytolaccoids/BioClim"
#setwd(saveto)
bios <-getData ("worldclim", var = "bio", res = 2.5) 


##Getting species used in seed data
seed.species <- seed_data[4]
seed.species <- unique(seed.species)

#getting shape files for species in a list
#list in this case is seed.species
phyto.species <- function() {
  saveto <- "/Users/lloydg/Documents/Kerkhoff Lab/Phytolaccoids/Shape Files"
  setwd(saveto)
  BIEN.ranges.species(seed.species[1], saveto)
  readShapePoly(seed.species[1])
}
phyto.species()


####function for getting data from shape files####
#load package rgeos, rgdal, maptools, and maps
saveto <- "/Users/lloydg/Documents/Kerkhoff Lab/Phytolaccoids/Shape Files"
setwd(saveto)

get.bioclim <- function() {
  #enter the species you want extract (make sure its in your working directory!)
  plant="Rivina_humilis"
  plant_poly <- readShapePoly(plant)
  plant_range <- extract(bios, plant_poly, fun='mean', na.rm=TRUE)
  View(plant_range)
  write.csv(plant_range, file="Rivina_humilis.csv")
}
get.bioclim()
#add in taxon column so that they can be merged later


#load dplr
#combine 2 species csv files
range.bioclim=bind_rows(Abronia_latifolia, Abronia_pogonantha)
#just change the species as needed until all combined
range.bioclim=bind_rows(range.bioclim, Rivina_humilis)

#adjust to usable value ranges
#use https://github.com/eightysteele/Spatial-Data-Library/issues/20 to get adjustment values
range.bioclim[2]=range.bioclim[2]/10
range.bioclim[3]=range.bioclim[3]/10
range.bioclim[4]=range.bioclim[4]/100
range.bioclim[5]=range.bioclim[5]/100
range.bioclim[6]=range.bioclim[6]/10
range.bioclim[7]=range.bioclim[7]/10
range.bioclim[8]=range.bioclim[8]/10
range.bioclim[9]=range.bioclim[9]/10
range.bioclim[10]=range.bioclim[10]/10
range.bioclim[11]=range.bioclim[11]/10
range.bioclim[12]=range.bioclim[12]/10

write.csv(range.bioclim, file="seedbioclimdata.csv")

#merge seed data and bioclim data
library(dplyr)
seed_geo_values <- full_join(seed_data, seedbioclimdata, by="taxon")
View(seed_geo_values)
seed_geo_values



##########################################################################

#Getting Geographic Data from the plants present
row.add <- function(x,newRow)
{
  cn <- colnames(x)
  x <- data.frame(lapply(x,as.character),stringsAsFactors = FALSE)
  x <- rbind(x,newRow)
  colnames(x) <- cn
  return(x)
}

library(rgdal)
library(rgeos)
library(maptools)

#all_species <- BIEN.list.all()
all_species <- c("PLACE PLANT NAME HERE", "PLACE PLANT NAME HERE")

#choose where you want the shape files to be placed
wd <- setwd("PLACE PATHWAY HERE")
range_poly_download_vector = BIEN.ranges.species(all_species, wd)

##################################################

#Getting Bioclim Variables

#download bioclim variables from worldclim.org
#make sure your working directory is where the bioclim data is present
wd <- setwd("PLACE PATHWAY HERE")

bio_1 = raster("bio_1.bil")
bio_2 = raster("bio_2.bil")
bio_3 = raster("bio_3.bil")
bio_4 = raster("bio_4.bil")
bio_5 = raster("bio_5.bil")
bio_6 = raster("bio_6.bil")
bio_7 = raster("bio_7.bil")
bio_8 = raster("bio_8.bil")
bio_9 = raster("bio_9.bil")
bio_10 = raster("bio_10.bil")
bio_11 = raster("bio_11.bil")
bio_12 = raster("bio_12.bil")
bio_13 = raster("bio_13.bil")
bio_14 = raster("bio_14.bil")
bio_15 = raster("bio_15.bil")
bio_16 = raster("bio_16.bil")
bio_17 = raster("bio_17.bil")
bio_18 = raster("bio_18.bil")
bio_19 = raster("bio_19.bil")
raster_vector <- c(bio_1, bio_2, bio_3, bio_4, bio_5, bio_6, bio_7, bio_8, bio_9, bio_10, bio_11, bio_12, bio_13, bio_14, bio_15, bio_16, bio_17, bio_18, bio_19)
df <- data.frame(Species = character(), Bio1 = double(), Bio2 = double(), Bio3 = double(), Bio4 = double(), Bio5 = double(), Bio6 = double(), Bio7 = double(), Bio8 = double(), Bio9 = double(), Bio10 = double(), Bio11 = double(), Bio12 = double(), Bio13 = double(), Bio14 = double(), Bio15 = double(), Bio16 = double(), Bio17 = double(), Bio18 = double(), Bio19 = double())

library(raster)
#this will literally take forever omg like let this run and do something else
#you should only have to do this once though
raster_brick <- brick(raster_vector)

current_dir = wd
#make sure this is actually where your shape files are!!!!

#this will also take forever
#query databse for range polygons for each species
for(i in 1:length(all_species)) {
  #get range polygon
  path = paste0(current_dir, "/", all_species[i], ".shp")
  range_poly<-readShapePoly(path)
  #get mean
  temp_brick <- crop(raster_brick, range_poly)
  data = cellStats(temp_brick, 'mean')
  #build data entry
  row <- c(all_species[i], data)
  #add data to dataframe
  df <- row.add(df, row)
}

#kk the bioclim variables suck so you're gonna have to adjust them
#use https://github.com/eightysteele/Spatial-Data-Library/issues/20 to get adjustment values
#these might be right just make sure that bio1 is the 3rd column before you run it?
df[3]=df[3]/10
df[4]=df[4]/10
df[5]=df[5]/100
df[6]=df[6]/100
df[7]=df[7]/10
df[8]=df[8]/10
df[9]=df[9]/10
df[10]=df[10]/10
df[11]=df[11]/10
df[12]=df[12]/10
df[13]=df[13]/10

#this will be saved with all your shape files and then you can play with it yayayayay
write.csv(df, file = "all_species_range_data.csv")