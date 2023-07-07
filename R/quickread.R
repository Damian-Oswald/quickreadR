#' Send a prompt to ChatGPT
#' 
#' @param description TODO
#' @param details TODO
#' 
#' @param path The search path for the PDF
#' @param instruction The instruction for ChatGPT
#' @param enable_shorten If the text extracted from the PDF exceeds `max_tokens`, should the text be split up in chunks, individually summarized and be put together again? Defaults to `TRUE`. Note that this allows heavy (charged) usage of ChatGPT, and in the case of `model = "gpt-4"`, it might lead to an error due to OpenAI's usage limit for its models.
#' @param language Language for both the hidden ChatGPT prompts as well as the document output. Currently supports `"English"` and `"German"`. Note that the GPT models have been trained on data from the internet, which includes text in hundreds of languages, but is very biased towards English. Thus, the model's responses and "reasoning skills" might be the best in English, even though it reads a PDF in another language.
#' @param remove A character vector specifying what to remove from the text. Currently supports `"references"` for removing the list of references from an article, `"brackets"` for removing all content within brackets, and `"parentheses"` for removing all content within parentheses.
#' @param verbose Should progress be printed in the console?
#' @param model The model to be used. This parameter is sent to the OpenAI API, so it should match with one of their [listed models](https://platform.openai.com/docs/models/gpt-3-5). With the `quickreader` package, the following models are supported: `gpt-3.5-turbo`, `gpt-3.5-turbo-16k`, and `gpt-4`.
#' @param openai_api_key The API key for the OpenAI API. By default, the key will be searched for as `OPENAI_API_KEY` in the system environments. In order to set up an OpenAI API key, you need to sign up for the [OpenAI API](https://openai.com/product), and generate your personal secret API key on [this site](https://platform.openai.com/) (Personal, and select View API keys in drop-down menu). You can then copy the key by clicking on the green text Copy.
#' @param max_tokens The maximal number of tokens the text sent to ChatGPT may consist of. If the number of tokens exceeds `max_token`, the text is split up and iteratively processed.
#' 
#' @export
quickread <- function(path = NULL, instruction = NULL, enable_shorten = TRUE, language = "English", remove = c("references", "brackets"), verbose = TRUE, model = "gpt-3.5-turbo-16k", openai_api_key = Sys.getenv("OPENAI_API_KEY"), max_tokens = determine_max_tokens(model)){
   
   # Check if necessary arguments are provided
   if(is.null(path)|is.null(instruction)) stop("Please provide a path to a PDF as well as an exact instruction on what to do with it.")
   
   # Function to read ONE single document
   read_one <- function(x, instruction = instruction, enable_shorten = enable_shorten, language = language, remove = remove, verbose = verbose, model = model, openai_api_key = openai_api_key, max_tokens = max_tokens) {
      
      # Extract text from the PDF
      text <- quickreadR::pdf2text(path = x, remove = remove)
      
      # Save number of tokens in the text
      n <- ntokens(text)
      
      # Optionally: Make a summary of the text if it exceeds the maximum number of tokens digestible by `gpt-3.5`
      if(n>max_tokens & enable_shorten){
         summary <- quickreadR::shorten(text, language = language, max_tokens = max_tokens, model = model, openai_api_key = openai_api_key)
         prompt <- paste0(summary$summary, "\n\n", instruction)
      } else if(n>max_tokens & !enable_shorten) {
         warning("The PDF in question is too long to read in one go. Please enable intermittent shortening of the PDF (`enable_shortening = TRUE`) if you wish to summarize this PDF anyways.")
         return(NULL)
      } else{
         prompt <- paste0(text, "\n\n", instruction)
         summary <- NULL
      }
      
      # Generate the response
      response <- quickreadR::runGPT(prompt = prompt, model = model, openai_api_key = openai_api_key)
      
      # Create a quickread object
      result <- list(path = x,
                     instruction = instruction,
                     response = response,
                     ntokens = n,
                     title = gsub(".pdf","",basename(x)),
                     summary = summary$summary,
                     text = text,
                     model = model,
                     summary_chunks = summary$n,
                     max_tokens = max_tokens,
                     language = language)
      class(result) <- "quickread"
      
      return(result)
   }
   
   # Check if the path connects to a single PDF (local or URL), or if it is a directory containing multiple PDFs
   if(dir.exists(path)) path <- file.path(path, dir(path)[grep(".pdf",dir(path))])
   if(length(path) > 1) {
      return(lapply(path, read_one, instruction = instruction, enable_shorten = enable_shorten, language = language, remove = remove, verbose = verbose, model = model, openai_api_key = openai_api_key, max_tokens = max_tokens))
   } else if(length(path)==1) {
      return(read_one(path, instruction = instruction, enable_shorten = enable_shorten, language = language, remove = remove, verbose = verbose, model = model, openai_api_key = openai_api_key, max_tokens = max_tokens))
   }
}

