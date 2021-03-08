# This script implements a land cover change analysis workflow using the tools in OpenLand R package (Exavier & Zeilhofer
# 2020). The script uses land cover image datasets from their package vignette
# (https://cran.r-project.org/web/packages/OpenLand/vignettes/openland_vignette.html).
# 
# Script modified by: Jose Don T. De Alban
# Date created:       08 Mar 2021
# Date modified:      


# SET WORKING DIRECTORY ------------------
setwd("/Users/dondealban/Dropbox/Research/learning-openland/")

# LOAD LIBRARIES -------------------------
library(OpenLand)             # Package for quantitative analysis and visualisation of land use/cover change
library(tmap)                 # Package for generating thematic maps

# LOAD RASTER DATA -----------------------
## Downloading the SaoLourencoBasin multi-layer raster and make it available into R
url <- "https://zenodo.org/record/3685230/files/SaoLourencoBasin.rda?download=1"
temp <- tempfile()
download.file(url, temp, mode = "wb") # Downloading the SaoLourencoBasin dataset
load(temp)
SaoLourencoBasin # Inspect the raster description

# EXTRACT DATA ---------------------------
SL_2002_2014 <- contingencyTable(input_raster = SaoLourencoBasin, pixelresolution = 30)
SL_2002_2014 # Inspect the contingency table description

# EDIT CATEGORIES ------------------------
## Edit the category name
SL_2002_2014$tb_legend$categoryName <- factor(c("Ap", "FF", "SA", "SG", "aa", "SF", "Agua", "Iu", "Ac", "R", "Im"),
                                              levels = c("FF", "SF", "SA", "SG", "aa", "Ap", "Ac", "Im", "Iu", "Agua", "R"))
## Add the colors of each category by using the same order of the legend, which can be done by specifying the color name (e.g., "black") or the HEX value (e.g., #000000)
SL_2002_2014$tb_legend$color <- c("#FFE4B5", "#228B22", "#00FF00", "#CAFF70", 
                                  "#EE6363", "#00CD00", "#436EEE", "#FFAEB9", 
                                  "#FFA54F", "#68228B", "#636363")
SL_2002_2014$tb_legend # Check edited names and colors


