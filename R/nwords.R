#' Count the number of words
#' 
#' This function counts the number of words in a character vector called `text`. Note that the function splits the text by white spaces, thus numbers and connected special character also count as words.
#' 
#' @param text An input text (character vector with one element).
#' 
#' @export
nwords <- function(text){
   length(unlist(strsplit(text, " ")))
}
