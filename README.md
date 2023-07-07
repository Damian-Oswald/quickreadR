# quickreadR

An R package that facilitates making summaries or extracting other useful information from PDFs, based on ChatGPT.

This package requires other software to fully work, namely `Python 3`, `Quarto` and `LaTeX`. In addition, you'll need a subscription to the OpenAI API.

# Installation

You can install the `quickreadR` package directly from GitHub using `devtools`.

```{r}
devtools::install_github("Damian-Oswald/quickreadR")
library(quickreadR)
```

# Example

The main function in the `quickreadR` package is `quickread`. You'll have to provide three arguments at least: a path to a PDF, a instruction on what to do with it, and a personal OpenAI API key.
The path may also be for a directory containing many PDFs; in that case, the instruction is followed iteratively for every PDF individually.

``` {r}
x <- quickread(path = "https://arxiv.org/pdf/1706.03762.pdf",
               instruction = "Please write a detailed summary of this paper such that a non-expert may understand it.",
               openai_api_key = "<OPENAI API KEY>")

print(x)
export(x, filename = "Attention is all you need")
```
