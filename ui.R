ui <- page_navbar(
  title = "Natalidad, Crecimiento Económico y Corrupción",
  
  theme = bs_theme(
    version = 5,
    primary = "#C2A56D",
    base_font = "Arial"
  ),
  
  bg = "#C2A56D",
  underline = TRUE,
  
  nav_panel(
    "Introducción",
    layout_sidebar(
      sidebar = sidebar(
        accordion(
          accordion_panel(
            title = "Información General",
            actionButton("members_page", "Miembros", icon = icon("people-group")),
            br(), br(),
            actionButton("thesis_page", "Tesis", icon = icon("lightbulb")),
            br(), br(),
            actionButton("analysis_page", "Análisis", icon = icon("chart-pie")),
            br(), br(),
            actionButton("metadata_page", "Metadatos", icon = icon("hammer"))
          )
        )
      ),
      card(uiOutput("introduction"))
    )
  ),
  
  nav_panel(
    "Natalidad / Crecimiento Económico",
    layout_sidebar(
      sidebar = sidebar(
        accordion(
          accordion_panel(
            title = "Filtros",
            
            selectInput(
              "countries",
              "Selecciona país(es):",
              choices = sort(unique(replacement_rate_countries$name)),
              selected = sort(unique(replacement_rate_countries$name))[1],
              multiple = TRUE
            ),
            
            sliderInput(
              "year",
              "Año:",
              min = 2012,
              max = 2023,
              value = 2023,
              step = 1,
              sep = ""
            ),
            
            br(),
            downloadButton("download_replacement_data", "Descargar datos por país"),
            br(), br(),
            downloadButton("download_continent_data", "Descargar datos por continente")
          )
        )
      ),
      
      layout_columns(
        col_widths = c(6, 6),
        gap = "20px",
        
        card(
          card_header("Evaluación de la Natalidad"),
          card_body(
            layout_columns(
              col_widths = c(8, 4),
              plotlyOutput("natality_evaluation", height = "300px"),
              card(
                card_header("Promedio Recomendado por la ONU"),
                card_body(
                  tags$div(
                    textOutput("natality_text"),
                    style = "font-size:45px;font-weight:bold;text-align:center;"
                  )
                )
              )
            ),
            plotlyOutput("natality_evaluation_countries", height = "350px")
          )
        ),
        
        card(
          card_header("Correlación con Crecimiento del PBI"),
          card_body(
            card(
              card_header("Correlación"),
              card_body(
                tags$div(
                  textOutput("corr_text"),
                  style = "font-size:40px;font-weight:bold;text-align:center;"
                )
              )
            ),
            plotlyOutput("natality_correlation_gdp", height = "450px")
          )
        )
      )
    )
  ),
  
  nav_panel(
    "Corrupción / Crecimiento Económico",
    layout_sidebar(
      sidebar = sidebar(
        accordion(
          accordion_panel(
            title = "Filtros",
            
            selectInput(
              "corruption_countries",
              "Selecciona país(es):",
              choices = sort(unique(corruption$name)),
              selected = sort(unique(corruption$name))[1],
              multiple = TRUE
            ),
            
            sliderInput(
              "corruption_year",
              "Año:",
              min = 2012,
              max = 2023,
              value = 2023,
              step = 1,
              sep = ""
            ),
            
            br(),
            downloadButton("download_corruption_data", "Descargar datos de corrupción")
          )
        )
      ),
      
      layout_columns(
        col_widths = c(6, 6),
        gap = "20px",
        
        card(
          card_header("Evaluación de la Corrupción"),
          card_body(
            layout_columns(
              col_widths = c(6, 6),
              card(
                card_header("Promedio de Corrupción"),
                card_body(
                  tags$div(
                    textOutput("corruption_mean_text"),
                    style = "font-size:35px;font-weight:bold;text-align:center;"
                  )
                )
              ),
              card(
                card_header("Desviación Estándar de Corrupción"),
                card_body(
                  tags$div(
                    textOutput("corruption_sd_text"),
                    style = "font-size:35px;font-weight:bold;text-align:center;"
                  )
                )
              )
            ),
            plotlyOutput("corruption_evaluation_countries", height = "450px")
          )
        ),
        
        card(
          card_header("Correlación con Crecimiento del PBI"),
          card_body(
            card(
              card_header("Correlación"),
              card_body(
                tags$div(
                  textOutput("corruption_corr_text"),
                  style = "font-size:40px;font-weight:bold;text-align:center;"
                )
              )
            ),
            plotlyOutput("corruption_correlation_gdp", height = "450px")
          )
        )
      )
    )
  ),
  
  nav_panel(
    "Natalidad: Pronóstico y Evolución",
    layout_sidebar(
      sidebar = sidebar(
        accordion(
          accordion_panel(
            title = "Ajustes del Análisis",
            
            selectInput(
              "forecast_country",
              "Selecciona el país foco:",
              choices = sort(unique(replacement_rate_countries$name)),
              selected = sort(unique(replacement_rate_countries$name))[1]
            ),
            
            sliderInput(
              "forecast_year_select",
              "Año de corte:",
              min = 2012,
              max = 2023,
              value = 2023,
              step = 1,
              sep = ""
            )
          )
        )
      ),
      
      tags$div(
        style = "padding:10px;display:flex;flex-direction:column;gap:35px;",
        
        layout_columns(
          col_widths = c(5, 7),
          gap = "20px",
          
          card(
            card_header(tags$b("Pronóstico de la Tasa de Natalidad")),
            card_body(
              plotlyOutput("forecast_plot", height = "320px"),
              br(),
              layout_columns(
                col_widths = c(6, 6),
                card(
                  card_header("Año Alerta (< 2.1)"),
                  card_body(
                    tags$div(
                      textOutput("year_alert_text"),
                      style = "font-size:20px;font-weight:bold;text-align:center;color:#FF6B6B;"
                    )
                  )
                ),
                card(
                  card_header("Tendencia Lineal"),
                  card_body(
                    tags$div(
                      textOutput("trend_text"),
                      style = "font-size:18px;font-weight:bold;text-align:center;"
                    )
                  )
                )
              )
            )
          ),
          
          card(
            card_header(tags$b("Mapa Global de Natalidad")),
            card_body(plotlyOutput("global_map_plot", height = "410px"))
          )
        ),
        
        layout_columns(
          col_widths = c(4, 8),
          gap = "20px",
          
          card(
            card_header(tags$b("Distribución Tasa de Natalidad")),
            card_body(plotlyOutput("natality_boxplot", height = "400px"))
          ),
          
          card(
            card_header(tags$b("Evolución Dinámica Global")),
            card_body(plotlyOutput("dynamic_bubble_plot", height = "400px"))
          )
        )
      )
    )
  ),
  
  nav_spacer(),
  nav_item(input_dark_mode())
)