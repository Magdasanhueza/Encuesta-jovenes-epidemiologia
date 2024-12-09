
# Cargar librerías necesarias
library(dplyr)
library(ggplot2)
library(caret) # Para modelos predictivos

# 1. Cargar los datos
data <- read.dta("BBDD_Encuesta_Jovenes.dat", convert.factors = TRUE)

# 2. Limpieza de datos
# Identificar valores faltantes
missing_summary <- sapply(data, function(x) sum(is.na(x)))
print("Resumen de valores faltantes:")
print(missing_summary)

# Eliminar columnas con más del 50% de datos faltantes (si aplica)
data <- data[, colSums(is.na(data)) / nrow(data) < 0.5]

# Reemplazar valores faltantes en variables numéricas por la mediana
numeric_vars <- sapply(data, is.numeric)
data[, numeric_vars] <- lapply(data[, numeric_vars], function(x) {
  ifelse(is.na(x), median(x, na.rm = TRUE), x)
})

# Reemplazar valores faltantes en variables categóricas por la moda
categorical_vars <- sapply(data, is.factor)
data[, categorical_vars] <- lapply(data[, categorical_vars], function(x) {
  ifelse(is.na(x), levels(x)[which.max(table(x))], x)
})

# 3. Selección de la variable dependiente
# Variable dependiente: P103 (tratamiento de salud mental)
data <- data %>% filter(P103 %in% c("1. Si", "2. No")) # Excluir NS/NR
data$P103 <- ifelse(data$P103 == "1. Si", 1, 0) # Recodificar como 0 y 1

# Frecuencia de la variable dependiente
dep_freq <- table(data$P103)
prop.table(dep_freq)

# 4. Selección de variables independientes
# Seleccionar 10 variables relevantes (mixtas)
independent_vars <- c("SEXO", "REGION", "NSE", "GSE_AIM", "ZONA", "EDAD", "POND", "C10i1", "P6_1", "FACTOR")
data <- data %>% select(P103, all_of(independent_vars))

# Descripción de variables independientes
# Categóricas: Frecuencias absolutas y relativas
cat_vars <- c("SEXO", "REGION", "NSE", "GSE_AIM", "ZONA")
cat_summary <- lapply(data[cat_vars], function(x) prop.table(table(x)))

# Numéricas: Media, mediana, mínimo, máximo
num_vars <- c("EDAD", "POND", "C10i1", "P6_1", "FACTOR")
num_summary <- data %>% select(all_of(num_vars)) %>%
  summarise_all(list(mean = mean, median = median, min = min, max = max), na.rm = TRUE)

print("Resumen de variables categóricas:")
print(cat_summary)

print("Resumen de variables numéricas:")
print(num_summary)

# Guardar el estado inicial de los datos
write.csv(data, "cleaned_data.csv", row.names = FALSE)

print("Los datos han sido limpiados y guardados como 'cleaned_data.csv'.")
