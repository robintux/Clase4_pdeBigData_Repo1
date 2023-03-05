#### COnfiguraciones Iniciales ####

# Limpiamos memoria 
rm(list = ls())
library(tidyverse)
library(sf)


#### Datos ####
# Definamos una estructura de directorios , tanto para inputs 
# como para outputs
wd <- list()
# 
wd$root <- "C:/Users/azamudio/Desktop/Clase4_pdeBigData/Clase4_pdeBigData_Repo1/"
wd$inputs <- paste0(wd$root, "01_inputs/01_inputs/")
wd$shapef <- paste0(wd$inputs, "shapefiles/")
wd$datasets <- paste0(wd$inputs, "datasets/")
wd$outputs <- paste0(wd$root, "02_outputs/")

# Carguemos en memoria la informacion espacial 
peru_sf <- st_read(paste0(wd$shapef, "INEI_LIMITE_DEPARTAMENTAL.shp"))






