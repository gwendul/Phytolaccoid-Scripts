traitdata <- read.csv(file=file.choose()) #trait_data.csv
attach(traitdata)
View(traitdata)

#44 different species of data
unique(traitdata$taxon)

traittable <- with(traitdata, table(taxon, trait_name))
write.csv(traittable, file="traitcoverage.csv")
#in csv files folder

#sort traits by species not in columns
#load tidyr
trait_vector <- c("Area-based photosynthesis (Aarea)", "Flowering date", "Flowering month", "Height", "Leaf area", "Leaf Cmass", "Leaf dry mass", "Leaf dry matter content (LDMC)", "Leaf Narea", "Leaf Nmass", "Leaf Parea", "Leaf Pmass", "Mass-based photosynthesis (Amass)", "seed mass", "Specific leaf area (SLA)", "Stomatal conductance (Gs)", "wood density")
trait.spread=spread(traitdata, trait_name, trait_value)
View(trait.spread)

#remove blank/unwanted columns
trait.spread$intraspecific_rank <- NULL
trait.spread$varsubsp <- NULL
#will add in the location data from locationdata
trait.spread$latitude <- NULL
trait.spread$longitude <- NULL
View(trait.spread)

#combine different columns of traits by species
unite(traitspread, taxon)

##regional data##############DO THIS####################
locationdata <- read.csv(file=file.choose()) #psn_data.csv
attach(locationdata)
View(locationdata)

#combine both datasets
phytodata=merge(trait.spread, locationdata, by.x="taxon", by.y="scrubbed_species_binomial")
phytodata$scrubbed_family <- NULL
View(phytodata)
#########there are suddenly many repetitions of the same things...what do to about this????

###rename things with this!!
##names(dataset)[names(dataset)=="original column name"] <- "new column name"