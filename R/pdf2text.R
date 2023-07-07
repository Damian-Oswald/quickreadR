#' Convert a PDF file to text
#' 
#' This function allows reading a PDF file into R either from the local drive or from the web and extracting the text from that PDF.
#' 
#' @param path The search path to a locally stored PDF file or the URL to a PDF in the internet.
#' @param remove A character vector specifying what to remove from the text. Currently supports `"references"` for removing the list of references from an article, `"brackets"` for removing all content within brackets, and `"parentheses"` for removing all content within parentheses.
#' 
#' @export
pdf2text <- function(path, remove = c("references","brackets")){
   
   text <- stringr::str_squish(paste0(paste0(pdftools::pdf_text(path), collapse = " "), collapse = " "))
   
   # replace repetitions of whitespaces with one single whitespace
   text <- gsub("\\s+", " ", text)
   
   # replace strings that would interrupt the model
   text <- gsub("<|endofprompt|>", "*endofprompt*", text)
   
   # remove content in brackets
   if("brackets" %in% remove) {
      target <- "\\[.*?\\]"
      text <- gsub(target, "", text)
   }
   
   # remove content in parentheses
   if("parentheses" %in% remove) {
      target <- "\\(.*?\\)"
      text <- gsub(target, "", text)
   }
   
   # remove content following the *last* mention of the word "references" -- case insensitively
   if("references" %in% remove) {
      target <- "\\bReferences|references|REFERENCES\\b"
      splittext <- unlist(strsplit(text, target))
      if(length(splittext)>1){
         text <- paste(head(splittext, -1), collapse = " ")
      } else{
         text <- splittext
      }
   }
   
   # return the final text
   return(text)
}
