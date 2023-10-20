
# You can also use `austraits` package to query the database
# https://traitecoevo.github.io/austraits/reference/index.html

# Install `austraits` from branch "changes-for-v5-austraits.build"
# remotes::install_github("traitecoevo/austraits", ref = "changes-for-v5-austraits.build")
library(austraits)
library(tidyverse)

# Read austraits R object
austraits <- readRDS("austraits.rds")
# Join contexts, locations and methods tables to the traits table
austraits <- austraits %>% join_contexts() %>% join_locations() %>% join_methods()

dana_species <-
  c("Sporobolus virginicus", "Salicornia quinqueflora", "Triglochin striata",
    "Avicennia marina", "Aegiceras corniculatum", "Bruguiera gymnorhiza",
    "Rhizophora mucronata")

# Filter for species of interest
austraits_filtered <- austraits$traits %>% filter(taxon_name %in% dana_species)
# Remove columns with all NAs
austraits_filtered <- austraits_filtered %>% discard(~all(is.na(.x)))
austraits_filtered %>% View()

# Check unique `taxon_name` and `trait_name` in table
austraits_filtered %>% pull(taxon_name) %>% unique()
austraits_filtered %>% pull(trait_name) %>% unique()

# Summarise number of observations per `taxon_name` and `trait_name`
austraits_filtered %>%
  group_by(taxon_name, trait_name) %>%
  summarise(n = n()) %>% View()

write_csv(austraits_filtered, "austraits_filtered.csv")
