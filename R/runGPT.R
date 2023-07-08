#' Send a prompt to ChatGPT
#' 
#' @param prompt The prompt to be sent to ChatGPT
#' @param model The model to be used. This parameter is sent to the OpenAI API, so it should match with one of their [listed models](https://platform.openai.com/docs/models/gpt-3-5).
#' @param openai_api_key The API key for the OpenAI API. By default, the key will be searched for as `OPENAI_API_KEY` in the system environments.
#' 
#' @export
runGPT <- function(prompt, model = "gpt-3.5-turbo-16k", openai_api_key = Sys.getenv("OPENAI_API_KEY")){
   tryCatch({
      openai::create_chat_completion(
         openai_api_key = openai_api_key,
         model = model,
         messages = list(list(role = "user", content = prompt))
      )$choices$message.content
   },
   error = function(e) return(NULL))
}