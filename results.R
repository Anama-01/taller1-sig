# Código en R
library(knitr)
library(kableExtra)

#Resultados de los lenguajes
t_python <- 15.439 #seg
t_julia <- 56.585 #seg

# Creamos el dataframe con los datos capturados
resultados <- data.frame(
  Motor = c("R: terra", "R: stars", "Python: rasterio", "Julia: Rasters.jl"),
  Lenguaje = c("R (C++)", "R", "Python (C++/NumPy)", "Julia (Nativo)"),
  Paralelismo = c("Monohilo", "Monohilo", "SIMD (Vectorizado)", "Multihilo (12 hilos)"),
  Tiempo_Seg = c(t_terra, t_stars, t_python, t_julia)
)
resultados
# Cálculo de eficiencia: ¿Cuántas veces es más rápido que el más lento?
max_t <- max(resultados$Tiempo_Seg, na.rm = TRUE)
resultados$X_mas_rapido <- round(max_t / resultados$Tiempo_Seg, 2)

# Formateo elegante para el HTML
kable(resultados, 
      digits = 3, 
      caption = "Duelo de Titanes: Procesamiento de 1GB Sentinel-2",
      col.names = c("Motor", "Lenguaje", "Paralelismo", "Tiempo (s)", "Eficiencia (X)")) %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"), 
                full_width = F) %>%
  row_spec(which.min(resultados$Tiempo_Seg), bold = T, color = "white", background = "#2c3e50")