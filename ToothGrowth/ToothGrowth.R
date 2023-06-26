# Loading library
library(tidyverse)

# Looking at dataset
data("ToothGrowth")
View(ToothGrowth)

# Filtering data to see only rows where the dose of vitamin C in 0.5
filtered_tg <- filter(ToothGrowth, dose==0.5)
View(filtered_tg)

# Sorting data by length of tooth
arrange(filtered_tg, len)

# Nested function
arrange(filter(ToothGrowth, dose==0.5), len)

# Using pipe
filtered_toothgrowth <- ToothGrowth %>% 
  filter(dose==0.5) %>%
  arrange(len)
View(filtered_toothgrowth)

# Average tooth length for supplements: OJ and VC
filtered_supplements <- ToothGrowth %>% 
  filter(dose==0.5) %>%
  group_by(supp) %>% 
  summarise(mean_len = mean(len, na.rm = T),.group="drop")
View(filtered_supplements)

# Converting dose columns from numeric to factor variables
ToothGrowth$dose <- as.factor(ToothGrowth$dose)

# Visualizations (different versions)
bp<-ggplot(ToothGrowth, aes(x=dose, y=len, fill=dose)) +
  geom_boxplot()

bp + scale_fill_hue(l=40, c=35)

bp + scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9"))

bp + scale_fill_grey() + theme_classic()

bp + scale_fill_brewer(palette="Dark2")
