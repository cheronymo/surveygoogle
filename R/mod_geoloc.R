#' geoloc UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom geoloc button_geoloc
mod_geoloc_ui <- function(id) {
  ns <- NS(id)
  tagList(
    geoloc::button_geoloc(ns("myBtn"), "Get my Location"),
    textOutput(ns("coords")),
    textOutput(ns("col"))
    
  )
}
    
#' geoloc Server Functions
#'
#' @noRd 
mod_geoloc_server <- function(id, r_global){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    output$coords <- renderText(paste(input$myBtn_lat, input$myBtn_lon, sep = ", "))
    
    
    observeEvent(input$myBtn, {
 
      req(input$myBtn_lon)
      req(input$myBtn_lat)
      r_global$lon = input$myBtn_lon
      r_global$lat = input$myBtn_lat
      
    })
      
 
  })
}
    
## To be copied in the UI
# mod_geoloc_ui("geoloc_1")
    
## To be copied in the server
# mod_geoloc_server("geoloc_1")
