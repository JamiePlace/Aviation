#' function to split threshold & interval into:
#' - flight_hours
#' - flight_cycles
#' - calendar_days
#' @param df the data
#' @type the column to maniuplate
hour_cycle_days <- function(df, type) {
  # flight cycle section
  # check if fc in cell
  # if not: -
  # else: extract number prior to fc but before any other letters
  
  flight_cycle_regex <- '\\d+ FC'
  flight_hours_regex <- '\\d+ (FH|AH)'
  
  # types for calendar_days
  # MO = months
  # YR = years
  # DY = days
  # HR = hours
  # must convert to days
  flight_calendar_regex <- '\\d+ (HR|DY|MO|YR)'
  
  df <- 
    df %>% 
    mutate(
      '{type}_flight_cycles' := str_extract(df %>% select(!!glue('{type}')) %>% pull(), flight_cycle_regex),
      '{type}_flight_hours' := str_extract(df %>% select(!!glue('{type}')) %>% pull(), flight_hours_regex),
      '{type}_calendar_days' := str_extract(df %>% select(!!glue('{type}')) %>% pull(), flight_calendar_regex)
    ) 
  
  df <-
    df %>% 
    mutate(
      '{type}_calendar_days' := calendar_days(df %>% select(!!glue('{type}_calendar_days')) %>% pull())
    )
  
  # find note in the column we want
  var <- df %>% select({{type}}) %>% pull()
  # find the indices of 'NOTE'
  idx <- which(var == 'NOTE')
  # assign the note
  df[idx, c(glue('{type}_flight_cycles'), glue('{type}_flight_hours'), glue('{type}_calendar_days'))] <- 'NOTE'
  
  return(df)
}

#' function to determine the number of calendar days based on the structure of the calendar days column
#' @param var the column of calendar days
calendar_days <- function(var){
  res <- sapply(var, function(x){
    num <- NA
    if (grepl('YR', x)){
      num <- gsub('YR', '', x)
      num <- as.numeric(num)
      num <- ifelse(length(num) == 0, NA, num * 365.25)
      
    }
    
    if (grepl('MO', x)){
      num <- gsub('MO', '', x)
      num <- as.numeric(num)
      num <- ifelse(length(num) == 0, NA, num * 30.4)
    }
    
    if (grepl('HR', x)){
      num <- gsub('HR', '', x)
      num <- as.numeric(num)
      num <- ifelse(length(num) == 0, NA, num / 24)
    }
    
    if (is.na(num)){
      return(num)
    } else{
      return(glue('{num} DY'))
    }
  })
  return(res)
}