server <- function(input, output, session) {
  
  output$introduction <- renderUI({
    tagList(
      h3("Miembros"),
      p("Miembros del Proyecto:"),
      tags$ul(
        tags$li("Luis Flavio Choquenaira Choquenaira"),
        tags$li("Henry Durand Huamani"),
        tags$li("Adrian Ronaldo Hermoza Bayona"),
        tags$li("Ramiro Elard Zea Ponce"),
        tags$li("Sebastian David Villalba Bouroncle")
      )
    )
  })
  
  observeEvent(input$members_page, {
    output$introduction <- renderUI({
      tagList(
        h3("Miembros"),
        p("Miembros del Proyecto:"),
        tags$ul(
          tags$li("Luis Flavio Choquenaira Choquenaira"),
          tags$li("Henry Durand Huamani"),
          tags$li("Adrian Ronaldo Hermoza Bayona"),
          tags$li("Ramiro Elard Zea Ponce"),
          tags$li("Sebastian David Villalba Bouroncle")
        )
      )
    })
  })
  
  observeEvent(input$thesis_page, {
    output$introduction <- renderUI({
      tagList(
        h3("Tesis de Investigación"),
        tags$ol(
          tags$li(tags$b("Tesis 1:"), " La natalidad es inversamente proporcional al crecimiento económico."),
          tags$li(tags$b("Tesis 2:"), " La corrupción es inversamente proporcional al crecimiento económico.")
        )
      )
    })
  })
  
  observeEvent(input$analysis_page, {
    output$introduction <- renderUI({
      tagList(
        h3("Análisis de las Tesis de Investigación"),
        p("Se analiza la relación entre natalidad, crecimiento económico y corrupción entre 2012 y 2023.")
      )
    })
  })
  
  observeEvent(input$metadata_page, {
    output$introduction <- renderUI({
      tagList(
        h3("Metadatos y Sustento Técnico"),
        tags$ul(
          tags$li("Periodo analizado: 2012 - 2023."),
          tags$li("Datos: natalidad, PBI per cápita e índice de corrupción."),
          tags$li("Librerías: shiny, bslib, plotly, dplyr, tidyr, lubridate.")
        )
      )
    })
  })
  
  filtered_data_countries <- reactive({
    req(input$countries)
    replacement_rate_countries %>%
      filter(name %in% input$countries)
  })
  
  filtered_correlation <- reactive({
    req(input$year)
    replacement_rate_countries_gdp %>%
      filter(year == input$year)
  })
  
  output$natality_evaluation <- renderPlotly({
    plot_ly(
      data = replacement_rate_continents,
      x = ~year,
      y = ~value,
      type = "bar",
      color = ~name
    ) %>%
      layout(
        title = "Tasa de reemplazo por continente",
        xaxis = list(title = "Año"),
        yaxis = list(title = "Hijos por mujer"),
        paper_bgcolor = "transparent",
        plot_bgcolor = "transparent",
        font = list(color = "#547A95"),
        shapes = list(
          list(
            type = "line",
            x0 = 2012,
            x1 = 2023,
            y0 = 2.1,
            y1 = 2.1,
            line = list(color = "#547A95", dash = "dash")
          )
        )
      )
  })
  
  output$natality_evaluation_countries <- renderPlotly({
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
        shapes = list(
          list(
            type = "line",
            x0 = 2012,
            x1 = 2023,
            y0 = 2.1,
            y1 = 2.1,
            line = list(color = "#547A95", dash = "dash")
          )
        )
      )
  })
  
  output$natality_correlation_gdp <- renderPlotly({
    df <- filtered_correlation() %>%
      filter(!is.na(value_natality), !is.na(value_gdp))
    
    validate(need(nrow(df) > 1, "No hay datos suficientes."))
    
    plot_ly(
      data = df,
      x = ~value_natality,
      y = ~value_gdp,
      type = "scatter",
      mode = "markers",
      color = ~name_natality,
      text = ~paste("País:", name_natality, "<br>Año:", year)
    ) %>%
      layout(
        title = "Natalidad y PBI per cápita",
        xaxis = list(title = "Natalidad"),
        yaxis = list(title = "PBI per cápita"),
        paper_bgcolor = "transparent",
        plot_bgcolor = "transparent",
        font = list(color = "#547A95")
      )
  })
  
  output$natality_text <- renderText("2.1")
  
  output$corr_text <- renderText({
    df <- filtered_correlation() %>%
      filter(!is.na(value_natality), !is.na(value_gdp))
    
    if (nrow(df) < 2) return("Sin datos")
    
    round(cor(df$value_natality, df$value_gdp, use = "complete.obs"), 3)
  })
  
  output$download_replacement_data <- downloadHandler(
    filename = function() "replacement_rate_gdp.csv",
    content = function(file) {
      write.csv(replacement_rate_countries_gdp, file, row.names = FALSE)
    },
    contentType = "text/csv"
  )
  
  output$download_continent_data <- downloadHandler(
    filename = function() "replacement_rate_continents.csv",
    content = function(file) {
      write.csv(replacement_rate_continents, file, row.names = FALSE)
    },
    contentType = "text/csv"
  )
  
  filtered_corruption_countries <- reactive({
    req(input$corruption_countries)
    corruption %>%
      filter(name %in% input$corruption_countries)
  })
  
  filtered_corruption_year <- reactive({
    req(input$corruption_year, input$corruption_countries)
    corruption %>%
      filter(
        year == input$corruption_year,
        name %in% input$corruption_countries
      )
  })
  
  output$corruption_mean_text <- renderText({
    df <- filtered_corruption_year()
    
    if (nrow(df) == 0 || all(is.na(df$value))) return("Sin datos")
    
    round(mean(df$value, na.rm = TRUE), 2)
  })
  
  output$corruption_sd_text <- renderText({
    df <- filtered_corruption_countries()
    valores <- df$value[!is.na(df$value)]
    
    if (length(valores) < 2) return("Sin datos")
    
    round(sd(valores), 2)
  })
  
  output$corruption_evaluation_countries <- renderPlotly({
    plot_ly(
      data = filtered_corruption_countries(),
      x = ~year,
      y = ~value,
      type = "bar",
      color = ~name
    ) %>%
      layout(
        title = "Corrupción por país",
        xaxis = list(title = "Año"),
        yaxis = list(title = "Índice de corrupción"),
        paper_bgcolor = "transparent",
        plot_bgcolor = "transparent",
        font = list(color = "#547A95")
      )
  })
  
  output$download_corruption_data <- downloadHandler(
    filename = function() "corruption.csv",
    content = function(file) {
      write.csv(corruption, file, row.names = FALSE)
    },
    contentType = "text/csv"
  )
  
  output$corruption_corr_text <- renderText({
    req(input$corruption_countries)
    
    df <- corruption_gdp %>%
      filter(name_corruption %in% input$corruption_countries) %>%
      filter(!is.na(value_corruption), !is.na(value_gdp))
    
    if (nrow(df) < 2) return("Sin datos")
    
    round(cor(df$value_corruption, df$value_gdp, use = "complete.obs"), 2)
  })
  
  output$corruption_correlation_gdp <- renderPlotly({
    req(input$corruption_countries)
    
    df <- corruption_gdp %>%
      filter(name_corruption %in% input$corruption_countries) %>%
      filter(!is.na(value_corruption), !is.na(value_gdp))
    
    validate(need(nrow(df) > 1, "Seleccione países con datos suficientes."))
    
    plot_ly(
      data = df,
      x = ~value_corruption,
      y = ~value_gdp,
      type = "scatter",
      mode = "markers",
      color = ~name_corruption,
      text = ~paste("País:", name_corruption, "<br>Año:", year)
    ) %>%
      layout(
        title = "Corrupción y crecimiento económico",
        xaxis = list(title = "Índice de corrupción"),
        yaxis = list(title = "PBI per cápita"),
        paper_bgcolor = "transparent",
        plot_bgcolor = "transparent",
        font = list(color = "#547A95")
      )
  })
  
  datos_pronostico <- reactive({
    req(input$forecast_country)
    
    df <- replacement_rate_countries %>%
      filter(name == input$forecast_country)
    
    validate(need(nrow(df) >= 2, "No hay datos suficientes para el pronóstico."))
    
    modelo <- lm(value ~ year, data = df)
    
    historico <- df %>%
      mutate(tipo = "Histórico")
    
    futuro <- data.frame(year = 2024:2030) %>%
      mutate(
        value = as.numeric(predict(modelo, newdata = .)),
        geo = unique(df$geo)[1],
        name = input$forecast_country,
        tipo = "Predicción"
      )
    
    resultado <- bind_rows(historico, futuro)
    attr(resultado, "slope") <- coef(modelo)[2]
    
    resultado
  })
  
  output$forecast_plot <- renderPlotly({
    df <- datos_pronostico()
    
    plot_ly(
      data = df,
      x = ~year,
      y = ~value,
      type = "scatter",
      mode = "lines+markers",
      color = ~tipo
    ) %>%
      layout(
        title = paste("Proyección en", input$forecast_country),
        xaxis = list(title = "Año"),
        yaxis = list(title = "Hijos por mujer"),
        paper_bgcolor = "transparent",
        plot_bgcolor = "transparent",
        font = list(color = "#547A95"),
        shapes = list(
          list(
            type = "line",
            x0 = 2012,
            x1 = 2030,
            y0 = 2.1,
            y1 = 2.1,
            line = list(color = "#FF6B6B", dash = "dash")
          )
        )
      )
  })
  
  output$trend_text <- renderText({
    df <- datos_pronostico()
    paste0(round(attr(df, "slope"), 4), " h/año")
  })
  
  output$year_alert_text <- renderText({
    df <- datos_pronostico()
    
    debajo <- df %>%
      filter(value < 2.1) %>%
      arrange(year)
    
    if (nrow(debajo) == 0) {
      "Estable (>2.1)"
    } else {
      as.character(debajo$year[1])
    }
  })
  
  output$global_map_plot <- renderPlotly({
    req(input$forecast_year_select)
    
    df <- replacement_rate_countries %>%
      filter(year == input$forecast_year_select)
    
    validate(need(nrow(df) > 0, "Sin datos para el mapa."))
    
    plot_geo(data = df, locations = ~toupper(geo)) %>%
      add_trace(
        z = ~value,
        text = ~name,
        marker = list(line = list(color = "#FFFFFF", width = 0.3)),
        colorbar = list(title = "Natalidad")
      ) %>%
      layout(
        geo = list(
          scope = "world",
          showframe = FALSE,
          showcoastlines = TRUE,
          projection = list(type = "robinson")
        ),
        paper_bgcolor = "transparent",
        plot_bgcolor = "transparent",
        font = list(color = "#547A95")
      )
  })
  
  output$natality_boxplot <- renderPlotly({
    req(input$forecast_year_select, input$forecast_country)
    
    df <- replacement_rate_countries %>%
      filter(year == input$forecast_year_select)
    
    pais <- df %>%
      filter(name == input$forecast_country)
    
    p <- plot_ly() %>%
      add_boxplot(
        data = df,
        y = ~value,
        name = paste("Año", input$forecast_year_select),
        boxpoints = "outliers"
      )
    
    if (nrow(pais) > 0) {
      p <- p %>%
        add_markers(
          x = paste("Año", input$forecast_year_select),
          y = pais$value[1],
          name = input$forecast_country,
          marker = list(size = 12, symbol = "diamond")
        )
    }
    
    p %>%
      layout(
        title = paste("Rango global vs", input$forecast_country),
        yaxis = list(title = "Tasa de natalidad"),
        paper_bgcolor = "transparent",
        plot_bgcolor = "transparent",
        font = list(color = "#547A95")
      )
  })
  
  output$dynamic_bubble_plot <- renderPlotly({
    df <- replacement_rate_countries_gdp %>%
      filter(!is.na(value_natality), !is.na(value_gdp))
    
    plot_ly(
      data = df,
      x = ~value_gdp,
      y = ~value_natality,
      frame = ~year,
      type = "scatter",
      mode = "markers",
      color = ~name_natality,
      text = ~paste("País:", name_natality),
      showlegend = FALSE
    ) %>%
      layout(
        xaxis = list(title = "PBI per cápita", type = "log"),
        yaxis = list(title = "Hijos por mujer"),
        paper_bgcolor = "transparent",
        plot_bgcolor = "transparent",
        font = list(color = "#547A95")
      )
  })
}