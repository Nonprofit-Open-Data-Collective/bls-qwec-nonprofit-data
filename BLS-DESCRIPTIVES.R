library( data.table )
library( dplyr )


d <- fread("TEST.CSV")





x <- d[["10xx_naics_percent_npo"]]

x <- gsub("[^[:digit:]\\.]", "", x ) |> as.numeric()
x <- gsub("%", "", x ) |> as.numeric()

marketmix <-
c("10xx_naics_percent_npo", "11xx_naics_percent_npo", "44xx_naics_percent_npo", 
"48xx_naics_percent_npo", "51xx_naics_percent_npo", "52xx_naics_percent_npo", 
"53xx_naics_percent_npo", "54xx_naics_percent_npo", "55xx_naics_percent_npo", 
"56xx_naics_percent_npo", "61xx_naics_percent_npo", "62xx_naics_percent_npo", 
"71xx_naics_percent_npo", "72xx_naics_percent_npo")

d <- as.data.frame(d)

fx <- function(x){ 
  x <- gsub("%", "", x ) |> as.numeric()
  return(x) }

d[ marketmix ] <- lapply( d[ marketmix ], fx )
d$`10xx_naics_percent_npo`




mix <-
c("10xx_naics_percent_npo", "44xx_naics_percent_npo", 
  "51xx_naics_percent_npo", "52xx_naics_percent_npo", 
  "53xx_naics_percent_npo", "54xx_naics_percent_npo", 
  "55xx_naics_percent_npo", "56xx_naics_percent_npo", 
  "61xx_naics_percent_npo", "62xx_naics_percent_npo", 
  "71xx_naics_percent_npo", "72xx_naics_percent_npo")


par( mfrow=c(3,4) )
purrr::walk( mix, my_hist2, d, df.labels,
             xlab="PROPORTION OF INDUSTRY IS NP" )



my_hist2 <- function( var, df, labels,
                     xlab="Ratio of NP Wages to FP Wages" ){
  x <- df[[var]]
  y.row <- grepl( substr(var,1,4), labels$naics )
  y <- labels$ind_title[ y.row ]
  mean.y <- mean( x, na.rm=T ) |> round(2)
  par( mar=c(5,1,4,2) )

  h <- hist(x,breaks=50,
        col="firebrick", border="gray80",
        main=y, xlab=xlab,
        yaxis=NULL, ylab="",yaxt="n",
        xlim=c(0,80) )

  
  yh <- 0.8*max( h$counts )
  text( x=60, y=yh, labels=mean.y, cex=2 )

  invisible(h)

}


summary(x)

  par( mar=c(5,1,4,2) )

  hist(x,breaks=50,
    col="steelblue", border="gray",
    main="NONPROFIT SHARE OF PRIVATE MARKETS",
    xlab="% of payroll belonging to NP sector",
    yaxis=NULL, ylab="",yaxt="n" )


my_hist <- function( var, df, labels,
                     xlab="Ratio of NP Wages to FP Wages" ){
  x <- df[[var]]
  y.row <- grepl( substr(var,1,4), labels$naics )
  y <- labels$ind_title[ y.row ]
  mean.y <- mean( x, na.rm=T ) |> round(2)
  par( mar=c(5,1,4,2) )

  h <- hist(x,breaks=50,
        col="steelblue", border="gray",
        main=y, xlab=xlab,
        yaxis=NULL, ylab="",yaxt="n",
        xlim=c(0.2,2) )

  
  yh <- 0.8*max( h$counts )
  text( x=1.5, y=yh, labels=mean.y, cex=2 )

  invisible(h)

}

h <- my_hist( "10xx_naics_wage_ratio_npo", d, df.labels )


var <- "10xx_naics_wage_ratio_npo"

par( mfrow=c(3,4) )
purrr::walk( naics_lev2, my_hist, d, df.labels )

naics_lev2 <- 
c("10xx_naics_wage_ratio_npo", "44xx_naics_wage_ratio_npo", 
  "51xx_naics_wage_ratio_npo", "52xx_naics_wage_ratio_npo", 
  "53xx_naics_wage_ratio_npo", "54xx_naics_wage_ratio_npo", 
  "55xx_naics_wage_ratio_npo", "56xx_naics_wage_ratio_npo", 
  "61xx_naics_wage_ratio_npo", "62xx_naics_wage_ratio_npo", 
  "71xx_naics_wage_ratio_npo", "72xx_naics_wage_ratio_npo")

# AG & TRANSIT LACK DATA
# "11xx_naics_wage_ratio_npo",
# "48xx_naics_wage_ratio_npo",

df.labels <-
structure(list(naics = c("10xx_naics", "11xx_naics", "21xx", 
"22xx", "23xx_naics", "31xx_naics", "42xx_naics", "44xx_naics", 
"48xx_naics", "51xx_naics", "52xx_naics", "53xx_naics", "54xx_naics", 
"55xx_naics", "56xx_naics", "61xx_naics", "62xx_naics", "71xx_naics", 
"72xx_naics", "81xx_naics"), ind_title = c("Total Private", "Agriculture", 
"Mining & Oil", "Utilities", 
"Construction", "Manufacturing", "Wholesale Trade", "Retail Trade", 
"Transit & Warehousing", "Information", "Finance & Insurance", 
"Real Estate", "Professional & Scientific", 
"Management","Waste Management", 
"Education", "Health Care", 
"Arts & Rec", "Food Services", 
"Other"), ind_level = c("1_Total_Private", 
"2_Sector_(2-digit_NAICS)", "2_Sector_(2-digit_NAICS)", "2_Sector_(2-digit_NAICS)", 
"2_Sector_(2-digit_NAICS)", "2_Sector_(2-digit_NAICS)", "2_Sector_(2-digit_NAICS)", 
"2_Sector_(2-digit_NAICS)", "2_Sector_(2-digit_NAICS)", "2_Sector_(2-digit_NAICS)", 
"2_Sector_(2-digit_NAICS)", "2_Sector_(2-digit_NAICS)", "2_Sector_(2-digit_NAICS)", 
"2_Sector_(2-digit_NAICS)", "2_Sector_(2-digit_NAICS)", "2_Sector_(2-digit_NAICS)", 
"2_Sector_(2-digit_NAICS)", "2_Sector_(2-digit_NAICS)", "2_Sector_(2-digit_NAICS)", 
"2_Sector_(2-digit_NAICS)")), class = "data.frame", row.names = c(NA, 
-20L))


|naics      |ind_title                                                                |ind_level                |
|:----------|:------------------------------------------------------------------------|:------------------------|
|10xx_naics |Total Private                                                            |1_Total_Private          |
|11xx_naics |Agriculture, Forestry, Fishing and Hunting                               |2_Sector_(2-digit_NAICS) |
|21xx       |Mining, Quarrying, and Oil and Gas Extraction
|22xx       |Utilities
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
|99xx       | 




