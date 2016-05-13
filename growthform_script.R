#use growthform_bioclim datasheet

##growth form #####do with all spp.######

plot(growthform_bioclim$bio1~growthform_bioclim$growth.type)
plot(growthform_bioclim$bio2~growthform_bioclim$growth.type)
plot(growthform_bioclim$bio3~growthform_bioclim$growth.type)
plot(growthform_bioclim$bio4~growthform_bioclim$growth.type)
plot(growthform_bioclim$bio5~growthform_bioclim$growth.type)
plot(growthform_bioclim$bio6~growthform_bioclim$growth.type)
plot(growthform_bioclim$bio7~growthform_bioclim$growth.type)
plot(growthform_bioclim$bio8~growthform_bioclim$growth.type)
plot(growthform_bioclim$bio9~growthform_bioclim$growth.type) #
plot(growthform_bioclim$bio10~growthform_bioclim$growth.type)
plot(growthform_bioclim$bio11~growthform_bioclim$growth.type)
plot(growthform_bioclim$bio12~growthform_bioclim$growth.type) #
plot(growthform_bioclim$bio13~growthform_bioclim$growth.type) #
plot(growthform_bioclim$bio14~growthform_bioclim$growth.type) #
plot(growthform_bioclim$bio15~growthform_bioclim$growth.type) #
plot(growthform_bioclim$bio16~growthform_bioclim$growth.type) 
plot(growthform_bioclim$bio17~growthform_bioclim$growth.type) #
plot(growthform_bioclim$bio18~growthform_bioclim$growth.type) #
plot(growthform_bioclim$bio19~growthform_bioclim$growth.type)


#trees
library(tree)
tree.model <- tree(growth.type ~ bio1+bio2+bio3+bio4+bio5+bio6+bio7+bio8+bio9+bio10+bio11+bio12+bio13+bio14+bio15+bio16+bio17+bio18+bio19, data=growthform_bioclim)
plot(tree.model)
text(tree.model)
summary(tree.model)


#phytools package
#categorical models
#github kerkhoff code


plot(allspecies_alltraits$seed.mass~allspecies_alltraits$GROWTHFORM)
