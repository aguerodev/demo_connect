# Cargamos las librerías necesarias
library(shiny)
library(shinyjs)
library(bslib)  # Librería para aplicar temas Bootstrap

# Definimos el UI de la aplicación
ui <- fluidPage(
  
  # Aplicamos el tema Minty
  theme = bs_theme(bootswatch = "minty"),
  
  # Inicializamos shinyjs
  useShinyjs(),
  
  # Título de la aplicación
  titlePanel("Escala de Calidad de Vida Profesional (Pro-QoL)"),
  
  # Creamos un espacio principal que cambia dinámicamente con cada pregunta
  mainPanel(
    uiOutput("pregunta_ui"),  # Espacio de salida para mostrar las preguntas dinámicamente
    
    # Pie de página con botones de navegación dentro del mismo mainPanel en un solo nivel
    fluidRow(
      column(6, align = "left", actionButton("anterior", "Anterior", class = "btn btn-success")),   # Botón para ir a la pregunta anterior, color verde
      column(6, align = "right", actionButton("siguiente", "Siguiente", class = "btn btn-success")),  # Botón para ir a la pregunta siguiente, color verde
      column(6, align = "center", actionButton("ver_resultados", "Ver Resultados", style = "display: none;", class = "btn btn-danger"))  # Botón para ver resultados, color rojo
    ),
    
    # Salida para mostrar las respuestas actuales (inicialmente oculta)
    hidden(
      div(id = "resultados_div", uiOutput("resultados_ui"))
    )
  )
)
