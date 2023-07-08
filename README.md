# quickreadR

An R package that facilitates making summaries or extracting other useful information from PDFs, based on ChatGPT.

This package requires other software to fully work, namely `Python 3`, `Quarto` and `LaTeX`. In addition, you'll need a subscription to the OpenAI API.

## Setting up an OpenAI API key

Before you can use `quickreadR`, you'll have to set up an OpenAI account. The company is charging for the usage of their models, however, for sporadic usage, it's not very pricey. Using `gpt-3.5-turbo` (a faster version of ChatGPT) currently costs 0.002 USD for 1000 generated tokens[^token], whereas images created by DALL-E 2 go for two cents each.

[^token]: In the context of large language models like GPT-3, a token refers to a unit of text that the model processes during both the training and inference stage.
Tokens can be individual characters, words, or subwords, depending on the tokenization method used.
In the case of OpenAI's tokenization, one word in English equals about 1.33 tokens on average.

The wrapper for the OpenAI API is called `openai` and can be downloaded directly from CRAN [@rudnytskyi2023].
In order to use the API, you'll have to provide an API key.
For this, sign up for the [OpenAI API](https://openai.com/product), and generate your personal secret API key [on this site](https://platform.openai.com/) (Personal, and select View API keys in drop-down menu).
You can then copy the key by clicking on the green text Copy.

The secret key will be used in every function that calls a model via the API, but alternatively, you may also set up a global variable such that you only pass the key once.

``` r
Sys.setenv(OPENAI_API_KEY = "<SECRET KEY>")
```

Make sure to replace `<SECRET KEY>` with your actual secret API key. Once this is done, you will be able to use OpenAI's models directly from within R, and you won't have to pass the API key to any functions from the `opanai` package.

## Installation

You can install the `quickreadR` package directly from GitHub using `devtools`.

```{r}
devtools::install_github("Damian-Oswald/quickreadR")
library(quickreadR)
```

## Example

The main function in the `quickreadR` package is `quickread`. You'll have to provide three arguments at least: a path to a PDF, a instruction on what to do with it, and a personal OpenAI API key.
The path may also be for a directory containing many PDFs; in that case, the instruction is followed iteratively for every PDF individually.

``` {r}
x <- quickread(path = "https://arxiv.org/pdf/1706.03762.pdf",
               instruction = "Please write a detailed summary of this paper such that a non-expert may understand it.",
               openai_api_key = "<OPENAI API KEY>")

print(x)
export(x, filename = "Attention is all you need")
```