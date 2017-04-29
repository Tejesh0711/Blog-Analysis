library(NLP)
library(tm)

data <- read.csv("E:/ADSProject/Classification/training_processed_input.csv")
corpus <- Corpus(VectorSource(data$section_title))

cleanset <- tm_map(corpus, removeWords, stopwords("english"))
cleanset <- tm_map(cleanset, stripWhitespace)

dtm <- DocumentTermMatrix(cleanset)

dtm_tfidf <- weightTfIdf(dtm)

m <- as.matrix(dtm_tfidf)
rownames(m) <- 1:nrow(m)

norm_eucl <- function(m)
  m/apply(m,1,function(x) sum(x^2)^.5)

m_norm <- norm_eucl(m)

results <- kmeans(m_norm, 10, 30)

clusters <- 1:4
for(i in clusters) {
  cat("Cluster ", i, ":", findFreqTerms(dtm_tfidf[results$cluster==i,],2),"\n\n")
}
