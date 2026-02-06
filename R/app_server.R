#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
	# Your application server logic
  r_global <- reactiveValues()
  
  mod_vote_server("vote_1", r_global = r_global)
  
  mod_result_server("result_1", r_global = r_global)
  
  mod_geoloc_server("geoloc_1", r_global = r_global)
  
  mod_pop_up_warning_server("pop_up_warning_1", r_global = r_global)
  
  
}
