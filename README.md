# Encuesta-jovenes-epidemiologia
Este repositorio  es para el ramo de Epidemiología ll del Magíster en Informática Médica cohoerte 2024.

Dentro del archivo cuestionario, se pueden evidenciar cada pregunta correspondiente a su numero por ejemplo:
P17.
¿De qué tipo de establecimiento te GRADUASTE de la educación media? (ESPONTÁNEA.SONDEAR)
1. Particular pagado
2. Particular subvencionado
3. Municipal
4. No he terminado enseñanza media
5. Otro, ¿cuál? (PREGUNTA ABIERTA. MÁX 250 CARACTERES)
98. NS
99. NR

Por otro lado tenemos un el manual de usuario/usuaria como complemento al estudio.

Analisis

## Interpretación de la Curva ROC

La **Curva ROC (Receiver Operating Characteristic)** es una herramienta gráfica que evalúa la capacidad de los modelos predictivos para distinguir entre las clases positivas y negativas. En esta curva, el eje X representa la **especificidad** (proporción de negativos correctamente clasificados), mientras que el eje Y muestra la **sensibilidad** (proporción de positivos correctamente clasificados). La línea diagonal gris es una referencia que representa un modelo sin capacidad predictiva (clasificación al azar). Un modelo útil debe tener su curva por encima de esta línea, indicando que predice mejor que el azar.

En el gráfico generado, la línea azul corresponde al modelo de **Regresión Logística** y la línea roja al modelo de **Random Forest**. El modelo de Random Forest tiene una curva ligeramente por encima de la de Regresión Logística, lo que indica que este último tiene un desempeño marginalmente mejor. Sin embargo, ambas curvas están cercanas a la línea diagonal, lo que sugiere que ninguno de los modelos es altamente efectivo para este conjunto de datos. Esto también se refleja en valores de AUC (Área Bajo la Curva) que probablemente estén alrededor de 0.5 a 0.7, indicando una capacidad predictiva moderada.

Para mejorar el desempeño de los modelos, se podrían considerar ajustes en la selección de variables predictoras, optimización de hiperparámetros (como el número de árboles y variables en Random Forest) o incluso probar con otros algoritmos como SVM o Gradient Boosting. Además, la recolección de más datos podría mejorar significativamente la capacidad predictiva. Este gráfico proporciona una base clara para comparar el desempeño de los modelos y buscar formas de mejorar su efectividad.

![Curva ROC comparativa](https://github.com/Magdasanhueza/Encuesta-jovenes-epidemiologia/blob/main/CurvasROCcomparativas.png)


## Métricas de Desempeño de los Modelos

Con base en las métricas proporcionadas para los modelos de **Random Forest** y **Regresión Logística**, se interpreta lo siguiente:

### 1. Sensibilidad (capacidad para detectar correctamente los casos positivos)
- **Random Forest:** 0.1538 → Este modelo detecta solo el 15.38% de los casos positivos, lo cual indica un desempeño bajo para identificar verdaderos positivos.
- **Regresión Logística:** 0.4614 → La sensibilidad es mayor en este modelo (46.14%), aunque sigue siendo moderada. Esto sugiere que identifica casi la mitad de los casos positivos.

### 2. Especificidad (capacidad para identificar correctamente los casos negativos)
- **Random Forest:** 0.6875 → El modelo identifica correctamente el 68.75% de los casos negativos, lo cual es razonable.
- **Regresión Logística:** 0.75 → Tiene una mayor especificidad (75%), mostrando mejor desempeño en la identificación de casos negativos que Random Forest.

### 3. Valor Predictivo Positivo (Precisión) (proporción de casos predichos como positivos que realmente son positivos)
- **Random Forest:** 0.2857 → De las predicciones positivas realizadas, solo el 28.57% son correctas, lo que indica un bajo rendimiento.
- **Regresión Logística:** 0.6 → Aquí la precisión es mucho mejor, con un 60% de predicciones positivas correctas, lo que lo hace más confiable en este aspecto.

### 4. Exactitud (proporción de predicciones correctas en general)
- **Random Forest:** 0.4483 → Este modelo tiene una exactitud general de 44.83%, indicando que casi la mitad de las predicciones totales son correctas.
- **Regresión Logística:** 0.6207 → La exactitud es mayor en este modelo (62.07%), lo que lo hace más efectivo globalmente.

---

## Comparación General

El modelo de **Regresión Logística** supera al de **Random Forest** en todas las métricas evaluadas. Tiene una sensibilidad y exactitud notablemente mejores, lo que lo hace más adecuado para este conjunto de datos, especialmente si el objetivo es balancear la identificación de casos positivos y negativos.

Por otro lado, **Random Forest**, aunque presenta una especificidad razonable, falla en sensibilidad y precisión. Esto limita su utilidad en contextos donde es crucial detectar correctamente los casos positivos.

![Gráfico comparativo de métricas de desempeño de los modelos ](https://github.com/Magdasanhueza/Encuesta-jovenes-epidemiologia/blob/main/CurvasROCcomparativas.png)

