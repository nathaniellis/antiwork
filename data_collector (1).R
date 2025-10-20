library(tidyverse)

get_between <- function(after_time, before_time) {
  data <- get100(after_time)
  while(data[nrow(data),"created_utc"] < before_time) {
    data <- bind_rows(data, get100(data[nrow(data),"created_utc"]))
    print(as.numeric(data[nrow(data),"created_utc"]))
  }
  return(data)
}

get100 <- function(after_time) {
  endpoint <- "https://api.pushshift.io/reddit/comment/search/?subreddit=antiwork&size=100&score=%3E10&after="
  endpoint <- paste0(endpoint, after_time)
  endpoint %>%
    jsonlite::fromJSON() %>%
    .$data %>%
    jsonlite::flatten(recursive = TRUE) %>%
    select(author, body, parent_id, score, created_utc, subreddit) %>%
    as_tibble()
}


data7 <- get_between(1641042061, 1642467600)



