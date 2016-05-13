row.add <- function(x,newRow)
{
  cn <- colnames(x)
  x <- data.frame(lapply(x,as.character),stringsAsFactors = FALSE)
  x <- rbind(x,newRow)
  colnames(x) <- cn
  
  return(x)
}

start=proc.time()
wd = setwd("C:/Users/lloydg/Documents/Phytolaccoid things")
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

proc.time()-start

#Want average bioclim data for every species
#make a dataframe
#species .. bio1.. bio2.. ... bio18
#...

library(KerkhoffLab)
library(raster)

#initialize dataframe species and raster layers
#Want more than species for name
df <- data.frame(Species = character(), Bio1 = double(), Bio2 = double(), Bio3 = double(), Bio4 = double(), Bio5 = double(), Bio6 = double(), Bio7 = double(), Bio8 = double(), Bio9 = double(), Bio10 = double(), Bio11 = double(), Bio12 = double(), Bio13 = double(), Bio14 = double(), Bio15 = double(), Bio16 = double(), Bio17 = double(), Bio18 = double(), Bio19 = double())
#df <- data.frame(Species = character(), BioClim1 = double(), BioClim2 = double())

#create a vector listing all species in BIEN database
#all_species <- BIEN.list.all()
#all_species <- c("Abronia_maritima", "Allionia_hirsuta", "Mirabilis_californica", "Neea_hermaphrodita", "Neea_krukovii", "Neea_madeirana", "Neea_obovata", "Neea_oppositifolia", "Neea_ovalifolia", "Neea_psychotrioides", "Neea_tristis", "Pisonia_grandis", "Misonia_macranthoca", "Pisonia_rotundata", "Pisonia_subcordata", "Pisonia_umbellifera", "Pisonia_zapallo", "Ramisia_brasiliensis", "Seguieria_langsdorff")
all_species <- c("Neea_hermaphrodita", "Neea_madeirana", "Neea_obovata", "Neea_ovalifolia", "Neea_psychotrioides", "Neea_tristis",  "Pisonia_zapallo", "Ramisia_brasiliensis")

#Assume all desired raster layers are in the following vector
#it's normal to take a long-ass time
raster_brick <- brick(raster_vector)


library(RPostgreSQL)
library(rgdal)
library(rgeos)
library(maptools)

#get all ranges
range_poly_download_vector = BIEN.ranges.species(all_species, wd)


#get working directory for reuse
current_dir = getwd()
#make sure this is actually where your shape files are!!!!

#instead of the other for loop:
#create dataframe/MATRIX? as seen above
#query databse for range polygons for each species
for(i in 1:length(all_species)) {
  #get range polygon
  path = paste0(current_dir, "/", all_species[i], ".shp")
  range_poly<-readShapePoly(path)
  
  #get mean
  #data <- lapply(data_values, FUN = mean)
  #ALTERNATIVELY... Thoughts?
  temp_brick <- crop(raster_brick, range_poly)
  data = cellStats(temp_brick, 'mean')
  
  #build data entry
  row <- c(all_species[i], data)

  #add data to dataframe
  df <- row.add(df, row)
}

write.csv(df, file = "all_species_range_data.csv")
