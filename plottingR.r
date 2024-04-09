## This script shows some examples of plotting with ggplot2, base R and plotly.
#Can be used to either transform ggplot2 to interactive plots or to directly create interactive plots using plotly functions

# Load Libraries
library(ggplot2)
library(dplyr)
library(plotly)
library(hrbrthemes)
library(htmlwidgets)
library(tidyverse)
library(viridis)
library(heatmaply)

#Load sample data (iris dataset)
data(iris)
summary(iris)
dim(iris)
variables <- names(iris)


#### Scatterplot

## ggplot2

ggplot.1 <- ggplot(iris, aes(x=Petal.Length, y=Petal.Width)) +
  geom_point(color="#FFA500", alpha=0.8, size=3) +
  ggtitle("Petal length and width") +
  #theme_ipsum() + optional theme
  theme(plot.title = element_text(size=15)) +
  ylab('Petal width') +
  xlab('Petal length')
ggplot.1

## Base R

plot(iris$Petal.Length, iris$Petal.Width, main = "Petal length and width",
     xlab = 'Petal length', ylab = 'Petal width',
     pch = 19, col=alpha("#FFA500", 0.8))
grid(nx = 11, ny = 8)

## Plotly

plotly.1 <- plot_ly(data = iris, x = ~Petal.Length, y = ~Petal.Width,type="scatter", opacity=0.7,mode="markers",text = ~Species,size = 3,
                    marker=list(color="#FFA500",line = list(color = "#FFA500",
                                                             width = 2)))%>% 
  layout(title = "Petal length and width",
         yaxis = list(title='Petal Length'),
         xaxis = list(title='Petal width'))
plotly.1

#### Multi-histogram

##ggplot2
ggplot.2 <- ggplot(iris, aes(x=Sepal.Width, fill=Species)) +
  geom_histogram(color="#e9ecef", alpha=0.6, position = 'identity') +
  scale_fill_manual(values=c("#69b3a2", "#FFA500","#404080" )) +
  #theme_ipsum() +
  theme(plot.title = element_text(size=15)) +
  ggtitle("Sepal width")+
  ylab('Count') +
  xlab('Sepal width')
ggplot.2

##base R
setosa <- iris[iris$Species=="setosa",]$Sepal.Width
versicol <- iris[iris$Species=="versicolor",]$Sepal.Width
virginica <- iris[iris$Species=="virginica",]$Sepal.Width

grid()
# First distribution
hist(setosa, breaks=30,border="#e9ecef", col=alpha("#69b3a2",0),xlab="height", 
     ylab="Count", main="Histogram" )
grid(nx = 11, ny = 8)
hist(setosa, breaks=30, border="#e9ecef",col=alpha("#69b3a2", 0.6), xlab="height", 
     ylab="Count", main="Histogram",add=T)
# Second with add=T to plot on top
hist(versicol, breaks=30, col=alpha("#404080",0.6),border="#e9ecef",add=T)
# Third with add=T to plot on top
hist(virginica, breaks=30, col=alpha("#FFA500",0.6),border="#e9ecef",add=T)
# Add legend
legend("topright", legend=c("Setosa","Versicolor", "Virginica"), col=c("#69b3a2","#404080","#FFA500"), pt.cex=2, pch=15 )


## plotly 
plotly.2 <- plot_ly(alpha = 0.6) %>% 
  add_histogram(x = setosa, opacity=0.6,marker= list(color ="#404080",line =list(color="#e9ecef", width=1)), name= "Setosa") %>% 
  add_histogram(x = versicol,opacity=0.6,marker= list(color = "#69b3a2",line =list(color="#e9ecef", width=1)),name= "Versicolor") %>% 
  add_histogram(x = virginica,opacity=0.6,marker= list(color = "#FFA500",line =list(color="#e9ecef", width=1)),name= "Virginica") %>% 
  
  layout(barmode = "overlay", title="Histogram example", xaxis = list(title = "Value",showgrid = TRUE), yaxis = list(title = "Count",showgrid = TRUE)
  )
plotly.2 