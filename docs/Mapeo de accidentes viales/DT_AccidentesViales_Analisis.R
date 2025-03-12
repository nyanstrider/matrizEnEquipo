# 📦 Cargar librerías necesarias
library(sf)
library(tidyverse)
library(mapview)

# 📂 1. Cargar datos del CSV con accidentes viales
datos <- read_csv("C:/Users/Emilio/Downloads/indices-de-estadisticas-de-accidentes-viales-monterrey (2).csv")

# 🧐 2. Revisar nombres de columnas para asegurar que usamos las correctas
colnames(datos)

# 📌 3. Convertir dataframe a objeto espacial
puntos <- st_as_sf(datos, coords = c("Longitud", "Latitud"), crs = 4326)

# 📂 4. Cargar el polígono del Distritotec desde el archivo KML
distritotec_poly <- st_read("C:/Users/Emilio/Downloads/Límite DT.kml")

# 🔄 5. Quitar dimensión Z/M si existe
distritotec_poly <- st_zm(distritotec_poly, drop = TRUE, what = "ZM")

# 🔄 6. Verificar y convertir a POLYGON si es necesario
if (st_geometry_type(distritotec_poly)[1] == "LINESTRING") {
  distritotec_poly <- st_cast(distritotec_poly, "POLYGON")
}

# 🗂️ 7. Filtrar los puntos que están dentro del polígono del Distritotec
puntos_filtrados <- st_intersection(puntos, distritotec_poly)

# 📊 8. Revisar cuántos accidentes quedaron dentro del polígono
nrow(puntos_filtrados)

# 🗺️ 9. Visualizar el polígono y los accidentes filtrados en mapa interactivo
mapview(distritotec_poly, color = "red", alpha = 0.2) +
  mapview(puntos_filtrados, col.region = "blue", cex = 1)
