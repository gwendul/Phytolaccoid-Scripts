###Phytolaccoid Project###
#Goals: Collecting information about traits over area and climate

################################################################################################

#Creating allspecies_alltraits datasheet#

##Getting Data from BIEN######################################
source('your/working/directory/BIEN_public_API.R')

#These three families are the Phytolaccoids
family_vector<-c("Phytolaccaceae", "Sarcobataceae", "Nyctaginaceae")
#Getting a list of species
family_loc_data <- BIEN.gis.family(family_vector)
species_vector = unique(family_loc_data[2])
species_vector = na.omit(species_vector)
#View(species_vector) #These are the species

#Getting trait values for these species 
##trait_vector contains all traits from BIEN
trait_vector <- c("trait_name", "Area-based photosynthesis (Aarea)", "Flowering date", "Flowering month", "Height", "Leaf area", "Leaf Cmass", "Leaf dry mass", "Leaf dry matter content (LDMC)", "Leaf Narea", "Leaf Nmass", "Leaf Parea", "Leaf Pmass", "Mass-based photosynthesis (Amass)", "seed mass", "Specific leaf area (SLA)", "Stomatal conductance (Gs)", "wood density")
trait_data <- BIEN.trait.traitbyspecies(trait = trait_vector, species = species_vector[,1])

#Data Clean-up
##traits from BIEN are all listed together in a single column, separating them makes them usable
library(tidyr)
trait.spread=spread(trait_data, trait_name, trait_value)

#optional: removing extra columns that you don't want to use:
##trait.spread$intraspecific_rank <- NULL
##trait.spread$varsubsp <- NULL

##Growthform Data#########################################
#Growth form data was manually imported into a csv file from USDA.gov and from BIEN

#Growthform data from BIEN
##import Growthform_Final.csv (found on Kerkhoff Lab Google Drive)

#get a list of species which you want to look at the trait data
##if you already have one these steps aren't necessary
#specieslist <- allspecies_alltraits[4]
#specieslist= unique(specieslist)

#Get the Growthform data for a particular list of species
BIENgrowthform <- merge(specieslist, Growthform_Final, by="taxon", by.y= "LATIN")

#There will be other things in the data sheet, you can remove them if you don't want excess columns 
#BIENgrowthform$FAMILY <- NULL
#BIENgrowthform$GENUS <- NULL
#BIENgrowthform$SPECIES <- NULL
#BIENgrowthform$ID <- NULL
#BIENgrowthform$X <- NULL
#BIENgrowthform$X.1 <- NULL
#BIENgrowthform$X.2 <- NULL
#BIENgrowthform$SOURCES <- NULL
#BIENgrowthform$CONSENSUS <- NULL

#attach this trait to the already existing datasheet
allspecies_alltraits <- merge(allspecies_alltraits, BIENgrowthform, by="taxon")

##USDA traits are duration and growth.type, both were manually imported
##BIEN growthform traits are the column GROWTHFORM

##Getting Bioclim Variables###############################

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

#The Bioclim variables are multiplied by 10 because decimals are larger than integers so adjust them before doing any statistics
#Adjustment variables came from https://github.com/eightysteele/Spatial-Data-Library/issues/20
#These should be right just make sure that bio1 is the 3rd column before you run it?
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

#if you want to save this as a csv file
#write.csv(df, file = "bioclim_rangedata.csv")

#add this to the already existing datasheet
allspecies_alltraits=merge(trait.spread, df, by="taxon")

### if needed rename things with this!!
##names(dataset)[names(dataset)=="original column name"] <- "new column name"

#####################################################################################################

#Maps and Other Geographic Things#

##Extracting Geographic Data###########################
#All examples use Rivina humilis
library(rgeos)
library(rgdal)
library(maptools)

#You should have these range polygons if you extracted Bioclim data but if you can do this if you need them
#this and later commands grab shapes from your working directory, so make sure that they are there
BIEN.ranges.species(species_vector)
BIEN.ranges.species("Rivina humilis")

#Reading shape files
poly <- readShapePoly("Rivina_humilis")

#Plotting shape files###################################
map('world', fill = TRUE, col = "grey") #plots a world map (WGS84 projection), in forest grey
plot(poly,col="forest green",add=TRUE)

#plotting points on Google Maps
library(Rgooglemaps)
library(stats)
library(scales)
library(graphics)

df <- data.frame(latitude=double(), longitude=double(), color=character(), name=character())
for (i in 1:length(vector)) {
  vector <- BIEN.gis.species("Rivina humilis")
  tmp <- vector[2:3]
  tmp = na.omit(tmp)
  tmp$color <- alpha("red", 0.3)
  temp_dataframe = data.frame(tmp[1], tmp[2])
  df <- rbind(df, temp_dataframe)
}

lon_range <- c(min(df$longitude), max(df$longitude))
lat_range <- c(min(df$latitude), max(df$latitude))

mymap <- GetMap.bbox(lon_range, lat_range, destfile = "TestGoogleMap.png", maptype="satellite", zoom=2, size=c(640,640))
PlotOnStaticMap(mymap, lon=df$longitude, lat=df$latitude, pch=20, cex = .25, col="red")

#mypolygon <- drawPoly()  # click on the map to draw a polygon and press ESC when finished
#summary(mypolygon) 

#plotting shape files (species ranges) on Google Maps
library(ggmap)
library(ggplot2)
shp <- readOGR(".", "Rivina_humilis")
projection(shp) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0 +datum=potsdam +units=m +no_defs")
ggplot(data = shp, aes(x = long, y = lat, group = group)) + geom_polygon()
#CenterOfMap was chosen because BIEN only has information for N and S America but this can be changes
CenterOfMap <- geocode("Mexico")
mymap = get_map(c(lon=CenterOfMap$lon, lat=CenterOfMap$lat), source="google", maptype="satellite", zoom=2)
ggmap(mymap)+ geom_polygon(aes(x = long, y = lat, group = group), data = shp, fill='green')

#Plotting Species over Bioclim data#############################
#if you need to import bioclim data to R
#bio_1= raster("bio_1.bil")
#bio_1 <-bio_1/10

#Plotting Points with Bioclim
gis_data = vector[2:3]
gis_data = unique(gis_data)
gis_data = na.omit(gis_data)
str(gis_data)
coordinates(gis_data) <- ~longitude+latitude
proj4string(gis_data) <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

plot(bio_1)
points(gis_data, col = "red", pch = 20, cex = 0.25)

#Plotting Ranges with Bioclim
shp <- readOGR(".", "Rivina_humilis")
projection(shp) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0 +datum=potsdam +units=m +no_defs")

plot(bio1)
geom_polygon(aes(x = long, y = lat, group = group), data = shp, fill='green')

################################################################################################
#Analysis/Trends
##Use alltraits_allspecies for this

#Seed data!!

#preliminary data summary
hist(allspecies_alltraits$seed.mass, xlab="Seed Mass (g)", ylab="Frequency", main="")
text(0.2, 12, "Pisonia umbellifera")
#outlier is Pisonia umbellifera

#seed mass for duration
plot(log(allspecies_alltraits$seed.mass)~allspecies_alltraits$duration, xlab="Growth Duration", ylab="log(Seed Mass (g))")

#bioclim variables
##contains only variable which had an effect
seed.model <- lm(log(seed.mass) ~ bio1+bio2+bio3+bio4, data=allspecies_alltraits)
#plot(seed.model)
summary(seed.model) #together: f=21.97, p=4.392x10^-7, r2=0.8146

#trees
library(tree)
tree.model1 <- tree(log(seed.mass) ~ bio1+bio6, data=allspecies_alltraits)
plot(tree.model1)
text(tree.model1)
summary(tree.model1)

tree.model2 <- tree(log(seed.mass) ~ bio1+bio2+bio3+bio4+bio5+bio6+bio7+bio8+bio9+bio10+bio11+bio12+bio13+bio14+bio15+bio16+bio17+bio18+bio19, data=allspecies_alltraits)
plot(tree.model2)
text(tree.model2)
summary(tree.model2)

tree.model3 <- tree(log(seed.mass) ~ bio1+bio2+bio3+bio4, data=allspecies_alltraits)
plot(tree.model3)
text(tree.model3)
summary(tree.model3)

#supporting bioclim plots
plot(log(allspecies_alltraits$seed.mass)~allspecies_alltraits$bio1, xlim=c(5,20), xlab="Annual Mean Temperature (°C)", ylab="log(Seed Mass (g))")
plot(log(allspecies_alltraits$seed.mass)~allspecies_alltraits$bio3, xlim=c(0.4,0.5), xlab="Isothermality (Mean Diurnal Range/Temperature Annual Range) (°C)", ylab="log(Seed Mass (g))")
plot(log(allspecies_alltraits$seed.mass)~allspecies_alltraits$bio6, xlim=c(-5,5), xlab="Min Temperature of Coldest Month (°C)", ylab="log(Seed Mass (g))")
plot(log(allspecies_alltraits$seed.mass)~allspecies_alltraits$bio12, xlab="Annual Precipitation (mm month ^ -1)", ylab="log(Seed Mass (g))")

#Growth form data!!

#preliminary trends
plot(allspecies_alltraits$growth.type)
plot(bio1~growth.type, data=allspecies_alltraits)
#bc of the uneven distribution of traits these were ignored:
plot(allspecies_alltraits$duration) 

plot(allspecies_alltraits$GROWTHFORM, ylab="Frequency", xlab="Plant Type")
plot(bio1~GROWTHFORM, data=allspecies_alltraits, xlab="Plant Type", ylab="Annual Mean Temperature (°C)")
plot(bio14~GROWTHFORM, data=allspecies_alltraits, xlab="Plant Type", ylab="Precipitation of Driest Month (mm)")


#trees
library(tree)
tree.model <- tree(GROWTHFORM ~ bio1+bio2+bio3+bio4+bio5+bio6+bio7+bio8+bio9+bio10+bio11+bio12+bio13+bio14+bio15+bio16+bio17+bio18+bio19, data=allspecies_alltraits)
plot(tree.model)
text(tree.model)
summary(tree.model)

tree.model1 <- tree(growth.type ~ bio1+bio2+bio3+bio4+bio5+bio6+bio7+bio8+bio9+bio10+bio11+bio12+bio13+bio14+bio15+bio16+bio17+bio18+bio19, data=growthform_bioclim)
plot(tree.model1)
text(tree.model1)
summary(tree.model1)
