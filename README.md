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
