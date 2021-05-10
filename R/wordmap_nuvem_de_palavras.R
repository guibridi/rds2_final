# library(wordcloud)
# library(RColorBrewer)
# library(wordcloud2)
# library(tidyverse)
# library(janitor)
# library(tm)

# Criando um vetor contendo apenas texto

paralisadas <- readr::read_rds("data-raw/paralisadas.rds")

dplyr::glimpse(paralisadas)

texto <- paralisadas$motivo

# Criando um corpus

docs <- tm::Corpus(tm::VectorSource(texto))

# Limpando os textos

docs <- docs %>%
  tm::tm_map(tm::removeNumbers) %>%
  tm::tm_map(tm::removePunctuation) %>%
  tm::tm_map(tm::stripWhitespace)
docs <- tm::tm_map(docs, tm::content_transformer(tolower))
docs <- tm::tm_map(docs, tm::removeWords, tm::stopwords('portuguese'))

# Criando um "document-term-matrix" Matriz de termos do documento

dtm <- tm::TermDocumentMatrix(docs)
matriz <- as.matrix(dtm)
palavras <- sort(rowSums(matriz), decreasing = TRUE)
df <- data.frame(word = names(palavras), freq = palavras)

# Criando o mapa de palavras

wordcloud::wordcloud(
  words = df$word,
  freq = df$freq,
  min.freq = 5,
  max.words = 200,
  random.order = FALSE,
  rot.per = 0.35,
  scale = c(3.5, 0.25),
  colors = RColorBrewer::brewer.pal(8, "Dark2")
)

# Alternativamente, pode-se utilizar o pacote wordcloud2 (que é visualmente mais interessante)

wordcloud2::wordcloud2(data = df, size = 1.6, color = 'random-dark')


wordcloud2::wordcloud2(data = df, size = 0.5, shape = 'diamond')

# wordcloud2(data = df, size = 1, minSize = 0, gridSize =  0,
#            fontFamily = 'Segoe UI', fontWeight = 'bold',
#            color = 'random-dark', backgroundColor = "white",
#            minRotation = -pi/4, maxRotation = pi/4, shuffle = TRUE,
#            rotateRatio = 0.4, shape = 'circle', ellipticity = 0.65,
#            widgetsize = NULL, figPath = NULL, hoverFunction = NULL)
