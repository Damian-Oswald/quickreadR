#' @title Create a pipe-style table for a `quickread` class object
#' 
info <- function(x = NULL, path = x$path, ntokens = x$ntokens, summary = x$summary, instruction = x$instruction, model = x$model, max_tokens = x$max_tokens, type = "document") {
   cat("|  |          |\n")
   cat("|--|----------|\n")
   if(type=="document"){
      cat("| **Path** |`",path,"`|\n",sep="")
      cat("| **Tokens** |`",ntokens,"`|\n",sep="")
      if(!is.null(x$summary)) cat("| **Note** |`The response was generated via an intermittent summary of ",x$summary_chunks," chunks.`|\n",sep="")
      cat(": {tbl-colwidths=\"[20,80]\"}\n")
   } else if(type=="meta"){
      cat("| **Instruction** |`",instruction,"`|\n",sep="")
      cat("| **Model** |`",model,"`|\n",sep="")
      cat("| **Max. tokens** |`",max_tokens,"`|\n",sep="")
      cat("| **Timestamp** |`",as.character(Sys.time()),"`|\n",sep="")
      cat(": {tbl-colwidths=\"[20,80]\"}\n")
   }
}
