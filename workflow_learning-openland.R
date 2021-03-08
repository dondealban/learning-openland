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

# QUANTIFY AND VISUALISE LULCC -----------
## Generate evolution barplot
barplotLand(dataset = SL_2002_2014$lulc_Multistep, 
            legendtable = SL_2002_2014$tb_legend,
            xlab = "Year",
            ylab = bquote("Area (" ~ km^2~ ")"),
            area_km2 = TRUE)

## Generate barplot of net and gross changes
netgrossplot(dataset = SL_2002_2014$lulc_Multistep,
             legendtable = SL_2002_2014$tb_legend,
             xlab = "LUC Category",
             ylab = bquote("Area (" ~ km^2 ~ ")"),
             changesLabel = c(GC = "Gross changes", NG = "Net Gain", NL = "Net Loss"),
             color = c(GC = "gray70", NG = "#006400", NL = "#EE2C2C"))

## Generate chord diagram of land cover transitions
chordDiagramLand(dataset = SL_2002_2014$lulc_Onestep,
                 legendtable = SL_2002_2014$tb_legend)

## Generate one-step Sankey diagram
sankeyLand(dataset = SL_2002_2014$lulc_Onestep,
           legendtable = SL_2002_2014$tb_legend)

## Generate multi-step Sankey diagram
sankeyLand(dataset = SL_2002_2014$lulc_Multistep,
           legendtable = SL_2002_2014$tb_legend)

## Generate map of accumulated changes over all time-intervals
testacc <- acc_changes(SaoLourencoBasin)
testacc

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
## Save map output as png file
tmap::tmap_save(acc_map,
                filename = "acc_map.png",
                width = 7,
                height = 7)


# IMPLEMENT INTENSITY ANALYSIS -----------

## We implement the Intensity Analysis framework by using the function `intensityAnalysis()`.
## Note here that for the transition-level Intensity Analysis, the selected `category_n` (or 'To N') is "Ap"
## and `category_m` is "SG" (or 'From M'):
testSL <- intensityAnalysis(dataset = SL_2002_2014, category_n = "Ap", category_m = "SG")
names(testSL)   # Inspect list of objects
testSL          # Show objects

## Interval-Level Intensity Analysis
plot_intervalIA <- plot(testSL$interval_lvl,
                        labels = c(leftlabel = "Interval Change Area (%)",
                        rightlabel = "Annual Change Area (%)"),
                        marginplot = c(-8, 0), labs = c("Changes", "Uniform Rate"), 
                        leg_curv = c(x = 2/10, y = 3/10))
plot(plot_intervalIA)

## Category-Level Intensity Analysis
## Gain Category
plot_category_g_IA <- plot(testSL$category_lvlGain, labels = c(leftlabel = bquote("Gain Area (" ~ km^2 ~ ")"),
                                                    rightlabel = "Intensity Gain (%)"),
                                                    marginplot = c(.3, .3), labs = c("Categories", "Uniform Rate"), 
                                                    leg_curv = c(x = 5/10, y = 5/10))
plot(plot_category_g_IA)
## Loss Category
plot_category_l_IA <- plot(testSL$category_lvlLoss, labels = c(leftlabel = bquote("Loss Area (" ~ km^2 ~ ")"),
                                                    rightlabel = "Loss Intensity (%)"),
                                                    marginplot = c(.3, .3), labs = c("Categories", "Uniform Rate"), 
                                                    leg_curv = c(x = 5/10, y = 5/10))
plot(plot_category_l_IA)

## Transition-Level Intensity Analysis
## Gain of the `n` Category 'Ap'
plot_transition_g_IA <- plot(testSL$transition_lvlGain_n,
                             labels = c(leftlabel = bquote("Gain of Ap (" ~ km^2 ~ ")"),
                             rightlabel = "Intensity Gain of Ap (%)"),
                             marginplot = c(.3, .3), labs = c("Categories", "Uniform Rate"), 
                             leg_curv = c(x = 5/10, y = 5/10))
plot(plot_transition_g_IA)
## Loss of the `m` Category 'SG'
plot_transition_l_IA <- plot(testSL$transition_lvlLoss_m, 
                             labels = c(leftlabel = bquote("Loss of SG (" ~ km^2 ~ ")"),
                             rightlabel = "Intensity Loss of SG (%)"),
                             marginplot = c(.3, .3), labs = c("Categories", "Uniform Rate"), 
                             leg_curv = c(x = 1/10, y = 5/10))
plot(plot_transition_l_IA)
