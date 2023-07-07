#' Print out the response of a quickread object
#' 
#' @param x A list of the class `quickread`.
#' 
#' @export
print.quickread <- function(x){
   make_line <- function(char) cat(strrep(char, getOption("width")-5), "\n")
   make_line("-")
   cat("Title:\t\t\t", gsub(".pdf", "", basename(x$path)))
   cat("\nInstruction:\t\t"," \"", x$instruction, "\"", sep = "")
   cat("\nNumber of tokens:\t", x$ntokens,"\n")
   if(!is.null(x$summary)) cat("Note:\t\t\t The original text was shortened in order to create this response.\n")
   make_line("-")
   cat(x$response,"\n",sep="")
   make_line("-")
}
