# Learning the OpenLand R package
This is a repository set up as my personal exercise for learning land use/cover change analysis of time-series data using the [OpenLand](https://cran.r-project.org/web/packages/OpenLand/index.html) R package. It can also be used as a tutorial for someone interested in learning spatiotemporal land use/cover change analysis for their research projects. 

## Table of Contents
- [An OpenLand Workflow Example](#workflow)
    + [Load Packages](#load_packages) 
    + [Load Rasters](#load_rasters)
    + [Extract Data from the Raster Time-Series](#extract_data)
    + [Edit Categories](#edit_categories)
    + [Quantify and Visualise Land Cover Change](#quantify_visualise)
    + [Implement Intensity Analysis](#intensity_analysis)
- [References](#references)

<a name="workflow"></a>

## An `OpenLand` Workflow Example
Here, I implemented the workflow from the [vignette](https://cran.r-project.org/web/packages/OpenLand/vignettes/openland_vignette.html) on how to use OpenLand package in R software developed by the authors, Reginal Exavier and Peter Zeilhofer. Users can modify this to suit their objectives.

<a name="load_packages"></a>

### A. Load Packages
Prior to loading packages, you can set your working directory using `setwd()` and indicate your working directory path. The `OpenLand` and `tmap` R packages/libraries wer used for this exercise. To load the packages we can write:
```R
library(OpenLand)             # Package for quantitative analysis and visualisation of land use/cover change
library(tmap)                 # Package for generating thematic maps
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

### D. Edit Categories
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
The summary description is then shown as follows:
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

<a name="net_gross_gain_loss"></a>

### E. Quantify and Visualise Land Cover Changes
Here, we quantify the net and gross changes of all land cover categories, specifically both their gains and losses, and generate visualisations of the areal extents of the land cover changes/transitions.

#### Evolution Barplot of Total Areal Extent of Land Cover Categories per Time-Point
First, we can generate the evolution barplot to visualise the total areal extent of each land cover category per time-point as follows:
```R
barplotLand(dataset = SL_2002_2014$lulc_Multistep, 
            legendtable = SL_2002_2014$tb_legend,
            xlab = "Year",
            ylab = bquote("Area (" ~ km^2~ ")"),
            area_km2 = TRUE)
```

#### Barplot of Net and Gross Changes of Land Cover Categories
Next, we can generate the barplot to visualise the net and gross changes of land cover categories as follows:
```R
netgrossplot(dataset = SL_2002_2014$lulc_Multistep,
             legendtable = SL_2002_2014$tb_legend,
             xlab = "LUC Category",
             ylab = bquote("Area (" ~ km^2 ~ ")"),
             changesLabel = c(GC = "Gross changes", NG = "Net Gain", NL = "Net Loss"),
             color = c(GC = "gray70", NG = "#006400", NL = "#EE2C2C"))
```

#### Chord Diagram of Land Cover Transitions
Next, we can generate a chord diagram to visualise the gross transitions of land cover across the entire time-period as follows:
```R
chordDiagramLand(dataset = SL_2002_2014$lulc_Onestep,
                 legendtable = SL_2002_2014$tb_legend)
```

#### Sankey Diagrams of Land Cover Transitions
Next, we can generate a two variations of Sankey diagrams to visualise the gross transitions of land cover: first, across the entire time-period; and second, per time-interval, as follows:

+ Entire time-period (one-step)
```R
sankeyLand(dataset = SL_2002_2014$lulc_Onestep,
           legendtable = SL_2002_2014$tb_legend)
```

+ All time-intervals (multi-step)
```R
sankeyLand(dataset = SL_2002_2014$lulc_Multistep,
           legendtable = SL_2002_2014$tb_legend)
```

#### Sankey Diagrams of Land Cover Transitions
Finally, we can generate a map showing the accumulated changes in pixels at each of the four time-intervals between the entire 2002-2014 time-period as follows:
```R
testacc <- acc_changes(SaoLourencoBasin)
testacc
```
The summary of the generated raster layer and table are as follows:
```R
[[1]]
class      : RasterLayer 
dimensions : 6372, 6546, 41711112  (nrow, ncol, ncell)
resolution : 30, 30  (x, y)
extent     : 654007.5, 850387.5, 8099064, 8290224  (xmin, xmax, ymin, ymax)
crs        : +proj=utm +zone=21 +south +ellps=GRS80 +units=m +no_defs 
source     : r_tmp_2021-03-08_131306_2333_99988.grd 
names      : layer 
values     : 0, 2  (min, max)


[[2]]
# A tibble: 3 x 3
  PxValue       Qt Percent
    <int>    <int>   <dbl>
1       0 21819779   87.6 
2       1  2787995   11.2 
3       2   301086    1.21
```
We can also plot the map with the `tmap` function as follows:
```R
tmap_options(max.raster = c(plot = 41711112, view = 41711112))

acc_map <- tmap::tm_shape(testacc[[1]]) +
  tmap::tm_raster(
    style = "cat",
    labels = c(
      paste0(testacc[[2]]$PxValue[1], " Change", " (", round(testacc[[2]]$Percent[1], 2), "%", ")"),
      paste0(testacc[[2]]$PxValue[2], " Change", " (", round(testacc[[2]]$Percent[2], 2), "%", ")"),
      paste0(testacc[[2]]$PxValue[3], " Changes", " (", round(testacc[[2]]$Percent[3], 2), "%", ")")
    ),
    palette = c("#757575", "#FFD700", "#CD0000"),
    title = "Changes in the interval \n2002 - 2014"
  ) +
  tmap::tm_legend(
    position = c(0.01, 0.2),
    legend.title.size = 1.2,
    legend.title.fontface = "bold",
    legend.text.size = 0.8
  ) +
  tmap::tm_compass(type = "arrow",
                   position = c("right", "top"),
                   size = 3) +
  tmap::tm_scale_bar(
    breaks = c(seq(0, 40, 10)),
    position = c(0.76, 0.001),
    text.size = 0.6
  ) +
  tmap::tm_credits(
    paste0(
      "Case of Study site",
      "\nAccumulate changes from 2002 to 2014",
      "\nData create with OpenLand package",
      "\nLULC derived from Embrapa Pantanal, Instituto SOS Pantanal, and WWF-Brasil 2015."
    ),
    size = 0.7,
    position = c(0.01, -0, 01)
  ) +
  tmap::tm_graticules(
    n.x = 6,
    n.y = 6,
    lines = FALSE,
    #alpha = 0.1
    labels.rot = c(0, 90)
  ) +
  tmap::tm_layout(inner.margins = c(0.02, 0.02, 0.02, 0.02))

tmap::tmap_save(acc_map,
                filename = "acc_map.png",
                width = 7,
                height = 7)

```

<a name="intensity_analysis"></a>

### F. Implement Intensity Analysis
The **Intensity Analysis** framework [(Aldwaik & Pontius 2012)](#aldwaik_pontius_2012) is a quantitative method to analyse land cover change over time for an area of interest to summarise the change within time-intervals. Different types of information are extracted at three levels of analysis: interval, category, and transition, which progress from general to more detailed levels. At the ***interval level***, the total change in each time-interval is analysed to examine how the size and annual rate of change vary across time-intervals (i.e., to answer in which time-intervals are the overall annual rate of change relatively slow or fast). At the ***category level***, each land cover category is examined to measure how the size and intensity of both gross losses and gross gains vary across space (i.e., to answer which categories are relatively dormant versus active in a given time-interval, and to determine if the pattern is stable across time-intervals). Finally, at the ***transition level***, a particular transition is analysed to examine how the size and intensity of the transition vary among categories available for that transition (i.e., to answer which transitions are intensively targeted versus avoided by a given land category in a given time-interval, and to determine if the pattern is stable across time-intervals).

Previously, I implemented the Intensity Analysis framework for my land change studies using the [Microsoft Excel Macro](https://sites.google.com/site/intensityanalysis/home) and using the `intensity.analysis` R package implementation [(Pontius & Khallaghi 2019)](https://cran.r-project.org/web/packages/intensity.analysis/index.html), of which the latter I had also created a working tutorial for learning the R package implementation (see this GitHub [repository](https://github.com/dondealban/learning-intensity-analysis)). This time, I am testing the implementation using the `OpenLand` R package.

We implement the Intensity Analysis framework by using the function `intensityAnalysis()`. Note here that for the transition-level Intensity Analysis, the selected `category_n` (or 'To N') is "Ap"  and `category_m` is "SG" (or 'From M'):
```R
testSL <- intensityAnalysis(dataset = SL_2002_2014, category_n = "Ap", category_m = "SG")
```
To inspect the list of objects generated by the the `intensityAnalysis()` function, we can use:
```R
names(testSL)
```
Doing this returns a list of objects as follows:
```R
[1] "lulc_table"           "interval_lvl"         "category_lvlGain"     "category_lvlLoss"     "transition_lvlGain_n"
[6] "transition_lvlLoss_m"
```
To show the objects from the Intensity Analysis, we can type:
```R
testSL
```
The summary of the objects from the Intensity Analysis are as follows:
```R
$lulc_table
# A tibble: 130 x 6
   Period    From  To         km2 QtPixel Interval
   <fct>     <fct> <fct>    <dbl>   <int>    <int>
 1 2002-2008 Ap    Ap    6543.    7269961        6
 2 2002-2008 Ap    Iu       1.56     1736        6
 3 2002-2008 Ap    Ac      55.2     61320        6
 4 2002-2008 Ap    R       23.9     26609        6
 5 2002-2008 FF    Ap      37.5     41649        6
 6 2002-2008 FF    FF    2133.    2370190        6
 7 2002-2008 FF    aa     155.     172718        6
 8 2002-2008 FF    Ac       7.48     8307        6
 9 2002-2008 FF    R        0.356     395        6
10 2002-2008 FF    Im       0.081      90        6
# … with 120 more rows

$interval_lvl
An object of class "Interval"
Slot "intervalData":
# A tibble: 4 x 4
# Groups:   Period [4]
  Period    PercentChange    St     U
  <fct>             <dbl> <dbl> <dbl>
1 2012-2014         3.32  1.66   1.13
2 2010-2012         4.23  2.12   1.13
3 2008-2010         0.880 0.440  1.13
4 2002-2008         5.18  0.864  1.13


$category_lvlGain
An object of class "Category"
Slot "lookupcolor":
       Ap        FF        SA        SG        aa        SF      Agua        Iu        Ac         R        Im 
"#FFE4B5" "#228B22" "#00FF00" "#CAFF70" "#EE6363" "#00CD00" "#436EEE" "#FFAEB9" "#FFA54F" "#68228B" "#636363" 

Slot "categoryData":
# A tibble: 23 x 6
# Groups:   Period, To [23]
   Period    To    Interval  GG_km2   Gtj    St
   <fct>     <fct>    <int>   <dbl> <dbl> <dbl>
 1 2012-2014 aa           2  14.9   0.510  1.66
 2 2012-2014 Ap           2 612.    3.92   1.66
 3 2012-2014 Ac           2 110.    1.14   1.66
 4 2012-2014 Im           2   0.195 0.337  1.66
 5 2012-2014 Iu           2   6.79  2.67   1.66
 6 2010-2012 aa           2  47.0   1.18   2.12
 7 2010-2012 Ap           2 707.    4.84   2.12
 8 2010-2012 Ac           2 189.    2.00   2.12
 9 2010-2012 Iu           2   1.90  0.792  2.12
10 2010-2012 R            2   2.76  0.951  2.12
# … with 13 more rows

Slot "categoryStationarity":
# A tibble: 12 x 5
   To     Gain     N Stationarity Test 
   <fct> <int> <int> <chr>        <chr>
 1 aa        2     4 Active Gain  N    
 2 Ap        2     4 Active Gain  N    
 3 Ac        1     4 Active Gain  N    
 4 Iu        2     4 Active Gain  N    
 5 Agua      1     4 Active Gain  N    
 6 R         2     4 Active Gain  N    
 7 aa        2     4 Dormant Gain N    
 8 Ap        2     4 Dormant Gain N    
 9 Ac        3     4 Dormant Gain N    
10 Im        3     4 Dormant Gain N    
11 Iu        2     4 Dormant Gain N    
12 R         1     4 Dormant Gain N    


$category_lvlLoss
An object of class "Category"
Slot "lookupcolor":
       Ap        FF        SA        SG        aa        SF      Agua        Iu        Ac         R        Im 
"#FFE4B5" "#228B22" "#00FF00" "#CAFF70" "#EE6363" "#00CD00" "#436EEE" "#FFAEB9" "#FFA54F" "#68228B" "#636363" 

Slot "categoryData":
# A tibble: 29 x 6
# Groups:   Period, From [29]
   Period    From  Interval GL_km2     Lti    St
   <fct>     <fct>    <int>  <dbl>   <dbl> <dbl>
 1 2012-2014 FF           2  15.4   0.365   1.66
 2 2012-2014 SF           2   3.49  0.224   1.66
 3 2012-2014 SA           2  25.3   0.845   1.66
 4 2012-2014 SG           2  46.9   0.634   1.66
 5 2012-2014 aa           2 541.   13.6     1.66
 6 2012-2014 Ap           2 111.    0.759   1.66
 7 2012-2014 Ac           2   1.26  0.0133  1.66
 8 2010-2012 FF           2  11.1   0.263   2.12
 9 2010-2012 SF           2   4.44  0.283   2.12
10 2010-2012 SA           2  29.7   0.974   2.12
# … with 19 more rows

Slot "categoryStationarity":
# A tibble: 14 x 5
   From   Loss     N Stationarity Test 
   <fct> <int> <int> <chr>        <chr>
 1 FF        1     4 Active Loss  N    
 2 SF        2     4 Active Loss  N    
 3 SA        2     4 Active Loss  N    
 4 SG        2     4 Active Loss  N    
 5 aa        3     4 Active Loss  N    
 6 Ap        1     4 Active Loss  N    
 7 R         1     4 Active Loss  N    
 8 FF        3     4 Dormant Loss N    
 9 SF        2     4 Dormant Loss N    
10 SA        2     4 Dormant Loss N    
11 SG        2     4 Dormant Loss N    
12 aa        1     4 Dormant Loss N    
13 Ap        3     4 Dormant Loss N    
14 Ac        4     4 Dormant Loss Y    


$transition_lvlGain_n
An object of class "Transition"
Slot "lookupcolor":
       Ap        FF        SA        SG        aa        SF      Agua        Iu        Ac         R        Im 
"#FFE4B5" "#228B22" "#00FF00" "#CAFF70" "#EE6363" "#00CD00" "#436EEE" "#FFAEB9" "#FFA54F" "#68228B" "#636363" 

Slot "transitionData":
# A tibble: 20 x 7
# Groups:   Period, From [20]
   Period    From  To    Interval T_i2n_km2    Rtin    Wtn
   <fct>     <fct> <fct>    <int>     <dbl>   <dbl>  <dbl>
 1 2012-2014 FF    Ap           2    12.9    0.307  2.03  
 2 2012-2014 SF    Ap           2     2.38   0.152  2.03  
 3 2012-2014 SA    Ap           2    18.1    0.605  2.03  
 4 2012-2014 SG    Ap           2    42.1    0.569  2.03  
 5 2012-2014 aa    Ap           2   537.    13.5    2.03  
 6 2010-2012 FF    Ap           2     3.63   0.0856 2.26  
 7 2010-2012 SF    Ap           2     1.08   0.0685 2.26  
 8 2010-2012 SA    Ap           2    12.3    0.403  2.26  
 9 2010-2012 SG    Ap           2     8.53   0.114  2.26  
10 2010-2012 aa    Ap           2   682.    13.0    2.26  
11 2008-2010 FF    Ap           2     0.968  0.0227 0.0610
12 2008-2010 SF    Ap           2     1.10   0.0694 0.0610
13 2008-2010 SA    Ap           2     0.971  0.0314 0.0610
14 2008-2010 SG    Ap           2     3.94   0.0524 0.0610
15 2008-2010 aa    Ap           2    12.0    0.233  0.0610
16 2002-2008 FF    Ap           6    37.5    0.268  0.323 
17 2002-2008 SF    Ap           6    24.8    0.453  0.323 
18 2002-2008 SA    Ap           6    65.8    0.608  0.323 
19 2002-2008 SG    Ap           6    48.3    0.198  0.323 
20 2002-2008 aa    Ap           6   130.     1.02   0.323 

Slot "transitionStationarity":
# A tibble: 7 x 5
  From   Loss     N Stationarity   Test 
  <fct> <int> <int> <chr>          <chr>
1 SF        2     4 targeted by Ap N    
2 SA        1     4 targeted by Ap N    
3 aa        4     4 targeted by Ap Y    
4 FF        4     4 avoided by Ap  Y    
5 SF        2     4 avoided by Ap  N    
6 SA        3     4 avoided by Ap  N    
7 SG        4     4 avoided by Ap  Y    


$transition_lvlLoss_m
An object of class "Transition"
Slot "lookupcolor":
       Ap        FF        SA        SG        aa        SF      Agua        Iu        Ac         R        Im 
"#FFE4B5" "#228B22" "#00FF00" "#CAFF70" "#EE6363" "#00CD00" "#436EEE" "#FFAEB9" "#FFA54F" "#68228B" "#636363" 

Slot "transitionData":
# A tibble: 14 x 7
# Groups:   Period, To [14]
   Period    To    From  Interval T_m2j_km2     Qtmj    Vtm
   <fct>     <fct> <fct>    <int>     <dbl>    <dbl>  <dbl>
 1 2012-2014 aa    SG           2    4.76   0.163    0.125 
 2 2012-2014 Ap    SG           2   42.1    0.270    0.125 
 3 2012-2014 Ac    SG           2    0.0621 0.000642 0.125 
 4 2010-2012 aa    SG           2   18.9    0.475    0.0749
 5 2010-2012 Ap    SG           2    8.53   0.0584   0.0749
 6 2010-2012 Ac    SG           2    0.632  0.00669  0.0749
 7 2008-2010 aa    SG           2   30.6    0.584    0.0929
 8 2008-2010 Ap    SG           2    3.94   0.0290   0.0929
 9 2008-2010 Ac    SG           2    0.0873 0.000962 0.0929
10 2008-2010 Iu    SG           2    0.0504 0.0213   0.0929
11 2002-2008 aa    SG           6  244.     1.58     0.273 
12 2002-2008 Ap    SG           6   48.3    0.118    0.273 
13 2002-2008 Ac    SG           6   13.1    0.0489   0.273 
14 2002-2008 R     SG           6    0.0999 0.0129   0.273 

Slot "transitionStationarity":
# A tibble: 6 x 5
  To     Gain     N Stationarity Test 
  <fct> <int> <int> <chr>        <chr>
1 aa        4     4 targeted SG  Y    
2 Ap        1     4 targeted SG  N    
3 Ap        3     4 avoided SG   N    
4 Ac        4     4 avoided SG   Y    
5 Iu        1     4 avoided SG   N    
6 R         1     4 avoided SG   N
```
The following can be done to visualise the outputs from Intensity Analysis at three levels: interval, category, and transition:

#### Interval-Level Intensity Analysis
For interval-level IA, we can plot the visualisation graphs as follows:
```R
plot_intervalIA <- plot(testSL$interval_lvl, labels = c(leftlabel = "Interval Change Area (%)",
                                             rightlabel = "Annual Change Area (%)"),
                                             marginplot = c(-8, 0), labs = c("Changes", "Uniform Rate"), 
                                             leg_curv = c(x = 2/10, y = 3/10))
```

#### Category-Level Intensity Analysis
For category-level IA, we can plot the visualisation graphs as follows:
+ Gain Category
```R
plot(testSL$category_lvlGain, labels = c(leftlabel = bquote("Gain Area (" ~ km^2 ~ ")"),
                              rightlabel = "Intensity Gain (%)"),
                              marginplot = c(.3, .3), labs = c("Categories", "Uniform Rate"), 
                              leg_curv = c(x = 5/10, y = 5/10))
```

+ Loss Category
```R
plot(testSL$category_lvlLoss, labels = c(leftlabel = bquote("Loss Area (" ~ km^2 ~ ")"),
                              rightlabel = "Loss Intensity (%)"),
                              marginplot = c(.3, .3), labs = c("Categories", "Uniform Rate"), 
                              leg_curv = c(x = 5/10, y = 5/10))
```

#### Transition-Level Intensity Analysis
For transition-level IA, we can plot the visualisation graphs as follows:
+ Gain of the `n` Category 'Ap'
```R
plot(testSL$transition_lvlGain_n, labels = c(leftlabel = bquote("Gain of Ap (" ~ km^2 ~ ")"),
                                  rightlabel = "Intensity Gain of Ap (%)"),
                                  marginplot = c(.3, .3), labs = c("Categories", "Uniform Rate"), 
                                  leg_curv = c(x = 5/10, y = 5/10))
```

+ Loss of the `m` Category 'SG'
```R
plot(testSL$transition_lvlLoss_m, labels = c(leftlabel = bquote("Loss of SG (" ~ km^2 ~ ")"),
                                  rightlabel = "Intensity Loss of SG (%)"),
                                  marginplot = c(.3, .3), labs = c("Categories", "Uniform Rate"), 
                                  leg_curv = c(x = 1/10, y = 5/10))
```


<a name="references"></a>

## References

<a name="aldwaik_pontius_2012"></a>
Aldwaik, S.Z., Pontius, R.G. (2012) Intensity analysis to unify measurements of size and stationarity of land changes by interval, category, and transition. *Landscape and Urban Planning*, 202, 18–27. [doi:10.1016/j.landurbplan.2012.02.010](https://doi.org/10.1016/j.landurbplan.2012.02.010)

<a name="pontius_khallaghi_2019"></a>
Pontius, R.G., Khallaghi, S. (2019) intensity.analysis: Intensity of Change for Comparing Categorical Maps from Sequential Intervals. [CRAN](https://cran.r-project.org/web/packages/intensity.analysis/index.html)

