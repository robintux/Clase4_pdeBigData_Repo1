#### COnfiguraciones Iniciales ####

# Limpiamos memoria 
rm(list = ls())
library(tidyverse)
library(sf)
library(ggrepel)

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

#### Primer Mapa ####
ggplot(data = peru_sf)+
  geom_sf()

# Guardar en el directorio de outputs este grafico 
ggsave(filename = paste0(wd$outputs, "MapaBasePeru.png"),
                         width = 8.5,
                         height = 11)

# LIsta de Departamentos 
unique(peru_sf$NOMBDEP)

#### Mapara de Junin ####
ggplot(data = peru_sf %>% 
         filter(NOMBDEP == "JUNIN"))+
  geom_sf()
# 
# Guardamos en disco duro 
ggsave(filename = paste0(wd$outputs, "mapaJunin.png"),
       width = 8, height = 8)

#### Calculo de centroides ####
peru_sf <- peru_sf %>% mutate(centroid = map(geometry, st_centroid),
                              coords = map(centroid, st_coordinates),
                              coords_x = map_dbl(coords, 1),
                              coords_y = map_dbl(coords, 2)
                              )

#### Coloquemos las etiquetas a cada dpto ####
ggplot(data = peru_sf)+
  geom_sf(fill = "skyblue", color = "black", alpha = 0.7)+
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBDEP),
                  size = 2)
# 
# Guardamos en disco duro 
ggsave(filename = paste0(wd$outputs, "mapaPeru_Centroide.png"),
       width = 8.5,
       height =11)

#### Carguemos la informacion social ####
# Educacion y Pobreza
# 
# Tasa de Pobreza 2016
povrate2k16 <- read_csv(paste0(wd$datasets, "povrate2016.csv"))

# Años de educacion promedio 2016
educ2k16 <- read_csv(paste0(wd$datasets, "educ2016.csv"))


# Juntemos nuestra bd
peru_datos <- peru_sf %>% 
  left_join(povrate2k16) %>% 
  left_join(educ2k16)

#### Grafico 1 : Tasa de pobreza 2016 ####
ggplot(peru_datos)+
  geom_sf(aes(fill = poor))+
  labs(title = "Poblacion pobre por dpto 2016",
       caption = "Fuente de datos : ENAHO 2016",
       x = "Longitud",
       y = "Latitud",
       fill = "Tasa de Pobreza")+
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBDEP),
                  size = 2)
ggsave(paste0(wd$outputs, "MapaPobrezaDpto1k16.png"))


#### Grafico 2 : Años de estudio promedio 2016
ggplot(peru_datos)+
  geom_sf(aes(fill = educ))+
  labs(title = "Años de educacion promedio \npor Departamento (2016)",
       caption = "Fuente de datos : ENAHO 2016",
       x = "Longitud",
       y = "Latitud",
       fill = "Años de Educacion")+
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBDEP),
                  size = 2,
                  max.overlaps = Inf)
ggsave(paste0(wd$outputs, "MapaEducDpto1k16.png"),
       width = 8.5, height = 11)

#### Grafico 3 : Viendo pobreza y educacion ####
ggplot(peru_datos)+
  geom_sf(mapping = aes(fill = poor))+
  geom_point(aes(x = coords_x , y = coords_y, size = educ), color = "darkseagreen")+
  labs(title = "Pobreza y educacion : 2016",
       x = "Longitud",
       y = "Latitud",
       caption = "Fuente : ENAHO 2016",
       fill = "Tasa de Pobresa",
       size = "Años de educacion")+
  geom_text_repel(data = peru_datos %>% 
                    filter(poor > 0.3),
    mapping = aes(x = coords_x, y = coords_y, label = NOMBDEP),
                  size = 2,
                  max.overlaps = Inf
                  )
ggsave(filename = paste0(wd$outputs, "PobrezaEducacion2k16.png"),
       width = 8.5,
       height = 11)







































