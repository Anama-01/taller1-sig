# Código en R

library(starsdata)
library(terra)
library(stars)
library(reticulate)

# 1. Localización del ZIP dentro del paquete starsdata
f <- "sentinel/S2A_MSIL1C_20180220T105051_N0206_R051_T32ULE_20180221T134037.zip"
granule <- system.file(file = f, package = "starsdata")
granule

# 2. Construcción de la ruta Virtual de GDAL (/vsizip/)
# Rompemos la cadena en varias líneas para que LaTeX pueda procesarla
base_name <- strsplit(basename(granule), ".zip")[[1]]
base_name


# Esta ruta permite leer directamente el XML de metadatos dentro del ZIP sin descomprimir.
#s2_path <- paste0("SENTINEL2_L1C:/vsizip/", granule, "/", base_name, ".SAFE/MTD_MSIL1C.xml:10m:EPSG_32632")
s2_path <- paste0(
  "SENTINEL2_L1C:/vsizip/", 
  granule, 
  "/", 
  base_name, 
  ".SAFE/MTD_MSIL1C.xml:10m:EPSG_32632"
)
#s2_path

# Mostramos el resultado sin comillas ni índices [1] para el libro
cat("Ruta generada:", s2_path, fill = TRUE)

# Guardamos la ruta en un archivo compartido para que Python y Julia la lean
writeLines(s2_path, "s2_shared_path.txt")

