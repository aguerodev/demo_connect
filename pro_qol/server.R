# Cargamos las librerías necesarias
library(shiny)
library(shinyjs)

# Creamos el servidor de la aplicación
server <- function(input, output, session) {
  
  # Lista de preguntas y opciones de respuesta
  preguntas <- c(
    "1. Soy feliz",
    "2. Estoy preocupado/a por uno o más de mis usuarios/as",
    "3. Estoy satisfecho/a de poder ayudar a la gente"
  )
  
  opciones <- c("Nunca", "Raramente", "Algunas veces", "Frecuentemente", "Siempre")
  
  # Variable reactiva para llevar la cuenta de la pregunta actual
  pregunta_actual <- reactiveVal(1)
  
  # Lista para almacenar respuestas
  respuestas <- reactiveValues(datos = rep(NA, length(preguntas)))
  
  # Output para la pregunta actual y las opciones de respuesta con la pregunta en negrita
  output$pregunta_ui <- renderUI({
    # Creamos un panel de pregunta y sus opciones
    list(
      radioButtons(
        inputId = paste0("respuesta_", pregunta_actual()), 
        label = tags$b(preguntas[pregunta_actual()]),  # Pregunta en negrita
        choices = opciones, 
        selected = respuestas$datos[pregunta_actual()]  # Recupera la respuesta seleccionada previamente
      )
    )
  })
  
  # Mostrar las respuestas cuando se hace clic en "Ver Resultados"
  output$resultados_ui <- renderUI({
    list(
      h3("Resultados:"),
      verbatimTextOutput("respuestas_ui")
    )
  })
  
  # Renderizar respuestas en texto
  output$respuestas_ui <- renderPrint({
    respuestas$datos
  })
  
  # Acción al presionar el botón "Siguiente"
  observeEvent(input$siguiente, {
    # Guardamos la respuesta seleccionada en la lista de respuestas
    respuesta_seleccionada <- input[[paste0("respuesta_", pregunta_actual())]]
    
    # Verificamos si la respuesta es nula (no seleccionada)
    if (is.null(respuesta_seleccionada)) {
      showNotification("Selecciona una respuesta para continuar.", type = "error")
    } else {
      respuestas$datos[pregunta_actual()] <- respuesta_seleccionada
      cat(respuestas$datos,"\n")
      # Cambiamos a la siguiente pregunta si no es la última
      if (pregunta_actual() < length(preguntas)) {
        pregunta_actual(pregunta_actual() + 1)
      }
    }
  })
  
  # Acción al presionar el botón "Anterior"
  observeEvent(input$anterior, {
    # Guardamos la respuesta seleccionada en la lista de respuestas solo si no es nula
    respuesta_seleccionada <- input[[paste0("respuesta_", pregunta_actual())]]
    
    if (!is.null(respuesta_seleccionada)) {
      respuestas$datos[pregunta_actual()] <- respuesta_seleccionada
    }
    
    # Cambiamos a la pregunta anterior si no es la primera
    if (pregunta_actual() > 1) {
      pregunta_actual(pregunta_actual() - 1)
    }
  })
  
  # Mostrar u ocultar botones dinámicamente
  observe({
    if (pregunta_actual() == length(preguntas)) {
      shinyjs::hide("siguiente")
      shinyjs::show("ver_resultados")
    } else {
      shinyjs::show("siguiente")
      shinyjs::hide("ver_resultados")
    }
  })
  
  # Mostrar resultados cuando se hace clic en "Ver Resultados"
  observeEvent(input$ver_resultados, {
    
    respuesta_seleccionada <- input[[paste0("respuesta_", pregunta_actual())]]
    # Verificamos si la respuesta es nula (no seleccionada)
    if (is.null(respuesta_seleccionada)) {
      showNotification("Selecciona una respuesta para continuar.", type = "error")
    } else {
      respuestas$datos[pregunta_actual()] <- respuesta_seleccionada
      cat(respuestas$datos,"\n")
      # Cambiamos a la siguiente pregunta si no es la última
      if (pregunta_actual() < length(preguntas)) {
        pregunta_actual(pregunta_actual() + 1)
      }
    }
    # Verificar si todas las preguntas están respondidas
    if (any(is.na(respuestas$datos))) {
      showNotification("Responde todas las preguntas para ver los resultados.", type = "error")
    } else {
      shinyjs::show("resultados_div")  # Mostrar el div de resultados
    }
  })
}
