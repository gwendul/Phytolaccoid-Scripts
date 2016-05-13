####Extracting Bioclim data for all species####
#Aims:
##form a list of species
#extract mean range data for the bioclim variables (can choose which ones to use later maybe?)
##store the values in one csv file
##combine values with trait data (get values for individual locations)

##Getting species used in seed data
seed.species <- seed_data[4]
seed.species <- unique(seed.species)

get.bioclim <- function() {
  extract(bios, ..., fun='mean', na.rm=TRUE)
}
range.bioclim <- lapply(seed.species[1], get.bioclim)
write.csv(range.bioclim, file="seedbioclimdata.csv")



####

#phyto.species <- function(species_vector) {
 # for(i in 1:44834) {
  #  BIEN.ranges.species(i ,saveto)
   # ...poly <- readShapePoly(i)}
  #lapply(species_vector(1:44834))
#}



#bio.species <- function(phyto.species) {
 # extract(bios, ...poly, fun='mean', na.rm=TRUE)
  #lapply(phtospecies(1:44834))
#} 

#range_bio <- extract(bios,Rivina_poly, fun='mean', na.rm=TRUE) 

#teste_sp1 <-readShapePoly ("sp1", IDVAR = NULL,
                          # proj4string = CRS (as.character (NA)), verbose = FALSE, repair = FALSE, FALSE = force_ring,
                          # delete_null_obj = FALSE, retrieve_ABS_null = FALSE)
#v <- extract (bios, sp1)