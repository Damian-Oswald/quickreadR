#' @title Determine the maximum number of tokens based on the model
#' 
determine_max_tokens <- function(model) {
   if(model=="gpt-4") return(7000)
   else if(model=="gpt-3.5-turbo-16k") return(14000)
   else if(model=="gpt-3.5-turbo") return(3500)
   else return(3500)
}
