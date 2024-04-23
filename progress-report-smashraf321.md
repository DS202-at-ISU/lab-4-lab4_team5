progress-report-smashraf321
================
Ashraf Shaikh
4/17/2024

<!-- README.md is generated from README.Rmd. Please edit the README.Rmd file -->

# Lab report \#4

``` r
library(Lahman)
head(HallOfFame, 3)
```

    ##    playerID yearID votedBy ballots needed votes inducted category needed_note
    ## 1  cobbty01   1936   BBWAA     226    170   222        Y   Player        <NA>
    ## 2  ruthba01   1936   BBWAA     226    170   215        Y   Player        <NA>
    ## 3 wagneho01   1936   BBWAA     226    170   215        Y   Player        <NA>

we need the foll: yearID: (2023) DONE votedBy: (BBWAA) DONE playerID:
scrape ballots: 389 but scrape it DONE needed: 292 but scrape it DONE
votes: (votes) scrape it inducted: if votes &gt; needed then y category:
player? needed\_note: just empty NA

My stuff

``` r
library(rvest)
```

    ## 
    ## Attaching package: 'rvest'

    ## The following object is masked from 'package:readr':
    ## 
    ##     guess_encoding

``` r
url <- "https://www.baseball-reference.com/awards/hof_2023.shtml"
html_content <- read_html(url)
tables <- html_table(html_content)
```

testing tables

``` r
#tables[[1]]
#tables[[2]]
# we only care about table 1

data_23 <- tables[[1]]
str(data_23)
```

    ## tibble [29 × 39] (S3: tbl_df/tbl/data.frame)
    ##  $               : chr [1:29] "Rk" "1" "2" "3" ...
    ##  $               : chr [1:29] "Name" "Scott Rolen" "Todd Helton HOF" "Billy Wagner" ...
    ##  $               : chr [1:29] "YoB" "6th" "5th" "8th" ...
    ##  $               : chr [1:29] "Votes" "297" "281" "265" ...
    ##  $               : chr [1:29] "%vote" "76.3%" "72.2%" "68.1%" ...
    ##  $               : chr [1:29] "HOFm" "99" "175" "107" ...
    ##  $               : chr [1:29] "HOFs" "40" "59" "24" ...
    ##  $               : chr [1:29] "Yrs" "17" "17" "16" ...
    ##  $               : chr [1:29] "WAR" "70.1" "61.8" "27.7" ...
    ##  $               : chr [1:29] "WAR7" "43.6" "46.6" "19.8" ...
    ##  $               : chr [1:29] "JAWS" "56.9" "54.2" "23.7" ...
    ##  $               : chr [1:29] "Jpos" "56.3" "53.4" "32.5" ...
    ##  $ Batting Stats : chr [1:29] "G" "2038" "2247" "810" ...
    ##  $ Batting Stats : chr [1:29] "AB" "7398" "7962" "20" ...
    ##  $ Batting Stats : chr [1:29] "R" "1211" "1401" "1" ...
    ##  $ Batting Stats : chr [1:29] "H" "2077" "2519" "2" ...
    ##  $ Batting Stats : chr [1:29] "HR" "316" "369" "0" ...
    ##  $ Batting Stats : chr [1:29] "RBI" "1287" "1406" "1" ...
    ##  $ Batting Stats : chr [1:29] "SB" "118" "37" "0" ...
    ##  $ Batting Stats : chr [1:29] "BB" "899" "1335" "1" ...
    ##  $ Batting Stats : chr [1:29] "BA" ".281" ".316" ".100" ...
    ##  $ Batting Stats : chr [1:29] "OBP" ".364" ".414" ".143" ...
    ##  $ Batting Stats : chr [1:29] "SLG" ".490" ".539" ".100" ...
    ##  $ Batting Stats : chr [1:29] "OPS" ".855" ".953" ".243" ...
    ##  $ Batting Stats : chr [1:29] "OPS+" "122" "133" "-35" ...
    ##  $ Pitching Stats: chr [1:29] "W" "" "" "47" ...
    ##  $ Pitching Stats: chr [1:29] "L" "" "" "40" ...
    ##  $ Pitching Stats: chr [1:29] "ERA" "" "" "2.31" ...
    ##  $ Pitching Stats: chr [1:29] "ERA+" "" "" "187" ...
    ##  $ Pitching Stats: chr [1:29] "WHIP" "" "" "0.998" ...
    ##  $ Pitching Stats: chr [1:29] "G" "" "" "853" ...
    ##  $ Pitching Stats: chr [1:29] "GS" "" "" "0" ...
    ##  $ Pitching Stats: chr [1:29] "SV" "" "" "422" ...
    ##  $ Pitching Stats: chr [1:29] "IP" "" "" "903.0" ...
    ##  $ Pitching Stats: chr [1:29] "H" "" "" "601" ...
    ##  $ Pitching Stats: chr [1:29] "HR" "" "" "82" ...
    ##  $ Pitching Stats: chr [1:29] "BB" "" "" "300" ...
    ##  $ Pitching Stats: chr [1:29] "SO" "" "" "1196" ...
    ##  $               : chr [1:29] "Pos Summary" "*5/H" "*3H/7D9" "*1" ...

``` r
head(data_23, 1)
```

    ## # A tibble: 1 × 39
    ##   ``    ``    ``    ``    ``    ``    ``    ``    ``    ``    ``    ``   
    ##   <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr>
    ## 1 Rk    Name  YoB   Votes %vote HOFm  HOFs  Yrs   WAR   WAR7  JAWS  Jpos 
    ## # ℹ 27 more variables: `Batting Stats` <chr>, `Batting Stats` <chr>,
    ## #   `Batting Stats` <chr>, `Batting Stats` <chr>, `Batting Stats` <chr>,
    ## #   `Batting Stats` <chr>, `Batting Stats` <chr>, `Batting Stats` <chr>,
    ## #   `Batting Stats` <chr>, `Batting Stats` <chr>, `Batting Stats` <chr>,
    ## #   `Batting Stats` <chr>, `Batting Stats` <chr>, `Pitching Stats` <chr>,
    ## #   `Pitching Stats` <chr>, `Pitching Stats` <chr>, `Pitching Stats` <chr>,
    ## #   `Pitching Stats` <chr>, `Pitching Stats` <chr>, `Pitching Stats` <chr>, …

``` r
name_idx <- which(head(data_23, 1) == "Name")
name_idx # to be used for playerID
```

    ## [1] 2

``` r
votes_idx <- which(head(data_23, 1) == "Votes")
votes_idx # to be used for votes
```

    ## [1] 4

``` r
text_strings <- html_content %>% html_nodes("div") %>% lapply(function(x) {x %>% html_text() %>% trimws()})

# only filter out stuff that has that regex for total ballots
# Regex pattern
pattern <- "^\\d+ total ballots \\(\\d+ votes needed for election\\)$"

matches <- regmatches(text_strings, regexpr(pattern, text_strings))
print(matches)
```

    ## [1] "389 total ballots (292 votes needed for election)"

``` r
# Extract numbers as a list
numbers_list <- regmatches(matches[[1]], gregexpr("\\d+", matches[[1]]))

# Print extracted numbers as a list
print(numbers_list)
```

    ## [[1]]
    ## [1] "389" "292"

``` r
num_ballots <- as.numeric(numbers_list[[1]][1])

num_needed <- as.numeric(numbers_list[[1]][2])

print(num_ballots)
```

    ## [1] 389

``` r
print(num_needed)
```

    ## [1] 292

``` r
data_23_clean <- data.frame(playerID = character(28),
                            yearID = integer(28),
                            votedBy = character(28),
                            ballots = numeric(28),
                            needed = numeric(28),
                            votes = numeric(28),
                            inducted = factor(28),
                            category = factor(28),
                            needed_note = character(28))



data_23_clean$playerID <- data_23[2:nrow(data_23), name_idx]
data_23_clean$votes <-  data_23[2:nrow(data_23), votes_idx]

data_23_clean$playerID <- as.character(unlist(data_23_clean$playerID))
data_23_clean$votes <- as.numeric(unlist(data_23_clean$votes))



data_23_clean <- data_23_clean %>% mutate(yearID = as.integer(2023),
                                          votedBy = "BBWAA",
                                          ballots = num_ballots,
                                          needed = num_needed,
                                          category = factor("Player"),
                                          needed_note = NA)

data_23_clean <- data_23_clean %>% mutate(inducted = factor(ifelse(votes>=num_needed, "Y", "N")))
```

``` r
new_HallOfFame <- rbind(HallOfFame, data_23_clean)

# View the last `n` rows of the data frame
last_n_rows <- new_HallOfFame[(nrow(new_HallOfFame) - 35 + 1):nrow(new_HallOfFame), ]

# Print the last `n` rows
print(last_n_rows)
```

    ##                 playerID yearID  votedBy ballots needed votes inducted
    ## 4317           crawfca02   2022    BBWAA     394    296     0        N
    ## 4318           fowlebu99   2022 Veterans      NA     NA    NA        Y
    ## 4319           hodgegi01   2022 Veterans      NA     NA    NA        Y
    ## 4320            kaatji01   2022 Veterans      NA     NA    NA        Y
    ## 4321           minosmi01   2022 Veterans      NA     NA    NA        Y
    ## 4322           oneilbu01   2022 Veterans      NA     NA    NA        Y
    ## 4323           olivato01   2022 Veterans      NA     NA    NA        Y
    ## 4324         Scott Rolen   2023    BBWAA     389    292   297        Y
    ## 4325     Todd Helton HOF   2023    BBWAA     389    292   281        N
    ## 4326        Billy Wagner   2023    BBWAA     389    292   265        N
    ## 4327        Andruw Jones   2023    BBWAA     389    292   226        N
    ## 4328      Gary Sheffield   2023    BBWAA     389    292   214        N
    ## 4329      Carlos Beltrán   2023    BBWAA     389    292   181        N
    ## 4330         X-Jeff Kent   2023    BBWAA     389    292   181        N
    ## 4331      Alex Rodriguez   2023    BBWAA     389    292   139        N
    ## 4332       Manny Ramirez   2023    BBWAA     389    292   129        N
    ## 4333        Omar Vizquel   2023    BBWAA     389    292    76        N
    ## 4334       Andy Pettitte   2023    BBWAA     389    292    66        N
    ## 4335         Bobby Abreu   2023    BBWAA     389    292    60        N
    ## 4336       Jimmy Rollins   2023    BBWAA     389    292    50        N
    ## 4337        Mark Buehrle   2023    BBWAA     389    292    42        N
    ## 4338 Francisco Rodríguez   2023    BBWAA     389    292    42        N
    ## 4339        Torii Hunter   2023    BBWAA     389    292    27        N
    ## 4340     X-Huston Street   2023    BBWAA     389    292     1        N
    ## 4341    X-Bronson Arroyo   2023    BBWAA     389    292     1        N
    ## 4342       X-Mike Napoli   2023    BBWAA     389    292     1        N
    ## 4343       X-John Lackey   2023    BBWAA     389    292     1        N
    ## 4344       X-R.A. Dickey   2023    BBWAA     389    292     1        N
    ## 4345    X-Jhonny Peralta   2023    BBWAA     389    292     0        N
    ## 4346        X-J.J. Hardy   2023    BBWAA     389    292     0        N
    ## 4347      X-Andre Ethier   2023    BBWAA     389    292     0        N
    ## 4348   X-Jacoby Ellsbury   2023    BBWAA     389    292     0        N
    ## 4349         X-Matt Cain   2023    BBWAA     389    292     0        N
    ## 4350      X-Jered Weaver   2023    BBWAA     389    292     0        N
    ## 4351      X-Jayson Werth   2023    BBWAA     389    292     0        N
    ##               category needed_note
    ## 4317            Player        <NA>
    ## 4318 Pioneer/Executive        <NA>
    ## 4319            Player        <NA>
    ## 4320            Player        <NA>
    ## 4321            Player        <NA>
    ## 4322 Pioneer/Executive        <NA>
    ## 4323            Player        <NA>
    ## 4324            Player        <NA>
    ## 4325            Player        <NA>
    ## 4326            Player        <NA>
    ## 4327            Player        <NA>
    ## 4328            Player        <NA>
    ## 4329            Player        <NA>
    ## 4330            Player        <NA>
    ## 4331            Player        <NA>
    ## 4332            Player        <NA>
    ## 4333            Player        <NA>
    ## 4334            Player        <NA>
    ## 4335            Player        <NA>
    ## 4336            Player        <NA>
    ## 4337            Player        <NA>
    ## 4338            Player        <NA>
    ## 4339            Player        <NA>
    ## 4340            Player        <NA>
    ## 4341            Player        <NA>
    ## 4342            Player        <NA>
    ## 4343            Player        <NA>
    ## 4344            Player        <NA>
    ## 4345            Player        <NA>
    ## 4346            Player        <NA>
    ## 4347            Player        <NA>
    ## 4348            Player        <NA>
    ## 4349            Player        <NA>
    ## 4350            Player        <NA>
    ## 4351            Player        <NA>

``` r
write.csv(new_HallOfFame, file="updated_HallOfFame.csv", row.names = FALSE)
```
