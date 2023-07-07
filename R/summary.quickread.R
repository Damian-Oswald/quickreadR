#' Print out the summary of a text, if present
#' 
#' @param x A list of the class `quickread`.
#' 
#' @export
summary.quickread <- function(x){
   if(!is.null(x$summary)) {
      cat(x$summary)
   } else {
      warning("There was no intermittent summary created.")
   }
}
