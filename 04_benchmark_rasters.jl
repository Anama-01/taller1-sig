# Código en Julia
using Rasters, ArchGDAL, Statistics, Plots

# Evita restricciones artificiales de memoria
Rasters.checkmem!(false)

# ------------------------------------------------
# 1. Leer ruta compartida
# ------------------------------------------------
path = strip(read("s2_shared_path.txt", String))

# ------------------------------------------------
# 2. FUNCIÓN DE BENCHMARK (proxy + mean)
# ------------------------------------------------
function process_band_mean(path)
    ArchGDAL.read(path) do ds
        r   = Raster(ds)[Band(1)]   # proxy, solo banda 4
        res = r .* 1.5              # operación lazy
        return mean(res)            # FORZADO REAL (streaming)
    end
end

# ------------------------------------------------
# 3. WARM-UP (compilación)
# ------------------------------------------------
process_band_mean(path)
GC.gc()

# ------------------------------------------------
# 4. BENCHMARK REAL
# ------------------------------------------------
t0 = time_ns()
m_julia = process_band_mean(path)
t1 = time_ns()

t_julia = (t1 - t0) / 1e9

println("🟣 Julia: ", round(t_julia, digits=3), " seg | mean = ", round(m_julia, digits=6))


# ------------------------------------------------
# 5. Plot (FUERA DEL BENCHMARK, proxy)
# ------------------------------------------------
ArchGDAL.read(path) do ds
    r   = Raster(ds)[Band(1)]
    res = r .* 1.5
    p = plot(res, colormap = :terrain,
         title = "Julia: Banda 4 × 1.5")
    savefig(p, "julia_plot.png")
end

# Debe ser la última para que j_eval en R capture solo el número
t_julia