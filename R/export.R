#' Create a document from a `quickread` object
#' 
#' @param x A list of the class `quickread`.
#' 
#' @export
export <- function(x, filename = "quickread", format = "pdf", toc = {class(x)=="list"}, number_sections = {class(x)=="list"}, document_information = TRUE, print_summary = TRUE){
   
   # Function to make a title (in markdown)
   maketitle <- function(title, depth = 1) cat("\n\n",strrep("#",depth)," ",title,"\n\n",sep="")
   
   # Function to print out information for ONE document (in markdown table and text)
   print_one <- function(x){
      if(is.null(x$title)) maketitle(gsub(".pdf","",basename(x$path))) else maketitle(x$title)
      cat("\n")
      quickreadR:::info(x)
      cat("\n")
      cat(x$response)
      if(!is.null(x$summary) & print_summary) {
         maketitle("Intermittent summary of the full document", depth = 2)
         cat(x$summary)
      }
   }
   
   # Create a new markdown file
   sink(paste0(filename,".md"))
   
   # Write the YAML header
   quickreadR:::yaml(x, format = tolower(format), toc = toc, number_sections = number_sections, title = "Quickread summary file")
   
   # Print quickread general information
   if(document_information){
      maketitle("General information", 1)
      cat("This document was automatically created using the R package `quickreadR`. Below, you'll find the meta-information of this summary.\n\n")
      if(is.list(x[[1]])) quickreadR:::info(x[[1]],type="meta") else quickreadR:::info(x, type="meta")  
   }
   
   # Print results for each read PDF
   if(is.list(x[[1]])) {
      for (i in 1:length(x)) {
         print_one(x[[i]])
      }
   } else {
      print_one(x)
   }
   
   sink()
   
   # Rendering of the document
   if(any(format%in%c("html","pdf","docx"))) system(paste0("quarto render \"",file.path(getwd(),paste0(filename,".md")),"\""))
   if(!"md"%in%format) system(paste0("rm \"",file.path(getwd(),paste0(filename,".md")),"\""))
}










