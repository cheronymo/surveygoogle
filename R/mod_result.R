#' result UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom googlesheets4 gs4_auth read_sheet
#' @importFrom ggplot2 ggplot aes geom_density
#' @import magrittr 
#' @importFrom sf st_as_sf
#' @importFrom dplyr mutate filter select
#' @importFrom leaflet leaflet addTiles setView leafletOutput renderLeaflet addMarkers
#' @importFrom DT dataTableOutput datatable renderDataTable
mod_result_ui <- function(id) {
  ns <- NS(id)
  tagList(
    
    sidebarLayout(
      sidebarPanel = 
        sidebarPanel(
          width = 3,
        fluidPage(
          
          sliderInput(
            inputId = ns("latest"), 
            label = "Last observation since (in hour):", 
            min = 1, 
            max = 72, 
            value = 72, 
            step = 1
          ), 
          
          selectInput(
            inputId = ns("select_order"), 
            label = "Select group of Species", 
            choices = c("All", "Birds", "Marine Mammals", "E.T."), 
            selected = "All"

          )
          
          
          
          
          
        )
      ), 
      
      mainPanel = 
        mainPanel(
          
          leafletOutput(
            outputId = ns("map")), 
          
          DT::dataTableOutput(outputId = ns("dataset"))
          
          
          
      )
    )
    
  
  
 
  )
}
    
#' result Server Functions
#'
#' @noRd 
mod_result_server <- function(id, r_global){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
      
    
    showNotification(
        ui = "Connecting to database",
        type = "default", 
        duration = 15)
      
      

    gs4_auth(cache = ".secrets", email = "guillaumechero@gmail.com")
    sheet_id <- "https://docs.google.com/spreadsheets/d/1aYitux2QvQCyrk-WeE7cYeZWVFa_ZUdSOeqX38xDLuk/edit?gid=0#gid=0"
    data_read <- read_sheet(sheet_id)
    

    # Transform data
    data_read_transform <- data.frame(
      Names = data_read$Names, 
      Order = data_read$Order, 
      Species = data_read$Species, 
      GroupSize = do.call(rbind,data_read$GroupSize), 
      Longitude = do.call(rbind,data_read$Longitude), 
      Latitude = do.call(rbind,data_read$Latitude), 
      DateTime = data_read$DateTime
      ) %>% 
      mutate(lon = as.numeric(Longitude), 
             lat = as.numeric(Latitude)) %>% 
      sf::st_as_sf(coords = c("lon", "lat"), crs = 4326) %>% 
      dplyr::mutate(DateTime = as.POSIXct(DateTime, format = "%Y-%m-%d %H:%M:%OS"))
    

    
    
    
    observeEvent(
      eventExpr = {
        input$latest
        input$select_order
      },
       {
      
         # select delay (if 72,take everything)
        if(input$latest == 72){
          r_global$filter =
            data_read_transform
        } else{
        r_global$filter =
          data_read_transform %>%
          dplyr::mutate(gap = difftime(format(Sys.time()), DateTime, units = "hours")) %>% 
          dplyr::filter(gap < input$latest) %>% 
          dplyr::select(-gap)
        }
         
        # Select Order
        if(input$select_order == "All"){
          r_global$selected = r_global$filter 
        } else {
          r_global$selected =
            r_global$filter %>% filter(Order == input$select_order )
        }
        
        # If nothing create empty data
        if(dim( r_global$selected)[1]==0){
          r_global$selected = data.frame(
            Names = NA, 
            Order = NA, 
            Species = NA, 
            GroupSize = NA, 
            Longitude = NA, 
            Latitude = NA, 
            DateTime = NA
          ) 
        }
    })
    
    
    # Make Plot
    map_df = reactive({
      r_global$selected
      })
    
    output$map = renderLeaflet({

      leaflet(data = r_global$selected) %>%
        addTiles() %>%
        setView(lng = -5, lat = 46, zoom = 5) %>% 
        addMarkers(~as.numeric(Longitude),
                   ~as.numeric(Latitude), 
                   popup = paste("Order:", r_global$selected$Order, "<br>",
                                 "Species:", r_global$selected$Species, "<br>",
                                 "GroupSize:", r_global$selected$GroupSize,"<br>", 
                                 "DateTime:", r_global$selected$DateTime, "<br>")
                   , label = ~Order)
      
      
    })
    
    
  
      
      
      
    # Show Dataset
    output$dataset <- DT::renderDataTable({
      datatable(options = list(scrollX = TRUE),
                r_global$selected
      )
    })
    
    
    
    
 
  })
}
    
## To be copied in the UI
# mod_result_ui("result_1")
    
## To be copied in the server
# mod_result_server("result_1")
