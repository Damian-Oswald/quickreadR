#' @title Shorten a too long text
#' 
#' @description This function shortens texts that are too long for OpenAI's LLMs to handle at once by splitting it up in chunks and summarizing them individually.
#' 
#' @param text An input text (character vector with one element).
#' @param max_tokens The maximal number of tokens one sub-part of the text ought to consist of.
#' 
#' @export
shorten <- function(text, path = NULL, language = "English", verbose = TRUE, max_tokens = 14000, model = "gpt-3.5-turbo-16k", openai_api_key = Sys.getenv("OPENAI_API_KEY")){
   
   # If the text is not longer than the maximum number of tokens (`max_tokens`), don't shorten it
   if (quickreadR::ntokens(text) <= max_tokens) {
      warning("The provided text is shorter than the maximum number of tokens (`max_tokens`) allowed.")
      return(text)
   }
   
   # Split the long text into chunks of less than `max_tokens` tokens
   chunks <- quickreadR::textsplit(text, max_tokens = max_tokens)
   n <- length(chunks)
   
   # Summarize individual text chunks
   summaries <- character(n)
   if(!is.null(path) & verbose) cat("\nShortening \"",basename(path),"\"...\n", sep = "")
   if(verbose) quickreadR::progressbar(0, n)
   for (i in 1:n) {
      prompt <- paste0(chunks[i], "\n\nPlease create a detailed summary in", language, "capturing the main points and key details of the previous text.")
      if(verbose) quickreadR::progressbar(i, n)
      summaries[i] <- tryCatch(quickreadR::runGPT(prompt, model = model, openai_api_key = openai_api_key), error = function(e) return(NULL))
   }
   summary <- paste(summaries, collapse = "\n\n")
   return(list(summary = summary, n = n))
}
