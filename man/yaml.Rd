% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/yaml.R
\name{yaml}
\alias{yaml}
\title{Create a YAML header}
\usage{
yaml(
  x,
  filename = "quickread",
  format = "html",
  toc = FALSE,
  number_sections = FALSE,
  title = paste("Quickread of", gsub(".pdf", "", basename(x$path)))
)
}
\description{
Create a YAML header
}
