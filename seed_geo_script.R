#use the seed_geo_values datatable

#goal 1: get basic statistical trends
##seed size
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio1)  #peak in middle (14)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio2)  #opposite ends of the graph (15.5)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio3)  #opposite (0.47)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio4)  #lower end of the spectrum mainly (65)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio5)  #opposite (33)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio6)  #upper end (0)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio7)  #peak in middle (33)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio8)  #opposite (9)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio9)  #upper end (20)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio10) #peak in middle (23)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio11) #upper end (7)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio12) #lower end (400)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio13) #opposite t=1.777 p=0.0815 . (70)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio14) #lower end (3)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio15) #normal/upper end (65)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio16) #opposite t=1.695 p=0.0961 . (200)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio17) #lower end (13)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio18) #lower end (25)
plot(log(seed_geo_values$trait_value)~seed_geo_values$bio19) #lower end t=1.713 p=0.0927 . (200)

##bioclim general trends
###basically there are large peaks kinda confirming that ranges overlap
hist(seed_geo_values$bio1)  
hist(seed_geo_values$bio2)  
hist(seed_geo_values$bio3)
hist(seed_geo_values$bio4)
hist(seed_geo_values$bio5)
hist(seed_geo_values$bio6)
hist(seed_geo_values$bio7)
hist(seed_geo_values$bio8)
hist(seed_geo_values$bio9)
hist(seed_geo_values$bio10)
hist(seed_geo_values$bio11)
hist(seed_geo_values$bio12)
hist(seed_geo_values$bio13)
hist(seed_geo_values$bio14)
hist(seed_geo_values$bio15)
hist(seed_geo_values$bio16)
hist(seed_geo_values$bio17)
hist(seed_geo_values$bio18)
hist(seed_geo_values$bio19)

#goal 2: trees and relatedness things
seed.model <- lm(log(trait_value) ~ bio1+bio2+bio3+bio4+bio5+bio6+bio7+bio8+bio9+bio10+bio11+bio12+bio13+bio14+bio15+bio16+bio17+bio18+bio19, data=seed_geo_values)
plot(seed.model)
summary(seed.model)



library(tree)
#clim.seed <- read.table("seed_geo_values.csv", header=TRUE)
tree.model <- tree(log(trait_value) ~ bio1+bio2+bio3+bio4+bio5+bio6+bio7+bio8+bio9+bio10+bio11+bio12+bio13+bio14+bio15+bio16+bio17+bio18+bio19, data=seed_geo_values)
plot(tree.model)
text(tree.model)
summary(tree.model)

tree.model1 <- tree(log(trait_value) ~ bio1+bio6, data=seed_geo_values)
plot(tree.model1)
text(tree.model1)
summary(tree.model1)

##help about this bc it doesnt work
#randomforest helps reduce error and help find important variables
library(randomForest)
tree.model3 <- randomForest(log(trait_value)~bio1+bio2+bio3+bio4+bio5+bio6+bio7+bio8+bio9+bio10+bio11+bio12+bio13+bio14+bio15+bio16+bio17+bio18+bio19, data=seed_geo_values)
plot(tree.model3)
text(tree.model3)
summary(tree.model3)




