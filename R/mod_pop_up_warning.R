#' pop_up_warning UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_pop_up_warning_ui <- function(id) {
  ns <- NS(id)
  tagList(
 
  )
}
    
#' pop_up_warning Server Functions
#'
#' @noRd 
mod_pop_up_warning_server <- function(id, r_global){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    observeEvent(TRUE, once = TRUE, {
      
      golem::invoke_js(
        "alert_with_html_and_image",
        list(
          title = "Do Not Disturb",
          html = "
          This Application helps you to make naturalist observations thanks to a community of passionate observers. <br>
          <br>
          Be respectful to animals! Do not get too close, be quiet, and do not disturb them!.<br>
          ",
          icon = "warning",
          showCloseButton = FALSE,
          showCancelButton = FALSE,
          confirmButtonText = "Ok",
          imageUrl = NULL,
          imageWidth = 500,
          imageHeight = 300
        )
      )
      
    })
    
    
 
  })
}
    
## To be copied in the UI
# mod_pop_up_warning_ui("pop_up_warning_1")
    
## To be copied in the server
# mod_pop_up_warning_server("pop_up_warning_1")
