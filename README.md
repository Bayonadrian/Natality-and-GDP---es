# Natalidad, Crecimiento Económico y Corrupción: Un Análisis Empírico Global (2012-2023)

### Universidad Continental - Escuela de Posgrado
* **Curso:** Trabajo Final de Métodos Cuantitativos
* **Docente:** William Richard Sánchez Tapia
* **Integrantes:**
  * Luis Flavio Choquenaira Choquenaira
  * Henry Durand Huamani
  * Adrian Ronaldo Hermoza Bayona
  * Ramiro Elard Zea Ponce
  * Sebastián David Villalba Bouroncle

---

## Descripción del Proyecto
Este proyecto contiene una aplicación interactiva en R y Shiny diseñada para analizar cómo se relacionan los indicadores demográficos y de transparencia institucional con el desarrollo de los países. 

El objetivo es poner a prueba dos ideas clave:
1. Si una mayor riqueza económica (PBI per cápita) coincide con una caída en las tasas de natalidad.
2. Cómo afecta la percepción de la corrupción al crecimiento económico según el tipo de país.

## Enlaces del Proyecto
* **Dashboard en Vivo:** (https://bayonadrian.shinyapps.io/Natality-and-GDP---es/)

## Estructura del Repositorio
De acuerdo al desarrollo de nuestra arquitectura en R, los archivos se organizan de la siguiente manera:
* **`Data/`**: Carpeta con las bases de datos originales extraídas del Banco Mundial y Transparencia Internacional.
* **`docs/`**: Documentación adicional e informes complementarios del análisis.
* **`global.R`**: Carga de librerías, lectura y procesamiento inicial de los datos (Data Wrangling).
* **`ui.R`**: Definición de la interfaz gráfica, pestañas de navegación y controles de usuario.
* **`server.R`**: Lógica reactiva que calcula las correlaciones, gráficos dinámicos y el pronóstico de natalidad.

## Evaluación del Proyecto

### Bondades
* **Interactividad amigable:** Permite cruzar mapas mundiales, diagramas de caja y series de tiempo de forma dinámica en un solo lugar.
* **Optimización en tiempo real:** Los filtros y cálculos estadísticos (como las correlaciones de Pearson) responden al instante.
* **Capacidad predictiva:** Incluye proyecciones automáticas de la tendencia de natalidad hacia el año 2030.

### Limitaciones
* **Dependencia externa:** Las actualizaciones dependen estrictamente de los plazos de publicación de las API del Banco Mundial.
* **Vacíos de información:** Algunos países con conflictos internos o de menor tamaño no registran datos continuos en el índice de corrupción.

### Futuras Mejoras
* **Modelos avanzados:** Incorporar algoritmos de Machine Learning (como modelos ARIMA) para proyectar el PBI combinando ambas variables.
* **Nuevos indicadores:** Incluir variables sociales complementarias como los niveles de educación femenina o la inversión extranjera directa.

## Herramientas Utilizadas
* **R & Shiny**: Base del aplicativo dinámico.
* **Tidyverse (`dplyr`, `tidyr`, `lubridate`)**: Limpieza y reestructuración de matrices.
* **Plotly**: Gráficos y mapas interactivos.