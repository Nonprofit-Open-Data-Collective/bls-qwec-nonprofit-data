library( dplyr )
library( tidyr )
library( data.table )
library( readxl )





##
##  'year' column missing from 2013-2017 batch
##

convert_bls_xlsx_to_csv_v1 <- function( filename ){

  varnames <- 
    c("fips", "geo_title", "naics", "ind_title", "priv_estab", 
    "priv_employ", "priv_wages", "priv_salary", "priv_weekly", "npo_estab", 
    "npo_employ", "npo_wages", "npo_salary", "npo_weekly", "percent_npo", 
    "wage_ratio_npo", "geo_level", "ind_level")

  suppressMessages({
    df <- 
      readxl::read_xlsx(
        path=filename,
        sheet = 2,
        col_names = FALSE,
        col_types = "text",
        skip = 4) })

  names(df) <- varnames 
  df$percent_npo <- as.numeric(df$percent_npo)
  yyyy <- substr( filename, 25-8, 25-5 )
  df$year <- yyyy
  fn.csv <- gsub( "\\.xlsx", "\\.csv", filename )
  write.csv( df, fn.csv, row.names=F )

  cat( paste0( "\nFILE: ", filename, "\n" ) )
  print( head( as.data.frame(df) ) )
  return( invisible(df) )
}



convert_bls_xlsx_to_csv_v2 <- function( filename ){

  varnames <- 
    c("fips", "geo_title", "naics", "ind_title", "year", "priv_estab", 
    "priv_employ", "priv_wages", "priv_salary", "priv_weekly", "npo_estab", 
    "npo_employ", "npo_wages", "npo_salary", "npo_weekly", "percent_npo", 
    "wage_ratio_npo", "geo_level", "ind_level")

  suppressMessages({
    df <- 
      readxl::read_xlsx(
        path=filename,
        sheet = 2,
        col_names = FALSE,
        col_types = "text",
        skip = 4) })

  names(df) <- varnames 
  df$percent_npo <- as.numeric(df$percent_npo)
  fn.csv <- gsub( "\\.xlsx", "\\.csv", filename )
  write.csv( df, fn.csv, row.names=F )

  cat( paste0( "\nFILE: ", filename, "\n" ) )
  print( head( as.data.frame(df) ) )
  return( invisible(df) )
}


convert_bls_xlsx_to_csv_v1( "qcew-nonprofits-2013.xlsx" )
convert_bls_xlsx_to_csv_v2( "qcew-nonprofits-2020.xlsx" )


qcew_files_v1 <- 
c("qcew-nonprofits-2013.xlsx", "qcew-nonprofits-2014.xlsx", 
"qcew-nonprofits-2015.xlsx", "qcew-nonprofits-2016.xlsx", 
"qcew-nonprofits-2017.xlsx" )

qcew_files_v2 <- 
c("qcew-nonprofits-2018.xlsx", 
"qcew-nonprofits-2019.xlsx", "qcew-nonprofits-2020.xlsx", 
"qcew-nonprofits-2021.xlsx", "qcew-nonprofits-2022.xlsx" )

purrr::walk( qcew_files_v1, convert_bls_xlsx_to_csv_v1 )
purrr::walk( qcew_files_v2, convert_bls_xlsx_to_csv_v2 )


#################
#################  PIVOT WIDE
#################

library( dplyr )
library( tidyr )
library( data.table )



convert_qcew_to_wide_v1 <- function( filename ){

  d <- data.table::fread( filename )

  d$naics <- gsub( "-[0-9]{2}$", "", d$naics )
  d$naics <- stringr::str_pad( d$naics, width=4, "right", "x" )
  d$naics <- paste0( d$naics, "_naics" )

  d$ind_level <- factor( d$ind_level )
  
  d2 <- 
    d %>%
    filter( geo_level == "4_County" ) %>%
    filter( ind_level %in% c("1_Total_Private","2_Sector_(2-digit_NAICS)") ) %>%
    select( ! c("ind_title", "year", "geo_level", "ind_level") )

  vars <- c( "priv_estab", "priv_employ", "priv_wages", 
             "priv_salary", "priv_weekly", "npo_estab", 
             "npo_employ", "npo_wages", "npo_salary", 
             "npo_weekly", "percent_npo", "wage_ratio_npo" )
             
  d3 <- 
    d2 %>%
    pivot_wider( names_from = naics, 
                 values_from = vars,
                 names_glue = "{naics}_{.value}" ) %>%
    arrange( fips )

  d3$fips <- stringr::str_pad( d3$fips, 5, "left", "0" )
  d3$fips <- paste0( "f-", d3$fips )

  yyyy <- substr( filename, 25-8, 25-5 )
  d3$year <- yyyy
  nmz <- names(d3)
  nmz <- nmz[ ! nmz %in% c( "fips", "geo_title", "year" ) ]
  new.order <- c( "year", "fips", "geo_title", sort(nmz) )
  d3 <- d3[new.order]

  fn.wide <- paste0( substr( filename, 1, 16 ), "wide-", yyyy, ".csv" ) 
  fwrite( d3, fn.wide )
}




convert_qcew_to_wide_v2 <- function( filename ){

  d <- data.table::fread( filename )

  d$naics <- gsub( "-[0-9]{2}$", "", d$naics )
  d$naics <- stringr::str_pad( d$naics, width=4, "right", "x" )
  d$naics <- paste0( d$naics, "_naics" )

  d$ind_level <- factor( d$ind_level )
  
  d2 <- 
    d %>%
    filter( geo_level == "4_County_Totals" ) %>%
    filter( ind_level %in% c("1_Total_Private","2_Sector_(2-digit_NAICS)") ) %>%
    select( ! c("ind_title", "year", "geo_level", "ind_level") )

  vars <- c( "priv_estab", "priv_employ", "priv_wages", 
             "priv_salary", "priv_weekly", "npo_estab", 
             "npo_employ", "npo_wages", "npo_salary", 
             "npo_weekly", "percent_npo", "wage_ratio_npo" )
             
  d3 <- 
    d2 %>%
    pivot_wider( names_from = naics, 
                 values_from = vars,
                 names_glue = "{naics}_{.value}" ) %>%
    arrange( fips )

  d3$fips <- stringr::str_pad( d3$fips, 5, "left", "0" )
  d3$fips <- paste0( "f-", d3$fips )

  yyyy <- substr( filename, 25-8, 25-5 )
  d3$year <- yyyy
  nmz <- names(d3)
  nmz <- nmz[ ! nmz %in% c( "fips", "geo_title", "year" ) ]
  new.order <- c( "year", "fips", "geo_title", sort(nmz) )
  d3 <- d3[new.order]

  fn.wide <- paste0( substr( filename, 1, 16 ), "wide-", yyyy, ".csv" ) 
  fwrite( d3, fn.wide )
}



csv_files_v1 <- 
c("qcew-nonprofits-2013.csv", "qcew-nonprofits-2014.csv", 
  "qcew-nonprofits-2015.csv", "qcew-nonprofits-2016.csv", 
  "qcew-nonprofits-2017.csv" )

csv_files_v2 <- 
c( "qcew-nonprofits-2018.csv", 
  "qcew-nonprofits-2019.csv", "qcew-nonprofits-2020.csv", 
  "qcew-nonprofits-2021.csv", "qcew-nonprofits-2022.csv" )

purrr::walk( csv_files_v1, convert_qcew_to_wide_v1 )

purrr::walk( csv_files_v2, convert_qcew_to_wide_v2 )





#################
#################  SCRATCH CODE
#################


d <- fread("qcew-nonprofits-2018.csv")

d$naics <- gsub( "-[0-9]{2}$", "", d$naics )
d$naics <- stringr::str_pad( d$naics, width=4, "right", "x" )
d$naics <- paste0( d$naics, "_naics" )

d$ind_level <- factor( d$ind_level )

d %>% 
  select( naics,ind_title,ind_level ) %>%
  unique() %>%
  filter( ind_level %in% c("1_Total_Private","2_Sector_(2-digit_NAICS)") ) %>%
  arrange( ind_level, naics ) %>%
  knitr::kable()

|naics      |ind_title                                                                |ind_level                |
|:----------|:------------------------------------------------------------------------|:------------------------|
|10xx_naics |Total Private                                                            |1_Total_Private          |
|11xx_naics |Agriculture, Forestry, Fishing and Hunting                               |2_Sector_(2-digit_NAICS) |
|23xx_naics |Construction                                                             |2_Sector_(2-digit_NAICS) |
|31xx_naics |Manufacturing                                                            |2_Sector_(2-digit_NAICS) |
|42xx_naics |Wholesale Trade                                                          |2_Sector_(2-digit_NAICS) |
|44xx_naics |Retail Trade                                                             |2_Sector_(2-digit_NAICS) |
|48xx_naics |Transportation and Warehousing                                           |2_Sector_(2-digit_NAICS) |
|51xx_naics |Information                                                              |2_Sector_(2-digit_NAICS) |
|52xx_naics |Finance and Insurance                                                    |2_Sector_(2-digit_NAICS) |
|53xx_naics |Real Estate and Rental and Leasing                                       |2_Sector_(2-digit_NAICS) |
|54xx_naics |Professional, Scientific, and Technical Services                         |2_Sector_(2-digit_NAICS) |
|55xx_naics |Management of Companies and Enterprises                                  |2_Sector_(2-digit_NAICS) |
|56xx_naics |Administrative and Support and Waste Management and Remediation Services |2_Sector_(2-digit_NAICS) |
|61xx_naics |Educational Services                                                     |2_Sector_(2-digit_NAICS) |
|62xx_naics |Health Care and Social Assistance                                        |2_Sector_(2-digit_NAICS) |
|71xx_naics |Arts, Entertainment, and Recreation                                      |2_Sector_(2-digit_NAICS) |
|72xx_naics |Accommodation and Food Services                                          |2_Sector_(2-digit_NAICS) |
|81xx_naics |Other Services (except Public Administration)                            |2_Sector_(2-digit_NAICS) |
 



d2 <- 
  d %>%
  filter( geo_level == "4_County_Totals" ) %>%
  filter( ind_level %in% c("1_Total_Private","2_Sector_(2-digit_NAICS)") ) %>%
  select( ! c("ind_title", "year", "geo_level", "ind_level") )



vars <- c( "priv_estab", "priv_employ", "priv_wages", 
           "priv_salary", "priv_weekly", "npo_estab", 
           "npo_employ", "npo_wages", "npo_salary", 
           "npo_weekly", "percent_npo", "wage_ratio_npo" )

d3 <- 
  d2 %>%
  pivot_wider( names_from = naics, 
               values_from = vars,
               names_glue = "{naics}_{.value}" ) %>%
  arrange( fips )

d3$fips <- stringr::str_pad( d3$fips, 5, "left", "0" )
d3$fips <- paste0( "f-", d3$fips )

new.order <- names(d3) |> sort()
d3 <- d3[new.order]

fwrite( d3, "TEST.CSV" )

