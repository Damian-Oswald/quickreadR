#' Estimate the OpenAI API usage cost
#' 
#' Estimate the cost of having a specific model process all the text for a given path.
#' 
#' @param path The search path for the PDF
#' @param model The model to be used. This parameter is sent to the OpenAI API, so it should match with one of their [listed models](https://platform.openai.com/docs/models/gpt-3-5). With the `quickreader` package, the following models are supported: `gpt-3.5-turbo`, `gpt-3.5-turbo-16k`, and `gpt-4`.
#' 
#' @details Calculates the expected cost for processing all the text found in `path`. The cost is calculated based on [OpenAI's pricing site](https://openai.com/pricing).
#' 
#' @export
estimate_cost <- function(path = NULL, model = "gpt-3.5-turbo-16k"){
   
   # Check if necessary arguments are provided
   if(is.null(path)) stop("Please provide a path to a PDF as well as an exact instruction on what to do with it.")
   
   
   # Check if the path connects to a single PDF (local or URL), or if it is a directory containing multiple PDFs
   if(dir.exists(path)) path <- file.path(path, dir(path)[grep(".pdf",dir(path))])
   
   # Count the total number of tokens
   n <- 0
   for (PDF in path) {
      text <- quickreadR::pdf2text(PDF)
      n <- n + quickreadR::ntokens(text)
   }
   
   # Cost per 1000 tokens
   openai_pricing <- c(`gpt-4` = 0.03, `gpt-3.5-turbo` = 0.0015, `gpt-3.5-turbo-16k` = 0.003)
   
   # Check if `model` is included in the pricing list
   if(!model%in%names(openai_pricing)) stop(paste("It seems the specified model is not included in the pricing list.\nPlease use one of the following: ", paste0("\"",names(openai_pricing),"\"", collapse = ", "), ".", sep = ""))
   
   # Get cost per 1000 tokens for the current model
   cost_per_token <- openai_pricing[model]/1000
   
   # Calculate estimated cost
   cost <- cost_per_token * n
   
   cat("The estimated cost for the usage of ", model, " is $", round(cost,3), ".\n", sep = "")
   
   return(cost)
}



