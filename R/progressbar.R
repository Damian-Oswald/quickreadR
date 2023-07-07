#' Printing a progress bar
#' 
#' This function prints out a progress bar in the console.
#' 
#' @param i The current step.
#' @param n The total number of steps, must be greater than i.
#' @param message An optional message to be printed in front of the progress bar.
#' 
#' @export
progressbar <- function(i, n, message = "") {
   w <- (options("width")$width-6-nchar(message)) / n
   cat("\r", message," [", strrep("=",ceiling(i*w)), ">", strrep("-", floor((n-i)*w)),"] ",paste0(format(round(i/n*100, 1),nsmall=1),"%"),sep="")
}
