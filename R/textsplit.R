#' @title Split the text at given sentences
#' 
#' @description This function splits an input text into `n` parts, where the sum of tokens of every part is less than or equal to `max_tokens`. It returns a character vector with the individual text parts.
#' @details For better comprehension of the return value of `textsplit`, the text is only split by full sentences and not by individual tokens.
#' 
#' @param text An input text (character vector with one element).
#' @param max_tokens The maximal number of tokens one sub-part of the text ought to consist of.
#' 
#' @export
textsplit <- function(text, max_tokens = 12000){
   
   # Check if the text is *splittable*
   if(quickreadR::ntokens(text)<=max_tokens) {
      warning("The provided text is shorter than the maximum number of tokens (`max_tokens`) allowed.")
      return(text)
   }
   
   # Divide the text into sentences
   sentences <- unname(unlist(strsplit(text, "\\. ")))
   
   # Count the number of tokens per sentence
   sentencelengths <- unname(sapply(sentences, quickreadR::ntokens))
   
   # Calculate how many times the text needs to be divided
   n <- sum(sentencelengths)%/%max_tokens
   
   # Define the locations of the splits (expressed in tokens)
   splits <- tail(head(seq(0,sum(sentencelengths),l=n+2),-1),-1)
   
   # Find the indices of the sentences
   indices <- c(0,sapply(1:n, function(i) sum(cumsum(sentencelengths)<splits[i])),length(sentences))
   
   # Create n + 1 lists of sentences, where the sum of tokens in every list is less than or equal to max_token
   sentencelist <- lapply(1:(n+1), function(i) sentences[tail(indices[i]:indices[i+1],-1)])
   
   # Combine the elements of every list to one text
   unlist(lapply(sentencelist, function(x) paste(x,collapse=". ")))
}






