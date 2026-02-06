#' vote UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom confetti useConfetti sendConfetti
#' @importFrom googlesheets4 gs4_auth sheet_append
mod_vote_ui <- function(id) {
  ns <- NS(id)
  tagList(
    
    useConfetti(),
    
    
    fluidPage(
      
      fluidRow(
        div(
          style = "display: flex; justify-content: center; align-items: center;",
          
          p("Here you can record your observation.")
          
          ))
      ,
      
      fluidRow(
        div(
          style = "display: flex; justify-content: center; align-items: center;",
      textInput( 
        inputId = ns("name"), 
        label = "Name Observer", 
        placeholder = "Paul Newman"
      )))
      
      , 
      
      fluidRow(
        div(
          style = "display: flex; justify-content: center; align-items: center;",
      selectInput( 
        inputId = ns("order"), 
        label = "Order", 
        choices = c("Birds", "Marine Mammals", "E.T.")
      ))), 
      
      
      fluidRow(
        div(
          style = "display: flex; justify-content: center; align-items: center;",
      textInput( 
        inputId = ns("species"), 
        label = "Species", 
        placeholder = "Delphinus Delphis"
      ))), 
      
      fluidRow(
        div(
          style = "display: flex; justify-content: center; align-items: center;",
      textInput( 
        inputId = ns("groupsize"), 
        label = "Groupe Size", 
        placeholder = "14"
        
      ))), 
      
      
      fluidRow(
        div(
          style = "display: flex; justify-content: center; align-items: center;",
      mod_geoloc_ui("geoloc_1")
        )), 
      
      
      fluidRow(
        div(
          style = "display: flex; justify-content: center; align-items: center;",
      textInput( 
        inputId = ns("lon"), 
        label = "Longitude", 
        placeholder = "-2"
        
      ))), 
      
      fluidRow(
        div(
          style = "display: flex; justify-content: center; align-items: center;",
      textInput( 
        inputId = ns("lat"), 
        label = "Latitude", 
        placeholder = "45"
        
      ))), 
      
      fluidRow(
        div(
          style = "display: flex; justify-content: center; align-items: center;",
      actionButton(
        inputId = ns("vote"),
        label = "Record Observation"
      ))) 
      
      

    
      
      
    )
    
  )
}
    
#' vote Server Functions
#'
#' @noRd 
mod_vote_server <- function(id, r_global){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
    observeEvent(input$vote , {
      
      showNotification(
        ui = "Recording observation",
        type = "message", 
        duration = 10)
      
      
      gs4_auth(cache = ".secrets", email = "guillaumechero@gmail.com")
      sheet_id <- "https://docs.google.com/spreadsheets/d/1aYitux2QvQCyrk-WeE7cYeZWVFa_ZUdSOeqX38xDLuk/edit?gid=0#gid=0"

      data = data.frame(
        Names = input$name, 
        Order = input$order, 
        Species = input$species, 
        GroupSize = input$groupsize, 
        Longitude = input$lon, 
        Latitude = input$lat, 
        DateTime = format(Sys.time())
        
      )
      
      sheet_append(sheet_id, data)
      
      sendConfetti(
        colors = list("#DAB436", "#36DA62", "#365CDA", "#DA36AE"),
        spread = 360
        
      )
      
      
    })
      
      
    
  })
}
    
## To be copied in the UI
# mod_vote_ui("vote_1")
    
## To be copied in the server
# mod_vote_server("vote_1")
