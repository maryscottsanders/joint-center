require(tidyverse)
require(tidycensus)

#here are all the ACS5 variables from the API. Made R-searchable when using View() in RStudio
acs5_v <- load_variables(2016, "acs5", cache = T)

#probably an easier way to do this, but whatever. just make sure to use postal codes
states <- c("AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA",
            "HI","ID","IA","IL","IN","KS","KY","LA","ME","MD",
            "MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ",
            "NM","NY","NC","ND","OH","OK","OR","PA","RI","SC",
            "SD","TN","TX","UT","VT","VA","WA","WV","WI","WY","DC")

#For more information, look up ?get_acs and https://walkerke.github.io/tidycensus/

#extracting population for each state
pop_bystate <- get_acs(geography = "state",
                       variables = c("B02001_001", "B02001_003"))
pop_bystate %>% write.csv("all-state-pop.csv", row.names = F)

#extracting population for each county
pop_bycounty <- get_acs(geography = "county",
                        state = states,
                        variables = c("B02001_001", "B02001_003"))
pop_bycounty <- pop_bycounty %>% separate(NAME, into = c("name.county","name.st"), sep = ", ")
pop_bycounty %>% write.csv("all-state-county.csv", row.names = F)

#extracting population for each congressional district
pop_byCD <- get_acs(geography = "congressional district", 
                    variables = c("B02001_001", "B02001_003"),
                    output = "wide")
pop_byCD <- pop_byCD %>% separate(NAME, into = c("name.cd", "name.st"), sep = ", ")
pop_byCD %>% write.csv("Districts-all-states-pop.csv", row.names = F)

#now extracting all population by tract
pop_bytract <- get_acs(geography = "tract", 
                       state = states,
                       variables = c("B02001_001", "B02001_003"),
                       output = "tidy")
pop_bytract <- pop_bytract %>% separate(NAME, into = c("name.tract","name.county","name.st"), sep = ", ")
pop_bytract %>% write.csv("tracts-all-states-pop.csv", row.names = F)
