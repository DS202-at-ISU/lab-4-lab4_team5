
<!-- README.md is generated from README.Rmd. Please edit the README.Rmd file -->

# Lab report \#4 - instructions

Follow the instructions posted at
<https://ds202-at-isu.github.io/labs.html> for the lab assignment. The
work is meant to be finished during the lab time, but you have time
until Monday (after Thanksgiving) to polish things.

All submissions to the github repo will be automatically uploaded for
grading once the due date is passed. Submit a link to your repository on
Canvas (only one submission per team) to signal to the instructors that
you are done with your submission.

# Lab 4: Scraping (into) the Hall of Fame

![](README_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

``` r
url <- "https://www.baseball-reference.com/awards/hof_2023.shtml"
html <- read_html(url)
tables <- html_table(html)
data2023 <- tables[[1]]

write.csv(data2023, "temp.csv", row.names=FALSE)
data2023 <- read_csv("temp.csv", skip = 1, show_col_types =FALSE)
```

    ## New names:
    ## • `G` -> `G...13`
    ## • `H` -> `H...16`
    ## • `HR` -> `HR...17`
    ## • `BB` -> `BB...20`
    ## • `G` -> `G...31`
    ## • `H` -> `H...35`
    ## • `HR` -> `HR...36`
    ## • `BB` -> `BB...37`

``` r
AllLinks <- html %>% html_nodes("table:nth-child(1)") %>% html_nodes("a") %>%
  lapply(function(link) {
  href <- html_attr(link, "href")
  text <- html_text(link)
  return(data.frame(href = href, text = text, stringsAsFactors = FALSE))
})

links <- do.call(rbind, AllLinks)

PlayerInfo <- separate(links, href, into = c("blank", "category", "remove", "bbrefID"), sep = "/") %>%
  select(
    category,
    bbrefID,
    Name = text
  )

PlayerInfo$bbrefID <- gsub(".shtml", "", PlayerInfo$bbrefID)

PlayerInfo <- inner_join(PlayerInfo, Lahman::People, by ="bbrefID") %>% select(
  playerID,
  Name,
  category
)
```

``` r
data2023 <- inner_join(PlayerInfo, data2023, by="Name") %>% mutate(
  yearID = 2023, 
  votedBy = "BBWAA", 
  ballots = 389, 
  needed = 292,
  inducted = ifelse(Votes>=needed, "Y", "N"),
  category = ifelse(category == 'players', "Player", NA), 
  needed_note = NA 
) %>% select(
  playerID,
  yearID,
  votedBy,
  ballots,
  needed,
  votes = Votes,
  inducted,
  category,
  needed_note
)
```

``` r
hofUpdated <- rbind(hof, data2023)
readr::write_csv(hofUpdated, file="HallOfFame.csv")
```

``` r
HallOfFame %>% 
  ggplot(aes(x = yearID, fill = inducted)) +
  geom_bar() +
  xlim(c(1936, 2023))
```

    ## Warning: Removed 2 rows containing missing values or values outside the scale range
    ## (`geom_bar()`).

![](README_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->
