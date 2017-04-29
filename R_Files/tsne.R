train<- read.csv("E:/ADSProject/Classification/Final/t-SNE_input.csv") 
library(Rtsne)
Labels <- train$Keyword
train$Keyword <- as.factor(train$Keyword)

colors = rainbow(length(unique(train$Keyword)))
names(colors) = unique(train$Keyword)

train$Keyword = factor(train$Keyword)

tsne <- Rtsne(train[,], dims = 2, perplexity=30, verbose=TRUE, max_iter = 300, check_duplicates = FALSE)

plot(tsne$Y, main="tsne", col = colors[train$Keyword])
text(tsne$Y, labels=train$Keyword, col=colors[train$Keyword])
