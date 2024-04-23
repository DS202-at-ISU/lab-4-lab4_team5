library(tidyverse)
library(Lahman)
head(HallOfFame, 3)


library(rvest)
url <- "https://www.baseball-reference.com/awards/hof_2023.shtml"
html_content <- read_html(url)
tables <- html_table(html_content)
library(rlist)
#tables[[1]]
#tables[[2]]
# we only care about table 1

data_23 <- tables[[1]]
str(data_23)
head(data_23, 1)
name_idx <- which(head(data_23, 1) == "Name")
name_idx # to be used for playerID
votes_idx <- which(head(data_23, 1) == "Votes")
votes_idx # to be used for votes

#html_content %>% html_nodes("li") %>% lapply(function(x) {x %>% html_text()})
"id" %in% (attributes(((html_content %>% html_nodes("div"))[20] %>% html_attrs())[[1]]))$names
"id" %in% (attributes(((html_content %>% html_nodes("div"))[24] %>% html_attrs())[[1]]))$names

(html_content %>% html_nodes("div"))[24] %>% html_text()

grepl("total ballots", (html_content %>% html_nodes("div"))[24] %>% html_text(), fixed = TRUE)

(html_content %>% html_nodes("div"))[24] %>% html_text() %>% trimws()

list.filter("389 total ballots (292 votes needed for election)" %in% (html_content %>% html_nodes("div") %>% lapply(function(x) {x %>% html_text() %>% trimws()})))

string <- "389 total ballots (292 votes needed for election)"

# Extract numbers as a list
numbers_list <- regmatches(string, gregexpr("\\d+", string))

# Print extracted numbers as a list
print(numbers_list)

strings <- c("389 total ballots (292 votes needed for election)",
             "123 total ballots (100 votes needed for election)",
             "abc total ballots (xyz votes needed for election)")

# Regex pattern
pattern <- "^\\d+ total ballots \\(\\d+ votes needed for election\\)$"

# Find matches
matches <- regmatches(strings, regexpr(pattern, strings))
print(matches)

text_strings <- html_content %>% html_nodes("div") %>% lapply(function(x) {x %>% html_text() %>% trimws()})

# Regex pattern
pattern <- "^\\d+ total ballots \\(\\d+ votes needed for election\\)$"

matches <- regmatches(text_strings, regexpr(pattern, text_strings))
print(matches)

# Extract numbers as a list
numbers_list <- regmatches(matches[[1]], gregexpr("\\d+", matches[[1]]))

# Print extracted numbers as a list
print(numbers_list)
