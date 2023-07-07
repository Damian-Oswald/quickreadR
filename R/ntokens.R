#' Count the number of tokens
#' 
#' This function counts the number of tokens in a character vector called `text` using the python package `tiktoken` provided by OpenAI.
#' 
#' @param text A string whose token encoding one wants to count.
#' 
#' @export
ntokens <- function(text){
   
   # If input text is empty, there is no need to try and count the tokens
   if(is.null(text)) return(0)
   
   # Load python dependency (this will install multiple dependencies including Miniconda if no suitable python installation is found
   tiktoken <- reticulate::import("tiktoken")
   
   # Get the encoding and return the token count
   length(tiktoken$get_encoding("cl100k_base")$encode(text))
   
}