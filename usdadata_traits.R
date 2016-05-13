##USDA Traits###
#use dataset: seed_data.csv

plot(seed_data$trait_value~seed_data$duration, xlab="Growth Duration", ylab="Seed Mass (g)")
plot(log(seed_data$trait_value)~seed_data$duration, xlab="Growth Duration", ylab="log(Seed Mass (g))")
plot(seed_data$trait_value~seed_data$growth.type)
