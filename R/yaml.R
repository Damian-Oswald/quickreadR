#' @title Create a YAML header
#' 
yaml <- function(x, filename = "quickread", format = "html", toc = FALSE, number_sections = FALSE, title = paste("Quickread of",gsub(".pdf","",basename(x$path)))) {
   cat("---")
   cat("\ntitle: Quickread")
   if(any(format%in%c("html","pdf","docx"))) {
      cat("\nformat:")
      for (i in format[format%in%c("html","pdf","docx")]) {
         cat("\n    ",i,":",sep="")
         cat("\n        toc:",ifelse(toc, "true", "false"))
         cat("\n        number-sections:",ifelse(number_sections, "true", "false"))
         cat("\n        toc-depth: 1")
         if(i=="pdf") {
            cat("\n        geometry:")
            cat("\n          - top=15mm")
            cat("\n          - bottom=20mm")
            cat("\n          - left=20mm")
            cat("\n          - right=20mm")
            cat("\n        documentclass: article")
         }
      }
   }
   cat("\n---")
}
