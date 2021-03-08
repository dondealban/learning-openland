# Learning the OpenLand R package
This is a repository set up as my personal exercise for learning land use/cover change analysis of time-series data using the [OpenLand](https://cran.r-project.org/web/packages/OpenLand/index.html) R package. It can also be used as a tutorial for someone interested in learning spatiotemporal land use/cover change analysis for their research projects. 

## Table of Contents
- [An OpenLand Workflow Example](#workflow)
    + [Load Packages](#load_packages) 
    + [Load Rasters](#load_rasters)

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
the function `contingencyTable()` for data extraction requires a list of raster layers as inputs such as `RasterBrick`, `RasterStack`, or a path to a folder containing the rasters. Note that the name of the rasters must be in the format: "text" + "underscore" + "year" (for example, 'landscape_2021'). In this example, we use the SaoLourencoBasin `RasterStack`.
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