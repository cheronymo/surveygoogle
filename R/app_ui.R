#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom bslib bs_theme input_dark_mode
#' @noRd
app_ui <- function(request) {
	tagList(
		# Leave this function for adding external resources
		golem_add_external_resources(), 
		
		fluidPage(
		  
		  theme = bs_theme(
		    bootswatch =   "cosmo",
		    bg = "#FFFFFF",
		    fg = "#000000",
		    primary = "#1B1B1B",
		    secondary = "#2E2E32"
		  ),
		  
		navbarPage(
		  title = "Observation community",
		  
		  tabPanel(
		    "New Observation", 
		    
		    
		    mod_pop_up_warning_ui("pop_up_warning_1"),
		    
		    mod_vote_ui("vote_1")

		    
		  ),
		  
		  tabPanel(
		    "Have a look on the map" , 
		    
		    
		    mod_result_ui("result_1")
		    
		    
		    
		  )
		  
		)
		    
		    
		
		)
		
		
		
	)
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
	add_resource_path(
		"www",
		app_sys("app/www")
	)

	tags$head(
		favicon(),
		bundle_resources(
			path = app_sys("app/www"),
			app_title = "surveygoogle"
		),
		# Add here other external resources
		# for example, you can add shinyalert::useShinyalert()
		
		# sweetalert2
		tags$script(src = "https://cdn.jsdelivr.net/npm/sweetalert2@11.10.7/dist/sweetalert2.all.min.js"),
		tags$link(href = "https://cdn.jsdelivr.net/npm/sweetalert2@11.10.7/dist/sweetalert2.min.css",
		          rel="stylesheet")
		
	)
}
