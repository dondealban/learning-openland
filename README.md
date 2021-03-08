# Learning the OpenLand R package
This is a repository set up as my personal exercise for learning land use/cover change analysis of time-series data using the [OpenLand](https://cran.r-project.org/web/packages/OpenLand/index.html) R package. It can also be used as a tutorial for someone interested in learning spatiotemporal land use/cover change analysis for their research projects. 

## Table of Contents
- [An OpenLand Workflow Example](#workflow)
    + [Load Packages](#load_packages) 
    + [Load Rasters](#load_rasters)
    + [Extract Data from the Raster Time-Series](#extract_data)
    + [Edit Categories](#edit_categories)

<a name="workflow"></a>

## An `OpenLand` Workflow Example
Here, I implemented the workflow from the [vignette](https://cran.r-project.org/web/packages/OpenLand/vignettes/openland_vignette.html) on how to use OpenLand package in R software developed by the authors, Reginal Exavier and Peter Zeilhofer. Users can modify this to suit their objectives.

<a name="load_packages"></a>

### A. Load Packages
Prior to loading packages, you can set your working directory using `setwd()` and indicate your working directory path. The `OpenLand` R package or library was used for this exercise. To load the package we can write:
```R
library(OpenLand)             # Package for quantitative analysis and visualisation of land use/cover change 
```

<a name="load_rasters"></a>

### B. Load Rasters
The function `contingencyTable()` for data extraction requires a list of raster layers as inputs such as `RasterBrick`, `RasterStack`, or a path to a folder containing the rasters. Note that the name of the rasters must be in the format: "text" + "underscore" + "year" (for example, 'landscape_2021'). In this example, we use the **SaoLourencoBasin** `RasterStack`.
```R
# Downloading the SaoLourencoBasin multi-layer raster and make it available into R
url <- "https://zenodo.org/record/3685230/files/SaoLourencoBasin.rda?download=1"
temp <- tempfile()
download.file(url, temp, mode = "wb") # Downloading the SaoLourencoBasin dataset
load(temp)
```
After loading the temporary image file, we inspect the raster description as follows:
```R
SaoLourencoBasin
```
The description of the loaded raster is summarised as follows:
```R
class      : RasterStack 
dimensions : 6372, 6546, 41711112, 5  (nrow, ncol, ncell, nlayers)
resolution : 30, 30  (x, y)
extent     : 654007.5, 850387.5, 8099064, 8290224  (xmin, xmax, ymin, ymax)
crs        : +proj=utm +zone=21 +south +ellps=GRS80 +units=m +no_defs 
names      : landscape_2002, landscape_2008, landscape_2010, landscape_2012, landscape_2014 
min values :              2,              2,              2,              2,              2 
max values :             13,             13,             13,             13,             13
```

<a name="extract_data"></a>

### C. Extract Data from the Raster Time-Series
```R
SL_2002_2014 <- contingencyTable(input_raster = SaoLourencoBasin, pixelresolution = 30)
SL_2002_2014
```
The description of the outputs from extracting the data are as follows:
```R
$lulc_Multistep
# A tibble: 130 x 8
   Period     From    To      km2 QtPixel Interval yearFrom yearTo
   <chr>     <int> <int>    <dbl>   <int>    <int>    <int>  <int>
 1 2002-2008     2     2 6543.    7269961        6     2002   2008
 2 2002-2008     2    10    1.56     1736        6     2002   2008
 3 2002-2008     2    11   55.2     61320        6     2002   2008
 4 2002-2008     2    12   23.9     26609        6     2002   2008
 5 2002-2008     3     2   37.5     41649        6     2002   2008
 6 2002-2008     3     3 2133.    2370190        6     2002   2008
 7 2002-2008     3     7  155.     172718        6     2002   2008
 8 2002-2008     3    11    7.48     8307        6     2002   2008
 9 2002-2008     3    12    0.356     395        6     2002   2008
10 2002-2008     3    13    0.081      90        6     2002   2008
# … with 120 more rows

$lulc_Onestep
# A tibble: 45 x 8
   Period     From    To     km2 QtPixel Interval yearFrom yearTo
   <chr>     <int> <int>   <dbl>   <int>    <int>    <int>  <int>
 1 2002-2014     2     2 6169.   6854816       12     2002   2014
 2 2002-2014     2     9    2.39    2651       12     2002   2014
 3 2002-2014     2    10   10.4    11513       12     2002   2014
 4 2002-2014     2    11  412.    457631       12     2002   2014
 5 2002-2014     2    12   29.7    33015       12     2002   2014
 6 2002-2014     3     2  110.    121762       12     2002   2014
 7 2002-2014     3     3 2091.   2323665       12     2002   2014
 8 2002-2014     3     7  116.    129304       12     2002   2014
 9 2002-2014     3     9    7.00    7774       12     2002   2014
10 2002-2014     3    11    9.32   10359       12     2002   2014
# … with 35 more rows

$tb_legend
# A tibble: 11 x 3
   categoryValue categoryName color  
           <int> <fct>        <chr>  
 1             2 TKU          #002F70
 2             3 SFZ          #F9EFEF
 3             4 EGS          #DCE2F6
 4             5 MFN          #EFF1F8
 5             7 KUD          #EAACAC
 6             8 OSE          #A13F3F
 7             9 NIV          #ABBBE8
 8            10 VDC          #7F2A2B
 9            11 KSW          #F9DCDC
10            12 QIZ          #0A468D
11            13 SFN          #4A76C7

$totalArea
# A tibble: 1 x 2
  area_km2  QtPixel
     <dbl>    <int>
1   22418. 24908860

$totalInterval
[1] 12
```

<a name="edit_categories"></a>

### C. Edit Categories
The `tb_legend` object should be edited with the appropriate names and colors associated with the land cover categories. to edit the category names and the color of categories in the legend, we do the following:
```R
## Edit the category name
SL_2002_2014$tb_legend$categoryName <- factor(c("Ap", "FF", "SA", "SG", "aa", "SF", "Agua", "Iu", "Ac", "R", "Im"),
                                       levels = c("FF", "SF", "SA", "SG", "aa", "Ap", "Ac", "Im", "Iu", "Agua", "R"))

## Add the colors of each category by using the same order of the legend, which can be done by specifying the color name (e.g., "black") or the HEX value (e.g., #000000)
SL_2002_2014$tb_legend$color <- c("#FFE4B5", "#228B22", "#00FF00", "#CAFF70", 
                                  "#EE6363", "#00CD00", "#436EEE", "#FFAEB9", 
                                  "#FFA54F", "#68228B", "#636363")
```
After executing these steps, we can check the edited names and colors of the land cover categories by using:
```R
SL_2002_2014$tb_legend
```
The summary description is shown as follows:
```R
# A tibble: 11 x 3
   categoryValue categoryName color  
           <int> <fct>        <chr>  
 1             2 Ap           #FFE4B5
 2             3 FF           #228B22
 3             4 SA           #00FF00
 4             5 SG           #CAFF70
 5             7 aa           #EE6363
 6             8 SF           #00CD00
 7             9 Agua         #436EEE
 8            10 Iu           #FFAEB9
 9            11 Ac           #FFA54F
10            12 R            #68228B
11            13 Im           #636363
```
