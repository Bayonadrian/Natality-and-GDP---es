unpivot_data = function(df) {
  date_range = as.character(2012:2023)
  
  data <- df %>%
    pivot_longer(
      cols = all_of(date_range),
      names_to = "year",
      values_to = "value"
    ) %>%
    mutate(
      year = ymd(paste0(year, "-01-01"))
    )
  
  return(data)
}

cast_date <- function(df) {
  data <- df %>%
    mutate(year = ymd(paste0(year, "-01-01")))
  
  return(data)
}

introduction = function(input, output, session) {
  
  content = reactiveVal("crew")
  
  observeEvent(input$members_page, {
    content("crew")
  })
  
  observeEvent(input$thesis_page, {
    content("thesis")
  })
  
  observeEvent(input$metadata_page, {
    content("metadata")
  })
  
  output$introduction = renderUI({
    if (content() == "crew") {
      tagList(
        h3("Miembros"),
        p("Miembros del proyecto:"),
        tags$ul(
          tags$li("Luis Flavio Choquenaira Choquenaira"),
          tags$li("Henry Durand Huamani"),
          tags$li("Adrian Ronaldo Hermoza Bayona"),
          tags$li("Ramiro Elard Zea Ponce"),
          tags$li("Sebastian David Villalba Bouroncle")
        )
      )
    } else if (content() == "thesis") {
      tagList(
        h3("Tesis"),
        p("El presente trabajo plantea 2 ideas principales:"),
        tags$ul(
          tags$li("1. La natalidad es inversamente proporcional al crecimiento economico"),
          tags$li("2. La corrupcion es directamente proporcional al crecimiento economico"),
        ),
        p("A su vez tambien presenta la sugerencia de estudiar el futuro economico de paises y regiones en base a la natialidad presente.")
      )
    } else {
      tagList(
        h3("Metadata"),
        h4("Librerias")
      )
    }
  })
  
}

natality = function(input, output, session) {
  
  filtered_data_countries= reactive({
    req(input$countries)
    
    replacement_rate_countries %>%
      filter(name %in% input$countries)
  })
  
  filtered_correlation= reactive({
    req(input$year)
    
    replacement_rate_countries_gdp %>%
      filter(year %in% input$year)
  }) 
  
  output$natality_correlation_gdp= renderPlotly({
    data_plot <- filtered_correlation() %>%
      arrange(value.x)
    
    plot_ly(
      data = data_plot,
      x = ~value.x,
      y = ~value.y,
      type = "scatter",
      mode = "markers",
      color = ~name.x
    )  %>%
      layout(
        title = "Natalidad y PBI per capita",
        paper_bgcolor = "transparent", 
        plot_bgcolor = "transparent",
        font = list(color = "#547A95"),
        xaxis = list(title = "Natalidad"),
        yaxis = list(title = "GDP per capita")
      )
  })
  output$natality_evaluation_countries= renderPlotly({
    
    plot_ly(
      data = filtered_data_countries(),
      x = ~year,
      y = ~value,
      type = "bar",
      color = ~name
    ) %>%
      layout(
        title = "Tasa de reemplazo por país",
        xaxis = list(title = "Año"),
        yaxis = list(title = "Hijos por mujer"),
        paper_bgcolor = "transparent", 
        plot_bgcolor = "transparent", 
        font = list(color = "#547A95"),
        template = "plotly_dark",
        shapes = list(
          list(
            type = "line",
            x0 = as.character(min(filtered_data_countries()$year)),
            x1 = as.character(max(filtered_data_countries()$year)),
            y0 = 2.1,
            y1 = 2.1,
            line = list(color = "#547A95", dash = "dash")
          )
        )
      )
  })
  output$natality_evaluation = renderPlotly({
    plot_ly(
      data = replacement_rate_continents,
      x = ~year,
      y = ~value,
      type = "bar",
      color = ~name,
      colors = c("#C2A56D", "#547A95", "#57595B", "#2C3947") 
    ) %>%
      layout(
        title = "Tasa de reemplazo por continente",
        xaxis = list(title = "Año"),
        yaxis = list(title = "Hijos por mujer"),
        paper_bgcolor = "transparent", 
        plot_bgcolor = "transparent", 
        font = list(color = "#547A95"),
        template = "plotly_dark",         
        shapes = list(                    
          list(
            type = "line",
            x0 = as.character(min(replacement_rate_continents$year)),
            x1 = as.character(max(replacement_rate_continents$year)),
            y0 = 2.1,
            y1 = 2.1,
            line = list(color = "#547A95", dash = "dash")
          )
        )
      )
  })
  output$natality_text= renderText(
    "2.1"
  )
  output$corr_text= output$corr_text <- renderText({
    corr <- cor(
      filtered_correlation()$value.x,
      filtered_correlation()$value.y,
      use = "complete.obs"
    )
    
    as.character(round(corr, 3))
  })
  output$download_replacement_data <- downloadHandler(
    filename = function() {
      "replacement_rate_gdp.csv"
    },
    
    content = function(file) {
      write.csv(
        replacement_rate_countries_gdp,
        file,
        row.names = FALSE
      )
    }
  )
  output$download_continent_data <- downloadHandler(
    filename = function() {
      "replacement_rate_continents.csv"
    },
    
    content = function(file) {
      write.csv(
        replacement_rate_continents,
        file,
        row.names = FALSE
      )
    }
  )
  #outputOptions(output, "natality_text", suspendWhenHidden = FALSE)
  #outputOptions(output, "corr_text", suspendWhenHidden = FALSE)
  outputOptions(output, "natality_evaluation", suspendWhenHidden = FALSE)
  #outputOptions(output, "natality_correlation_gdp", suspendWhenHidden = FALSE)
  #outputOptions(output, "natality_evaluation_countries", suspendWhenHidden = FALSE)
}

function(input, output, session) {
  
  introduction(input = input, output = output, session = session)
  natality(input = input, output = output, session = session)
  
}