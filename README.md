# bls-qwec-nonprofit-data

The Quarterly Census of Employment and Wages (QCEW) data on the nonprofit sector 2007-2022. 

The Bureau of Labor Statistics (BLS) processes retrospective Quarterly Census of Employment and Wages (QCEW) panels in 5-year increments (2007-2012, 2013-2017, and 2018-2022 segments are available). These files are available at:  

https://www.bls.gov/bdm/nonprofits/nonprofits.htm

This repository contains code to convert the XLS formats provided by the BLS into a "wide" format with one row for each county FIPS and all data across the available NAICS codes for each county spread out over columns.  

| fips    | geo_title                | 10xx_naics_npo_employ | 10xx_naics_npo_estab | 10xx_naics_npo_salary | 10xx_naics_npo_wages | 10xx_naics_npo_weekly | 10xx_naics_percent_npo | 10xx_naics_priv_employ | 10xx_naics_priv_estab | 10xx_naics_priv_salary | 10xx_naics_priv_wages | 10xx_naics_priv_weekly | 10xx_naics_wage_ratio_npo |
| ------- | ------------------------ | --------------------- | -------------------- | --------------------- | -------------------- | --------------------- | ---------------------- | ---------------------- | --------------------- | ---------------------- | --------------------- | ---------------------- | ------------------------- |
| f-01003 | Baldwin County, Alabama  | 3,031                 | 103                  | 36,917                | 111,894              | 710                   | 4.70%                  | 64,454                 | 6,150                 | 36,017                 | 2,321,403             | 693                    | 1.03                      |
| f-01015 | Calhoun County, Alabama  | 1,090                 | 60                   | 31,406                | 34,233               | 604                   | 3.30%                  | 32,546                 | 2,402                 | 36,308                 | 1,181,691             | 698                    | 0.86                      |
| f-01017 | Chambers County, Alabama | 179                   | 12                   | 32,040                | 5,735                | 616                   | 2.70%                  | 6,514                  | 525                   | 37,808                 | 246,279               | 727                    | 0.84                      |



**DATA DICTIONARY**

| BLS field name                    | New field name                     | Field description                                                                                             |
| --------------------------------- | ---------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| FIPS                              | fips                               | FIPS code (00 = U.S. Totals; excludes Puerto Rico and Virgin Islands)                                         |
| Geographic title                  | geo_title                          | Name of area                                                                                                  |
| NAICS                             | naics                              | Industry code using the North American Industrial Classification System (NAICS), (10 = total private figures) |
| Industry title                    | ind_title                          | NAICS title                                                                                                   |
| Year                              | year                               | Calendar year for which estimates are available                                                               |
| Average establishments            | priv_estab, npo_estab              | The 4 quarter average number of establishments for the year                                                   |
| Average annual employment         | priv_employ, npo_employ            | The 12 month average employment for the year                                                                  |
| Total annual wages (in thousands) | priv_wages, npo_wages              | All wages paid for the year                                                                                   |
| Average annual wage per employee  | priv_salary, npo_salary            | Total annual wages divided by average annual employment                                                       |
| Average weekly wage per employee  | priv_weekly, npo_weekly            | Average annual wage divided by 52                                                                             |
| Percent employment 501(c)(3)      | percent_npo                        | Percentage of employees in 501(c)(3) establishments relative to all establishments                            |
| Wage ratio                        | wage_ratio_npo                     | Ratio of wages in 501(c)(3) establishments relative to all non-501(c)(3) establishments                       |
| Geographic level                  | wide file is at COUNTY ONLY        | Four levels of detail: U.S., state, MSA and county                                                            |
| Industry level                    | wide file is at 2-DIGIT LEVEL ONLY | Four levels of NAICS detail: total private, sector, subsector and industry group                              |


### Industry Levels 

```r
d <- read.csv( "data-raw/CSV/qcew-nonprofits-2018.csv" )

d %>% 
  select( naics,ind_title,ind_level ) %>%
  unique() %>%
  filter( ind_level %in% c("1_Total_Private","2_Sector_(2-digit_NAICS)") ) %>%
  arrange( ind_level, naics ) %>%
  knitr::kable()
```

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


Industries not currently represented in the dataset because of data availability at the county level is low, but these could be added back at the state or national levels: 

```r
d <- read.csv( "data-raw/CSV/qcew-nonprofits-2018.csv" )

d %>% 
  select( naics,ind_title,ind_level ) %>%
  unique() %>%
  filter( ind_level %in% c("3_Subsector_(3-digit_NAICS)", "4_Industry_Group_(4-digit_NAICS)") ) %>%
  arrange( ind_level, naics ) %>%
  knitr::kable()
```

|naics |ind_title                                                                                                   |ind_level                        |
|:-----|:-----------------------------------------------------------------------------------------------------------|:--------------------------------|
|111   |Crop Production                                                                                             |3_Subsector_(3-digit_NAICS)      |
|112   |Animal Production and Aquaculture                                                                           |3_Subsector_(3-digit_NAICS)      |
|115   |Support Activities for Agriculture and Forestry                                                             |3_Subsector_(3-digit_NAICS)      |
|236   |Construction of Buildings                                                                                   |3_Subsector_(3-digit_NAICS)      |
|237   |Heavy and Civil Engineering Construction                                                                    |3_Subsector_(3-digit_NAICS)      |
|238   |Specialty Trade Contractors                                                                                 |3_Subsector_(3-digit_NAICS)      |
|311   |Food Manufacturing                                                                                          |3_Subsector_(3-digit_NAICS)      |
|323   |Printing and Related Support Activities                                                                     |3_Subsector_(3-digit_NAICS)      |
|325   |Chemical Manufacturing                                                                                      |3_Subsector_(3-digit_NAICS)      |
|332   |Fabricated Metal Product Manufacturing                                                                      |3_Subsector_(3-digit_NAICS)      |
|333   |Machinery Manufacturing                                                                                     |3_Subsector_(3-digit_NAICS)      |
|334   |Computer and Electronic Product Manufacturing                                                               |3_Subsector_(3-digit_NAICS)      |
|336   |Transportation Equipment Manufacturing                                                                      |3_Subsector_(3-digit_NAICS)      |
|339   |Miscellaneous Manufacturing                                                                                 |3_Subsector_(3-digit_NAICS)      |
|423   |Merchant Wholesalers, Durable Goods                                                                         |3_Subsector_(3-digit_NAICS)      |
|424   |Merchant Wholesalers, Nondurable Goods                                                                      |3_Subsector_(3-digit_NAICS)      |
|425   |Wholesale Electronic Markets and Agents and Brokers                                                         |3_Subsector_(3-digit_NAICS)      |
|441   |Motor Vehicle and Parts Dealers                                                                             |3_Subsector_(3-digit_NAICS)      |
|442   |Furniture and Home Furnishings Stores                                                                       |3_Subsector_(3-digit_NAICS)      |
|443   |Electronics and Appliance Stores                                                                            |3_Subsector_(3-digit_NAICS)      |
|444   |Building Material and Garden Equipment and Supplies Dealers                                                 |3_Subsector_(3-digit_NAICS)      |
|445   |Food and Beverage Stores                                                                                    |3_Subsector_(3-digit_NAICS)      |
|446   |Health and Personal Care Stores                                                                             |3_Subsector_(3-digit_NAICS)      |
|447   |Gasoline Stations                                                                                           |3_Subsector_(3-digit_NAICS)      |
|448   |Clothing and Clothing Accessories Stores                                                                    |3_Subsector_(3-digit_NAICS)      |
|451   |Sporting Goods, Hobby, Musical Instrument, and Book Stores                                                  |3_Subsector_(3-digit_NAICS)      |
|452   |General Merchandise Stores                                                                                  |3_Subsector_(3-digit_NAICS)      |
|453   |Miscellaneous Store Retailers                                                                               |3_Subsector_(3-digit_NAICS)      |
|454   |Nonstore Retailers                                                                                          |3_Subsector_(3-digit_NAICS)      |
|484   |Truck Transportation                                                                                        |3_Subsector_(3-digit_NAICS)      |
|485   |Transit and Ground Passenger Transportation                                                                 |3_Subsector_(3-digit_NAICS)      |
|487   |Scenic and Sightseeing Transportation                                                                       |3_Subsector_(3-digit_NAICS)      |
|488   |Support Activities for Transportation                                                                       |3_Subsector_(3-digit_NAICS)      |
|493   |Warehousing and Storage                                                                                     |3_Subsector_(3-digit_NAICS)      |
|511   |Publishing Industries (except Internet)                                                                     |3_Subsector_(3-digit_NAICS)      |
|512   |Motion Picture and Sound Recording Industries                                                               |3_Subsector_(3-digit_NAICS)      |
|515   |Broadcasting (except Internet)                                                                              |3_Subsector_(3-digit_NAICS)      |
|517   |Telecommunications                                                                                          |3_Subsector_(3-digit_NAICS)      |
|518   |Data Processing, Hosting, and Related Services                                                              |3_Subsector_(3-digit_NAICS)      |
|519   |Other Information Services                                                                                  |3_Subsector_(3-digit_NAICS)      |
|522   |Credit Intermediation and Related Activities                                                                |3_Subsector_(3-digit_NAICS)      |
|523   |Securities, Commodity Contracts, and Other Financial Investments and Related Activities                     |3_Subsector_(3-digit_NAICS)      |
|524   |Insurance Carriers and Related Activities                                                                   |3_Subsector_(3-digit_NAICS)      |
|525   |Funds, Trusts, and Other Financial Vehicles                                                                 |3_Subsector_(3-digit_NAICS)      |
|531   |Real Estate                                                                                                 |3_Subsector_(3-digit_NAICS)      |
|541   |Professional, Scientific, and Technical Services                                                            |3_Subsector_(3-digit_NAICS)      |
|551   |Management of Companies and Enterprises                                                                     |3_Subsector_(3-digit_NAICS)      |
|561   |Administrative and Support Services                                                                         |3_Subsector_(3-digit_NAICS)      |
|562   |Waste Management and Remediation Services                                                                   |3_Subsector_(3-digit_NAICS)      |
|611   |Educational Services                                                                                        |3_Subsector_(3-digit_NAICS)      |
|621   |Ambulatory Health Care Services                                                                             |3_Subsector_(3-digit_NAICS)      |
|622   |Hospitals                                                                                                   |3_Subsector_(3-digit_NAICS)      |
|623   |Nursing and Residential Care Facilities                                                                     |3_Subsector_(3-digit_NAICS)      |
|624   |Social Assistance                                                                                           |3_Subsector_(3-digit_NAICS)      |
|711   |Performing Arts, Spectator Sports, and Related Industries                                                   |3_Subsector_(3-digit_NAICS)      |
|712   |Museums, Historical Sites, and Similar Institutions                                                         |3_Subsector_(3-digit_NAICS)      |
|713   |Amusement, Gambling, and Recreation Industries                                                              |3_Subsector_(3-digit_NAICS)      |
|721   |Accommodation                                                                                               |3_Subsector_(3-digit_NAICS)      |
|722   |Food Services and Drinking Places                                                                           |3_Subsector_(3-digit_NAICS)      |
|811   |Repair and Maintenance                                                                                      |3_Subsector_(3-digit_NAICS)      |
|812   |Personal and Laundry Services                                                                               |3_Subsector_(3-digit_NAICS)      |
|813   |Religious, Grantmaking, Civic, Professional, and Similar Organizations                                      |3_Subsector_(3-digit_NAICS)      |
|814   |Private Households                                                                                          |3_Subsector_(3-digit_NAICS)      |
|1112  |Vegetable and Melon Farming                                                                                 |4_Industry_Group_(4-digit_NAICS) |
|1113  |Fruit and Tree Nut Farming                                                                                  |4_Industry_Group_(4-digit_NAICS) |
|1114  |Greenhouse, Nursery, and Floriculture Production                                                            |4_Industry_Group_(4-digit_NAICS) |
|1121  |Cattle Ranching and Farming                                                                                 |4_Industry_Group_(4-digit_NAICS) |
|1125  |Aquaculture                                                                                                 |4_Industry_Group_(4-digit_NAICS) |
|1129  |Other Animal Production                                                                                     |4_Industry_Group_(4-digit_NAICS) |
|1151  |Support Activities for Crop Production                                                                      |4_Industry_Group_(4-digit_NAICS) |
|1152  |Support Activities for Animal Production                                                                    |4_Industry_Group_(4-digit_NAICS) |
|1153  |Support Activities for Forestry                                                                             |4_Industry_Group_(4-digit_NAICS) |
|2361  |Residential Building Construction                                                                           |4_Industry_Group_(4-digit_NAICS) |
|2362  |Nonresidential Building Construction                                                                        |4_Industry_Group_(4-digit_NAICS) |
|2372  |Land Subdivision                                                                                            |4_Industry_Group_(4-digit_NAICS) |
|2379  |Other Heavy and Civil Engineering Construction                                                              |4_Industry_Group_(4-digit_NAICS) |
|2381  |Foundation, Structure, and Building Exterior Contractors                                                    |4_Industry_Group_(4-digit_NAICS) |
|2382  |Building Equipment Contractors                                                                              |4_Industry_Group_(4-digit_NAICS) |
|2383  |Building Finishing Contractors                                                                              |4_Industry_Group_(4-digit_NAICS) |
|2389  |Other Specialty Trade Contractors                                                                           |4_Industry_Group_(4-digit_NAICS) |
|3118  |Bakeries and Tortilla Manufacturing                                                                         |4_Industry_Group_(4-digit_NAICS) |
|3231  |Printing and Related Support Activities                                                                     |4_Industry_Group_(4-digit_NAICS) |
|3391  |Medical Equipment and Supplies Manufacturing                                                                |4_Industry_Group_(4-digit_NAICS) |
|3399  |Other Miscellaneous Manufacturing                                                                           |4_Industry_Group_(4-digit_NAICS) |
|4234  |Professional and Commercial Equipment and Supplies Merchant Wholesalers                                     |4_Industry_Group_(4-digit_NAICS) |
|4239  |Miscellaneous Durable Goods Merchant Wholesalers                                                            |4_Industry_Group_(4-digit_NAICS) |
|4241  |Paper and Paper Product Merchant Wholesalers                                                                |4_Industry_Group_(4-digit_NAICS) |
|4249  |Miscellaneous Nondurable Goods Merchant Wholesalers                                                         |4_Industry_Group_(4-digit_NAICS) |
|4251  |Wholesale Electronic Markets and Agents and Brokers                                                         |4_Industry_Group_(4-digit_NAICS) |
|4411  |Automobile Dealers                                                                                          |4_Industry_Group_(4-digit_NAICS) |
|4431  |Electronics and Appliance Stores                                                                            |4_Industry_Group_(4-digit_NAICS) |
|4441  |Building Material and Supplies Dealers                                                                      |4_Industry_Group_(4-digit_NAICS) |
|4442  |Lawn and Garden Equipment and Supplies Stores                                                               |4_Industry_Group_(4-digit_NAICS) |
|4451  |Grocery Stores                                                                                              |4_Industry_Group_(4-digit_NAICS) |
|4461  |Health and Personal Care Stores                                                                             |4_Industry_Group_(4-digit_NAICS) |
|4471  |Gasoline Stations                                                                                           |4_Industry_Group_(4-digit_NAICS) |
|4481  |Clothing Stores                                                                                             |4_Industry_Group_(4-digit_NAICS) |
|4511  |Sporting Goods, Hobby, and Musical Instrument Stores                                                        |4_Industry_Group_(4-digit_NAICS) |
|4512  |Book Stores and News Dealers                                                                                |4_Industry_Group_(4-digit_NAICS) |
|4532  |Office Supplies, Stationery, and Gift Stores                                                                |4_Industry_Group_(4-digit_NAICS) |
|4533  |Used Merchandise Stores                                                                                     |4_Industry_Group_(4-digit_NAICS) |
|4539  |Other Miscellaneous Store Retailers                                                                         |4_Industry_Group_(4-digit_NAICS) |
|4541  |Electronic Shopping and Mail-Order Houses                                                                   |4_Industry_Group_(4-digit_NAICS) |
|4851  |Urban Transit Systems                                                                                       |4_Industry_Group_(4-digit_NAICS) |
|4852  |Interurban and Rural Bus Transportation                                                                     |4_Industry_Group_(4-digit_NAICS) |
|4854  |School and Employee Bus Transportation                                                                      |4_Industry_Group_(4-digit_NAICS) |
|4859  |Other Transit and Ground Passenger Transportation                                                           |4_Industry_Group_(4-digit_NAICS) |
|4871  |Scenic and Sightseeing Transportation, Land                                                                 |4_Industry_Group_(4-digit_NAICS) |
|4881  |Support Activities for Air Transportation                                                                   |4_Industry_Group_(4-digit_NAICS) |
|4884  |Support Activities for Road Transportation                                                                  |4_Industry_Group_(4-digit_NAICS) |
|4889  |Other Support Activities for Transportation                                                                 |4_Industry_Group_(4-digit_NAICS) |
|4931  |Warehousing and Storage                                                                                     |4_Industry_Group_(4-digit_NAICS) |
|5111  |Newspaper, Periodical, Book, and Directory Publishers                                                       |4_Industry_Group_(4-digit_NAICS) |
|5112  |Software Publishers                                                                                         |4_Industry_Group_(4-digit_NAICS) |
|5121  |Motion Picture and Video Industries                                                                         |4_Industry_Group_(4-digit_NAICS) |
|5122  |Sound Recording Industries                                                                                  |4_Industry_Group_(4-digit_NAICS) |
|5151  |Radio and Television Broadcasting                                                                           |4_Industry_Group_(4-digit_NAICS) |
|5152  |Cable and Other Subscription Programming                                                                    |4_Industry_Group_(4-digit_NAICS) |
|5173  |Wired and Wireless Telecommunications Carriers                                                              |4_Industry_Group_(4-digit_NAICS) |
|5182  |Data Processing, Hosting, and Related Services                                                              |4_Industry_Group_(4-digit_NAICS) |
|5191  |Other Information Services                                                                                  |4_Industry_Group_(4-digit_NAICS) |
|5221  |Depository Credit Intermediation                                                                            |4_Industry_Group_(4-digit_NAICS) |
|5222  |Nondepository Credit Intermediation                                                                         |4_Industry_Group_(4-digit_NAICS) |
|5223  |Activities Related to Credit Intermediation                                                                 |4_Industry_Group_(4-digit_NAICS) |
|5239  |Other Financial Investment Activities                                                                       |4_Industry_Group_(4-digit_NAICS) |
|5241  |Insurance Carriers                                                                                          |4_Industry_Group_(4-digit_NAICS) |
|5242  |Agencies, Brokerages, and Other Insurance Related Activities                                                |4_Industry_Group_(4-digit_NAICS) |
|5251  |Insurance and Employee Benefit Funds                                                                        |4_Industry_Group_(4-digit_NAICS) |
|5259  |Other Investment Pools and Funds                                                                            |4_Industry_Group_(4-digit_NAICS) |
|5311  |Lessors of Real Estate                                                                                      |4_Industry_Group_(4-digit_NAICS) |
|5312  |Offices of Real Estate Agents and Brokers                                                                   |4_Industry_Group_(4-digit_NAICS) |
|5313  |Activities Related to Real Estate                                                                           |4_Industry_Group_(4-digit_NAICS) |
|5322  |Consumer Goods Rental                                                                                       |4_Industry_Group_(4-digit_NAICS) |
|5411  |Legal Services                                                                                              |4_Industry_Group_(4-digit_NAICS) |
|5412  |Accounting, Tax Preparation, Bookkeeping, and Payroll Services                                              |4_Industry_Group_(4-digit_NAICS) |
|5413  |Architectural, Engineering, and Related Services                                                            |4_Industry_Group_(4-digit_NAICS) |
|5414  |Specialized Design Services                                                                                 |4_Industry_Group_(4-digit_NAICS) |
|5415  |Computer Systems Design and Related Services                                                                |4_Industry_Group_(4-digit_NAICS) |
|5416  |Management, Scientific, and Technical Consulting Services                                                   |4_Industry_Group_(4-digit_NAICS) |
|5417  |Scientific Research and Development Services                                                                |4_Industry_Group_(4-digit_NAICS) |
|5418  |Advertising, Public Relations, and Related Services                                                         |4_Industry_Group_(4-digit_NAICS) |
|5419  |Other Professional, Scientific, and Technical Services                                                      |4_Industry_Group_(4-digit_NAICS) |
|5511  |Management of Companies and Enterprises                                                                     |4_Industry_Group_(4-digit_NAICS) |
|5611  |Office Administrative Services                                                                              |4_Industry_Group_(4-digit_NAICS) |
|5612  |Facilities Support Services                                                                                 |4_Industry_Group_(4-digit_NAICS) |
|5613  |Employment Services                                                                                         |4_Industry_Group_(4-digit_NAICS) |
|5614  |Business Support Services                                                                                   |4_Industry_Group_(4-digit_NAICS) |
|5615  |Travel Arrangement and Reservation Services                                                                 |4_Industry_Group_(4-digit_NAICS) |
|5616  |Investigation and Security Services                                                                         |4_Industry_Group_(4-digit_NAICS) |
|5617  |Services to Buildings and Dwellings                                                                         |4_Industry_Group_(4-digit_NAICS) |
|5619  |Other Support Services                                                                                      |4_Industry_Group_(4-digit_NAICS) |
|5621  |Waste Collection                                                                                            |4_Industry_Group_(4-digit_NAICS) |
|6111  |Elementary and Secondary Schools                                                                            |4_Industry_Group_(4-digit_NAICS) |
|6112  |Junior Colleges                                                                                             |4_Industry_Group_(4-digit_NAICS) |
|6113  |Colleges, Universities, and Professional Schools                                                            |4_Industry_Group_(4-digit_NAICS) |
|6114  |Business Schools and Computer and Management Training                                                       |4_Industry_Group_(4-digit_NAICS) |
|6115  |Technical and Trade Schools                                                                                 |4_Industry_Group_(4-digit_NAICS) |
|6116  |Other Schools and Instruction                                                                               |4_Industry_Group_(4-digit_NAICS) |
|6117  |Educational Support Services                                                                                |4_Industry_Group_(4-digit_NAICS) |
|6211  |Offices of Physicians                                                                                       |4_Industry_Group_(4-digit_NAICS) |
|6212  |Offices of Dentists                                                                                         |4_Industry_Group_(4-digit_NAICS) |
|6213  |Offices of Other Health Practitioners                                                                       |4_Industry_Group_(4-digit_NAICS) |
|6214  |Outpatient Care Centers                                                                                     |4_Industry_Group_(4-digit_NAICS) |
|6215  |Medical and Diagnostic Laboratories                                                                         |4_Industry_Group_(4-digit_NAICS) |
|6216  |Home Health Care Services                                                                                   |4_Industry_Group_(4-digit_NAICS) |
|6219  |Other Ambulatory Health Care Services                                                                       |4_Industry_Group_(4-digit_NAICS) |
|6221  |General Medical and Surgical Hospitals                                                                      |4_Industry_Group_(4-digit_NAICS) |
|6222  |Psychiatric and Substance Abuse Hospitals                                                                   |4_Industry_Group_(4-digit_NAICS) |
|6223  |Specialty (except Psychiatric and Substance Abuse) Hospitals                                                |4_Industry_Group_(4-digit_NAICS) |
|6231  |Nursing Care Facilities (Skilled Nursing Facilities)                                                        |4_Industry_Group_(4-digit_NAICS) |
|6232  |Residential Intellectual and Developmental Disability, Mental Health, and Substance Abuse Facilities        |4_Industry_Group_(4-digit_NAICS) |
|6233  |Continuing Care Retirement Communities and Assisted Living Facilities for the Elderly                       |4_Industry_Group_(4-digit_NAICS) |
|6239  |Other Residential Care Facilities                                                                           |4_Industry_Group_(4-digit_NAICS) |
|6241  |Individual and Family Services                                                                              |4_Industry_Group_(4-digit_NAICS) |
|6242  |Community Food and Housing, and Emergency and Other Relief Services                                         |4_Industry_Group_(4-digit_NAICS) |
|6243  |Vocational Rehabilitation Services                                                                          |4_Industry_Group_(4-digit_NAICS) |
|6244  |Child Day Care Services                                                                                     |4_Industry_Group_(4-digit_NAICS) |
|7111  |Performing Arts Companies                                                                                   |4_Industry_Group_(4-digit_NAICS) |
|7112  |Spectator Sports                                                                                            |4_Industry_Group_(4-digit_NAICS) |
|7113  |Promoters of Performing Arts, Sports, and Similar Events                                                    |4_Industry_Group_(4-digit_NAICS) |
|7114  |Agents and Managers for Artists, Athletes, Entertainers, and Other Public Figures                           |4_Industry_Group_(4-digit_NAICS) |
|7115  |Independent Artists, Writers, and Performers                                                                |4_Industry_Group_(4-digit_NAICS) |
|7121  |Museums, Historical Sites, and Similar Institutions                                                         |4_Industry_Group_(4-digit_NAICS) |
|7131  |Amusement Parks and Arcades                                                                                 |4_Industry_Group_(4-digit_NAICS) |
|7132  |Gambling Industries                                                                                         |4_Industry_Group_(4-digit_NAICS) |
|7139  |Other Amusement and Recreation Industries                                                                   |4_Industry_Group_(4-digit_NAICS) |
|7211  |Traveler Accommodation                                                                                      |4_Industry_Group_(4-digit_NAICS) |
|7212  |RV (Recreational Vehicle) Parks and Recreational Camps                                                      |4_Industry_Group_(4-digit_NAICS) |
|7213  |Rooming and Boarding Houses, Dormitories, and Workers' Camps                                                |4_Industry_Group_(4-digit_NAICS) |
|7223  |Special Food Services                                                                                       |4_Industry_Group_(4-digit_NAICS) |
|7224  |Drinking Places (Alcoholic Beverages)                                                                       |4_Industry_Group_(4-digit_NAICS) |
|7225  |Restaurants and Other Eating Places                                                                         |4_Industry_Group_(4-digit_NAICS) |
|8111  |Automotive Repair and Maintenance                                                                           |4_Industry_Group_(4-digit_NAICS) |
|8112  |Electronic and Precision Equipment Repair and Maintenance                                                   |4_Industry_Group_(4-digit_NAICS) |
|8113  |Commercial and Industrial Machinery and Equipment (except Automotive and Electronic) Repair and Maintenance |4_Industry_Group_(4-digit_NAICS) |
|8114  |Personal and Household Goods Repair and Maintenance                                                         |4_Industry_Group_(4-digit_NAICS) |
|8121  |Personal Care Services                                                                                      |4_Industry_Group_(4-digit_NAICS) |
|8122  |Death Care Services                                                                                         |4_Industry_Group_(4-digit_NAICS) |
|8123  |Drycleaning and Laundry Services                                                                            |4_Industry_Group_(4-digit_NAICS) |
|8129  |Other Personal Services                                                                                     |4_Industry_Group_(4-digit_NAICS) |
|8131  |Religious Organizations                                                                                     |4_Industry_Group_(4-digit_NAICS) |
|8132  |Grantmaking and Giving Services                                                                             |4_Industry_Group_(4-digit_NAICS) |
|8133  |Social Advocacy Organizations                                                                               |4_Industry_Group_(4-digit_NAICS) |
|8134  |Civic and Social Organizations                                                                              |4_Industry_Group_(4-digit_NAICS) |
|8139  |Business, Professional, Labor, Political, and Similar Organizations                                         |4_Industry_Group_(4-digit_NAICS) |
|8141  |Private Households                                                                                          |4_Industry_Group_(4-digit_NAICS) | 




### Data Availability 

- Nonprofit estimates for 2007-2012 are available at the total private and NAICS 2-digit and 3-digit levels nationally, and total private and NAICS 2-digit levels for the states.
- Nonprofit data for 2013-2022 are available at the national, state, metropolitan statistical area and county levels. 
- Industry estimates are available at the total private, NAICS 2-digit, 3-digit, and 4-digit levels of detail. 

### NAICS to NTEE Crosswalk

See: https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies/tree/main/NAICS 

