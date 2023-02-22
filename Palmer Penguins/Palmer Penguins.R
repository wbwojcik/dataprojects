# Loading libraries
library("tidyverse")
library("palmerpenguins")
library("skimr")
library("janitor")

# Looking at a dataset
data("penguins")
View(penguins)

# Summary of a dataset (different versions)
skim_without_charts(penguins)
glimpse(penguins)

# Preview of the column names and the first few rows
head(penguins)

# Showing only Species column and the rest columns without Species
penguins %>% 
  select(species)
penguins %>% 
  select(-species)

# Sorting and filtering
penguins %>% 
  arrange (bill_length_mm)

penguins %>% 
  group_by(island) %>% 
  drop_na() %>% 
  summarise(mean_bill_length_mm = mean(bill_length_mm))

penguins %>% 
  group_by(island) %>% 
  drop_na() %>% 
  summarise(max_bill_length_mm = max(bill_length_mm))

penguins %>% 
  group_by(species, island) %>% 
  drop_na() %>% 
  summarise(max_bl = max(bill_length_mm))

penguins %>% 
  filter(species == "Adelie")

# Changing and cleaning
penguins %>% 
  rename(island=island_new)

rename_with(penguins,toupper)

clean_names(penguins)

penguins %>%
  mutate(body_mass_kg = body_mass_g/1000, flipper_length_m=flipper_length_mm/1000)


# Visualizations (different versions)

ggplot( data = penguins)+
  geom_point(mapping = aes(x=bill_length_mm, y=bill_depth_mm))

ggplot( data = penguins)+
  geom_smooth(mapping = aes(x=bill_length_mm, y=bill_depth_mm))

ggplot(data = penguins) + 
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, shape=species, color=species))

ggplot(data = penguins) + 
  geom_smooth(mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g))

ggplot(data = penguins) + 
  geom_smooth(mapping = aes(x = flipper_length_mm, y = body_mass_g, linetype=species))

ggplot(data = penguins) + 
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, color=species)) +
  facet_wrap(~species)

ggplot(data = penguins) + 
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, color=species)) +
  facet_grid(sex~species)

ggplot(data = penguins) + 
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, color=species)) +
  labs(title = "Palmer Penguins: Body Mass vs. Flipper Lenght", 
       subtitle = "Sample of Three Penguin Species", caption = "Data collected by Dr. Kristen Gorman") +
  annotate("text", x=220, y=3500, label="The Gentoos are the largest")
