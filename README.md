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



### Data Availability 

- Nonprofit estimates for 2007-2012 are available at the total private and NAICS 2-digit and 3-digit levels nationally, and total private and NAICS 2-digit levels for the states.
- Nonprofit data for 2013-2022 are available at the national, state, metropolitan statistical area and county levels. 
- Industry estimates are available at the total private, NAICS 2-digit, 3-digit, and 4-digit levels of detail. 

### NAICS to NTEE Crosswalk

See: https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies/tree/main/NAICS 

