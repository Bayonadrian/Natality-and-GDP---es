library(shiny)
library(bslib)
library(htmltools)
library(plotly)

page_navbar(
  title = "Natalidad, crecimiento economico y corrupcion",
  
  theme = bs_theme(
    version = 5,
    preset = "shiny",
    primary = "#C2A56D",
    base_font = "Arial"
  ),
  
  navbar_options = navbar_options(
    bg = "#C2A56D",
    underline = TRUE
  ),
  
  nav_panel(
    "Introduccion",
    
    layout_sidebar(
      sidebar =  sidebar(
        accordion(
          accordion_panel(
            title = "Informacion General",
            icon = icon("info"),
            actionButton(
              "members_page", 
              "Miembros",
              icon = icon("people-group")
              ),
            br(),
            actionButton(
              "thesis_page", 
              "Tesis",
              icon =icon("lightbulb")
              ),
            br(),
            actionButton(
              "metadata_page", 
              "Metadata",
              icon = icon("hammer")
              )
          ),
        ),
      ),
      card(
        uiOutput("introduction")
      )
    )
  ),
  
  nav_panel(
    "Natalidad/Crecimiento Economico",
    
    layout_sidebar(
      sidebar = sidebar(
        accordion(
          accordion_panel(
            title = tagList(icon("sliders"), "Filtros"),
            value = "controls",
            
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
            downloadButton(
              "download_replacement_data",
              "Descargar datos por pais"
            ),
            br(),
            downloadButton(
              "download_continent_data",
            )
          )
        )
      ),
      tagList(
        layout_columns(
          col_widths = c(6, 6),
          gap = "20px",
          
          card(
            card_header("Evaluación de la natalidad"),
            card_body(
              layout_columns(
                col_widths = c(8, 4),
                
                plotlyOutput(
                  "natality_evaluation",
                  height = "330px"
                ),
                
                card(
                  card_header("Promedio Recomendado por la ONU"),
                  card_body(
                    tags$div(
                      textOutput("natality_text"),
                      style = "font-size: 55px; font-weight: bold; text-align: center; padding-top: 80px;"
                    )
                  ),
                  style = "height: 220px;"
                )
              ),
              
              plotlyOutput(
                "natality_evaluation_countries",
                height = "360px"
              )
            ),
            style = "height: 780px;"
          ),
          
          card(
            card_header("Correlación con crecimiento del PBI"),
            card_body(
              card(
                card_header("Correlación"),
                card_body(
                  tags$div(
                    textOutput("corr_text"),
                    style = "font-size: 48px; font-weight: bold; text-align: center;"
                  )
                ),
                style = "height: 160px; margin-bottom: 20px;"
              ),
              
              plotlyOutput(
                "natality_correlation_gdp",
                height = "560px"
              )
            ),
            style = "height: 780px;"
          )
        )
      )
    )
  ),
  
  nav_panel(
    "Corrupcion/Crecimiento Economico",
    
    layout_sidebar(
      sidebar = sidebar(
        checkboxInput("mostrar", "Mostrar resumen", TRUE)
      ),
      
      card(
        card_header("Datos"),
        tableOutput("tabla")
      )
    )
  ),
  
  nav_spacer(),
  nav_item(input_dark_mode())
)