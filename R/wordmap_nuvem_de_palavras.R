# STEP 1: Retrieving the data and uploading the packages
# To generate word clouds, you need to download the wordcloud package
# in R as well as the RcolorBrewer package for the colours. Note that
# there is also a wordcloud2 package, with a slightly different design
# and fun applications. I will show you how to use both packages.

# install.packages("wordcloud")
# install.packages("tm")
# install.packages("RColorBrewer")
# install.packages("wordcloud2")

library(wordcloud)
library(RColorBrewer)
library(wordcloud2)
library(tidyverse)
library(janitor)
library(tm)

# Most often, word clouds are used to analyse twitter data or a corpus of text.
# If you’re analysing twitter data, simply upload your data by using the rtweet
# package (see this article for more info on this). If you’re working on a speech,
# article or any other type of text, make sure to load your text data as a corpus.
# A useful way to do this is to use the tm package.

#Create a vector containing only the text

# paralisadas <-
#   read.csv2("dados/paralisadas_2020_uft8.csv",
#             encoding = "UTF-8")

paralisadas <-
  readxl::read_xlsx("dados/paralisadas_2020.xlsx")


paralisadas <- paralisadas %>%
  janitor::clean_names()

write_rds(paralisadas,"dados/paralisadas.rds")

text <- paralisadas$motivo

glimpse(paralisadas)

# Create a corpus

docs <- Corpus(VectorSource(text))

# STEP 2: Clean the text data
# Cleaning is an essential step to take before you generate your wordcloud. Indeed,
# for your analysis to bring useful insights, you may want to remove special characters,
# numbers or punctuation from your text. In addition, you should remove common stop words
# in order to produce meaningful results and avoid the most common frequent words such
# as “I” or “the” to appear in the word cloud.

# If you’re working with tweets, use the following line of code to clean your text.


# gsub("https\\S*", "", tweets$text)
# gsub("@\\S*", "", tweets$text)
# gsub("amp", "", tweets$text)
# gsub("[\r\n]", "", tweets$text)
# gsub("[[:punct:]]", "", data$text)

# If you’re working with a corpus, there are several packages you can use to
# clean your text. The following lines of code show you how to do this using the tm package.

docs <- docs %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) %>%
  tm_map(stripWhitespace)
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords('portuguese'))

# STEP 3: Create a document-term-matrix
# What you want to do as a next step is to have a dataframe containing each word
# in your first column and their frequency in the second column.
# This can be done by creating a document term matrix with the TermDocumentMatrix
# function from the tm package.

dtm <- TermDocumentMatrix(docs)
matrix <- as.matrix(dtm)
words <- sort(rowSums(matrix), decreasing = TRUE)
df <- data.frame(word = names(words), freq = words)

# Alternatively, and especially if you’re using tweets, you can use the tidytext package.

# tweets_words <-  tweets %>%
#   select(text) %>%
#   unnest_tokens(word, text)
# words <- tweets_words %>% count(word, sort=TRUE)

# STEP 4: Generate the word cloud
# The wordcloud package is the most classic way to generate a word cloud. The
# following line of code shows you how to properly set the arguments. As an
# example, I chose to work with the speeches given by US Presidents at the
# United Nations General Assembly.

?set.seed(1234) # for reproducibility
wordcloud(
  words = df$word,
  freq = df$freq,
  min.freq = 1,
  max.words = 200,
  random.order = FALSE,
  rot.per = 0.35,
  scale = c(5.0, 0.4),
  colors = brewer.pal(8, "Dark2")
)

# It may happen that your word cloud crops certain words or simply doesn’t show
# them. If this happens, make sure to add the argument scale=c(3.5,0.25) and play
# around with the numbers to make the word cloud fit.
#
# Another common mistake with word clouds is to show too many words that have
# little frequency. If this is the case, make sure to adjust the minimum
# frequency argument (min.freq=…) in order to render your word cloud more
# meaningful.
#
# The wordcloud2 package is a bit more fun to use, allowing us to do some more
# advanced visualisations. For instance, you can choose your wordcloud to appear
# in a specific shape or even letter (see this vignette for a useful tutorial).
# As an example, I used the same corpus of UN speeches and generated the two word
# clouds shown below. Cool, right?

wordcloud2(data = df, size = 1.6, color = 'random-dark')


wordcloud2(data = df, size = 0.5, shape = 'diamond')

# wordcloud2(data = df, size = 1, minSize = 0, gridSize =  0,
#            fontFamily = 'Segoe UI', fontWeight = 'bold',
#            color = 'random-dark', backgroundColor = "white",
#            minRotation = -pi/4, maxRotation = pi/4, shuffle = TRUE,
#            rotateRatio = 0.4, shape = 'circle', ellipticity = 0.65,
#            widgetsize = NULL, figPath = NULL, hoverFunction = NULL)
