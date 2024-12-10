
# Cargar librerías necesarias
library(dplyr)
library(ggplot2)
library(caret) # Para modelos predictivo
library(foreign)



data <- read.delim("C:/Users/magda/Documents/Mg/2do semestre/Epidemiología/Epidemiología ll/Github Epidemiologia/Encuesta-jovenes-epidemiologia/BBDD_Encuesta_Jovenes (1).dat", header = TRUE, sep = "\t", stringsAsFactors = FALSE)

# 2. Limpieza de datos
# Identificar valores faltantes
missing_summary <- sapply(data, function(x) sum(is.na(x)))
print("Resumen de valores faltantes:")
print(missing_summary)

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
#pregunta p103 ¿Recibes actualmente algún tratamiento para algún problema de salud mental, como una depresión, ansiedad u otro?
# Variable dependiente: P103 (tratamiento de salud mental)
data <- data %>% filter(P103 %in% c("1. Si", "2. No")) # Excluir NS/NR
data$P103 <- ifelse(data$P103 == "1. Si", 1, 0) # Recodificar como 0 y 1
#1 significa que la persona recibe tratamiento para un problema de salud mental. 0 significa que la persona no recibe tratamiento.

# Frecuencia de la variable dependiente
dep_freq <- table(data$P103)
prop.table(dep_freq)

olnames(data)

# 4. Selección de variables independientes
# Seleccionar 10 variables relevantes (mixtas)
independent_vars <- c("SEXO", "REGION", "NSE", "ZONA", "COMUNA", "EDAD", "AUTOAPLICADO", "GSE", "P68", "P70")
data <- data %>% select(P103, all_of(independent_vars))

# Descripción de variables independientes
# Categóricas: Frecuencias absolutas y relativas
cat_vars <- c("SEXO", "REGION", "NSE", "ZONA", "COMUNA", "AUTOAPLICADO", "GSE", "P68", "P70")
cat_summary <- lapply(data[cat_vars], function(x) prop.table(table(x)))

# Frecuencia absoluta y relativa variable categorica
# Cargar las librerías necesarias
library(dplyr)  # Para manipulación de datos

# Variables categóricas seleccionadas
categorical_vars <- c("SEXO", "REGION", "NSE", "ZONA", "COMUNA", "AUTOAPLICADO", "GSE", "P68", "P70")

# Crear una lista para almacenar las tablas de frecuencias
frequency_tables <- list()

# Calcular frecuencias absolutas y relativas para cada variable categórica
for (var in categorical_vars) {
  cat(paste("Frecuencias para la variable:", var, "\n"))
  freq_table <- data %>%
    count(!!sym(var)) %>%  # Calcular las frecuencias absolutas
    mutate(relative = n / sum(n) * 100)  # Calcular las frecuencias relativas (%)
  
  print(freq_table)  # Mostrar las frecuencias
  frequency_tables[[var]] <- freq_table  # Guardar la tabla en la lista
}

# Numéricas: Media, mediana, mínimo, máximo
num_vars <- c("EDAD")
num_summary <- data %>% select(all_of(num_vars)) %>%
  summarise_all(list(mean = mean, median = median, min = min, max = max), na.rm = TRUE)

print("Resumen de variables categóricas:")
print(cat_summary)

print("Resumen de variables numéricas:")
print(num_summary)

# -------------------------------------------------
# Modelos de Machine Learning
# -------------------------------------------------

# Modelo de Regresión Logística
logistic_model <- glm(P103 ~ ., data = train_data, family = "binomial")

# Modelo de Random Forest
rf_model <- randomForest(P103 ~ ., data = train_data, ntree = 100, importance = TRUE)

# -------------------------------------------------
# Predicciones para Ambos Modelos
# -------------------------------------------------

# Predicciones para Regresión Logística
logistic_preds <- predict(logistic_model, newdata = test_data, type = "response")
logistic_class <- ifelse(logistic_preds > 0.5, "1. Si", "2. No")

# Predicciones para Random Forest
rf_preds <- predict(rf_model, newdata = test_data, type = "prob")[, "1. Si"]
rf_class <- ifelse(rf_preds > 0.5, "1. Si", "2. No")

# Convertir predicciones a factor con los mismos niveles que P103
logistic_class <- factor(logistic_class, levels = levels(test_data$P103))
rf_class <- factor(rf_class, levels = levels(test_data$P103))

# -------------------------------------------------
# Calcular Métricas de Desempeño
# -------------------------------------------------

# Matriz de Confusión para Regresión Logística
logistic_cm <- confusionMatrix(logistic_class, test_data$P103, positive = "1. Si")

# Matriz de Confusión para Random Forest
rf_cm <- confusionMatrix(rf_class, test_data$P103, positive = "1. Si")

# Mostrar las métricas de Regresión Logística
cat("Métricas de desempeño para Regresión Logística:\n")
cat("Sensibilidad:", logistic_cm$byClass["Sensitivity"], "\n")
cat("Especificidad:", logistic_cm$byClass["Specificity"], "\n")
cat("Valor Predictivo Positivo:", logistic_cm$byClass["Pos Pred Value"], "\n")
cat("Exactitud:", logistic_cm$overall["Accuracy"], "\n\n")

# Mostrar las métricas de Random Forest
cat("Métricas de desempeño para Random Forest:\n")
cat("Sensibilidad:", rf_cm$byClass["Sensitivity"], "\n")
cat("Especificidad:", rf_cm$byClass["Specificity"], "\n")
cat("Valor Predictivo Positivo:", rf_cm$byClass["Pos Pred Value"], "\n")
cat("Exactitud:", rf_cm$overall["Accuracy"], "\n\n")

# -------------------------------------------------
# Evaluación con Curvas ROC
# -------------------------------------------------

# Crear variable binaria para la curva ROC
test_data$P103_binary <- ifelse(test_data$P103 == "1. Si", 1, 0)

# Curvas ROC para Regresión Logística
logistic_auc <- roc(test_data$P103_binary, logistic_preds)
cat("AUC Regresión Logística:", round(auc(logistic_auc), 4), "\n")

# Curvas ROC para Random Forest
rf_auc <- roc(test_data$P103_binary, rf_preds)
cat("AUC Random Forest:", round(auc(rf_auc), 4), "\n")

# Graficar las Curvas ROC
plot(logistic_auc, col = "blue", main = "Curvas ROC Comparativas")
plot(rf_auc, col = "red", add = TRUE)
legend("bottomright", legend = c("Logística", "Random Forest"), col = c("blue", "red"), lwd = 2)

# -------------------------------------------------
# Importancia de Variables en Random Forest
# -------------------------------------------------
cat("Importancia de Variables en Random Forest:\n")
print(importance(rf_model))
varImpPlot(rf_model, main = "Importancia de Variables")

# Instalar ggplot2 si no está instalado
if (!require(ggplot2)) install.packages("ggplot2")
library(ggplot2)

# Crear un dataframe con las métricas calculadas
metricas <- data.frame(
  Modelo = c("Logística", "Logística", "Logística", "Logística", "Logística",
             "Random Forest", "Random Forest", "Random Forest", "Random Forest", "Random Forest"),
  Métrica = rep(c("Sensibilidad", "Especificidad", "Precisión", "Exactitud", "AUC"), 2),
  Valor = c(
    logistic_cm$byClass["Sensitivity"], logistic_cm$byClass["Specificity"],
    logistic_cm$byClass["Pos Pred Value"], logistic_cm$overall["Accuracy"], auc(logistic_auc),
    rf_cm$byClass["Sensitivity"], rf_cm$byClass["Specificity"],
    rf_cm$byClass["Pos Pred Value"], rf_cm$overall["Accuracy"], auc(rf_auc)
  )
)

# Graficar el desempeño de los modelos
ggplot(metricas, aes(x = Métrica, y = Valor, fill = Modelo)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = round(Valor, 3)), position = position_dodge(0.9), vjust = -0.25) +
  labs(title = "Desempeño Comparativo de Modelos", y = "Proporción", x = "Métrica") +
  scale_y_continuous(limits = c(0, 1)) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_fill_manual(values = c("pink", "green"))

# Guardar datos limpios si lo necesitas
write.csv(data, "datos_limpiados.csv", row.names = FALSE)
