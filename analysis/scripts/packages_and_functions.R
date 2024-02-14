# clear all objects including hidden objects ----------
rm(list = ls(all.names = TRUE)) 

# free up memory and report memory usage --------------
gc()

# load packages of general use across the project --------------
library(tidyverse)
library(cowplot)
library(png)
library(patchwork)
library(RColorBrewer)

# define some colour-blind-friendly colour palettes --------------
#From Color Universal Design (CUD): https://jfly.uni-koeln.de/color/
Okabe_Ito <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", 
               "#CC79A7", "#000000")
blues <- brewer.pal(9, 'Blues')
bluepurple <- brewer.pal(9, 'BuPu')
oranges <- brewer.pal(9, 'YlOrRd')

#add your favourite colour palettes

# show as coloured pie charts --------------

dev.new()
pie(rep(1,8), col=Okabe_Ito, Okabe_Ito, main='Okabe Ito')

# save session info and Rstudio version info for reproducibility ----------------
writeLines(capture.output(sessionInfo()), "code/sessionInfo.txt")
writeLines(capture.output(rstudioapi::versionInfo()), "code/versionInfo.txt")

# functions of general use ---------------


