## This script shows some examples of plotting with ggplot2, base R and plotly.
#Can be used to either transform ggplot2 to interactive plots or to directly create interactive plots using plotly functions

# Load Libraries
library(ggplot2) # for ggplot()
library(dplyr) # for %>%
library(plotly) # for plot_ly()
library(hrbrthemes)
library(htmlwidgets)
library(tidyverse)
library(viridis) # for viridis()
library(heatmaply)
library(reshape2) # for melt()
library(pheatmap) # for pheatmap()

#Load sample data (iris dataset)
data(iris)
summary(iris)
dim(iris)

# Plot parameters ==============================================================
# Examples: changing background colour, margins, arranging subplots 

#a) base R ---------------------------------------------------------------------
# parameters changes within par()
plot(iris$Petal.Length, iris$Petal.Width)
par(bg="lightblue", mar=c(5.1, 10, 4.1, 2.1)) # change bg to lightblue and widen left margin to 10
# bg = background colour; mar = margins (order: bottom, left, top, right)
plot(iris$Petal.Length, iris$Petal.Width)
par(bg="white", mar=c(5.1, 4.1, 4.1, 2.1)) # reset

par(mfrow=c(1,2))
plot(iris$Petal.Length, iris$Petal.Width, main='Plot 1')
plot(iris$Sepal.Length, iris$Petal.Width, main='Plot 2')
par(mfrow=c(1,1)) # reset


#b) ggplot2 --------------------------------------------------------------------
# parameters changed within theme()
p1 <- ggplot(iris, aes(x=Petal.Length, y=Petal.Width)) +
  geom_point() +
  theme(panel.background=element_rect(fill="lightblue"),
        plot.margin = unit(c(5.5,5.5,5.5,50), "pt")) # margin order: top, right, bottom, left. default = c(5.5,5.5,5.5,5.5)

p2 <- ggplot(iris, aes(x=Sepal.Length, y=Petal.Width)) +
  geom_point() +
  theme(panel.background=element_rect(fill="lightblue"),
        plot.margin = unit(c(5.5,5.5,5.5,50), "pt")) # margin order: top, right, bottom, left. default = c(5.5,5.5,5.5,5.5)

myplots <- list(p1,p2)
grid.arrange(myplots[[1]], myplots[[2]], ncol=2)


# Changing point colour and character type =====================================
#a) base R ---------------------------------------------------------------------
plot(iris$Petal.Length, iris$Petal.Width) # default: col='black', pch=1
plot(iris$Petal.Length, iris$Petal.Width, col="#FFA500", pch=16)

# changing conditionally based on Species
iris$Species <- as.factor(iris$Species)
iris$Species
c("#69b3a2","#404080","#FFA500")[iris$Species]

# change colour depending on Species
plot(iris$Petal.Length, iris$Petal.Width, col=c("#69b3a2","#404080","#FFA500")[iris$Species])
# change point character depending on Species
plot(iris$Petal.Length, iris$Petal.Width, pch=c(1,2,3)[iris$Species])
# change colour and pch simultaneously
plot(iris$Petal.Length, iris$Petal.Width, col=c("#69b3a2","#404080","#FFA500")[iris$Species], pch=c(1,2,3)[iris$Species])


#b) ggplot2 --------------------------------------------------------------------
ggplot(iris, aes(x=Petal.Length, y=Petal.Width)) +
  geom_point(color="#FFA500", shape=3) # default: col='black', pch=16

# just changing colour by Species can be achieved using ggplot(aes(color=Species))
ggplot(iris, aes(x=Petal.Length, y=Petal.Width, color=Species)) +
  geom_point()

# but to also change shape, instead set aes(group=Species)
ggplot(iris, aes(x=Petal.Length, y=Petal.Width, group=Species)) +
  geom_point(aes(shape=Species, color=Species))


#1. Scatter plot ===============================================================

#a) base R ---------------------------------------------------------------------
plot(iris$Petal.Length, iris$Petal.Width, main = "Petal length and width",
     xlab = 'Petal length', ylab = 'Petal width',
     pch = 19, col=alpha("#FFA500", 0.8))
grid(nx = 11, ny = 8)

#b) ggplot2 --------------------------------------------------------------------
scatt.ggplot <- ggplot(iris, aes(x=Petal.Length, y=Petal.Width)) +
  geom_point(color="#FFA500", alpha=0.8, size=3) +
  ggtitle("Petal length and width") +
  #theme_ipsum() + optional theme
  theme(plot.title = element_text(size=15)) +
  ylab('Petal width') +
  xlab('Petal length')
scatt.ggplot

#c) plotly --------------------------------------------------------------------
scatt.plotly <- plot_ly(data = iris, x = ~Petal.Length, y = ~Petal.Width,type="scatter", opacity=0.7,mode="markers",text = ~Species,size = 3, marker=list(color="#FFA500",line = list(color = "#FFA500", width = 2)))%>% 
  layout(title = "Petal length and width",
         yaxis = list(title='Petal Length'),
         xaxis = list(title='Petal width'))
scatt.plotly





#2. Simple histogram ===========================================================
setosa <- iris[iris$Species=="setosa",]

#a) base R ---------------------------------------------------------------------
hist(setosa$Sepal.Width, breaks=30, border="#e9ecef", col=alpha("#69b3a2",0.6),xlab="height", ylab="Count", main="base R")
grid(nx = 11, ny = 8)
# 30 breaks

#b) ggplot2 --------------------------------------------------------------------
hist.ggplot <- ggplot(setosa, aes(x=Sepal.Width)) +
  geom_histogram(fill=alpha("#69b3a2",0.6), bins=20)+ # 20 bins
  theme(plot.title = element_text(size=15)) +
  ggtitle("ggplot")+
  ylab('Count') +
  xlab('Sepal width')+
  theme_minimal()
hist.ggplot

#c) plotly ---------------------------------------------------------------------
hist.plotly <- plot_ly(x=~setosa$Sepal.Width, type='histogram', nbinsx=30, marker=list(color=alpha("#69b3a2",0.6))) %>% layout(title="Plotly", xaxis=list(title='Sepal Width', showgrid=T), yaxis=list(title='Count', showgrid=T))
hist.plotly
# 30 bins





#3. Multi-histogram ============================================================

#a) base R ---------------------------------------------------------------------
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

#b) ggplot2 --------------------------------------------------------------------
multhist.ggplot <- ggplot(iris, aes(x=Sepal.Width, fill=Species)) +
  geom_histogram(color="#e9ecef", alpha=0.6, position = 'identity') +
  scale_fill_manual(values=c("#69b3a2", "#FFA500","#404080" )) +
  #theme_ipsum() +
  theme(plot.title = element_text(size=15)) +
  ggtitle("Sepal width")+
  ylab('Count') +
  xlab('Sepal width')
multhist.ggplot

#c) plotly ---------------------------------------------------------------------
multhist.plotly <- plot_ly(alpha = 0.6) %>% 
  add_histogram(x = setosa, opacity=0.6,marker= list(color ="#404080",line =list(color="#e9ecef", width=1)), name= "Setosa") %>% 
  add_histogram(x = versicol,opacity=0.6,marker= list(color = "#69b3a2",line =list(color="#e9ecef", width=1)),name= "Versicolor") %>% 
  add_histogram(x = virginica,opacity=0.6,marker= list(color = "#FFA500",line =list(color="#e9ecef", width=1)),name= "Virginica") %>% 
  layout(barmode = "overlay", title="Histogram example", xaxis = list(title = "Value",showgrid = TRUE), yaxis = list(title = "Count",showgrid = TRUE))
multhist.plotly





#4. Simple boxplot =============================================================

#a) base R ---------------------------------------------------------------------
plot.new() # create blank plot
grid(nx = NULL, ny = NULL) # add grid lines
par(new = TRUE) # to ensure boxplot is added to same plot
boxplot(Petal.Width ~ Species, data=iris, col=c("#69b3a2", "#FFA500","#404080"), bty='n', xlab="Species", ylab="Petal length", main="base R")
legend("bottomright", legend=c("Setosa","Versicolor", "Virginica"), col=c("#69b3a2","#404080","#FFA500"), pt.cex=2, pch=15)

#b) ggplot2 --------------------------------------------------------------------
box.ggplot <- ggplot(iris, aes(x=Species, y=Petal.Width, fill=Species)) +
  geom_boxplot()+
  scale_fill_manual(values=c("#69b3a2", "#FFA500","#404080" )) +
  theme(plot.title = element_text(size=15)) +
  ggtitle("ggplot")+
  ylab('Petal length') +
  xlab('Species')+
  theme_minimal()
box.ggplot

#c) plotly ---------------------------------------------------------------------
# 30 bins
box.plotly <- plot_ly(iris, x=~Species, y=~Petal.Width, type='box', color=~Species, colors=c("#69b3a2","#404080","#FFA500")) %>% layout(title="Plotly", xaxis=list(title='Sepal Width', showgrid=T), yaxis=list(title='Count', showgrid=T))
box.plotly





#5. Grouped boxplot ============================================================
iris$Area <- c(rep(c("Low Area", "Mid Area", "Large Area"),50))

#a) base R ---------------------------------------------------------------------
bop <- boxplot(Petal.Length~Species*Area, data=iris,
             col = c("#69b3a2","#404080","#FFA500"), 
             main = "Petal area per petal length", 
             xlab = "Area", 
             ylab = "Petal Length",   
             outline = TRUE,    # Optional: Show outliers
             horizontal = FALSE, xaxt = "n")
areas <- c("Large Area", "Mid Area","Low Area" )
bop <- axis(1, 
            at = c(2,5,8.5), 
            labels = areas, 
            tick=TRUE , cex=0.3)
bop <- legend("bottomright", legend = unique(iris$Species), 
            col=c("#69b3a2","#404080","#FFA500"),
            pch = 15, bty = "n", pt.cex = 2, cex = 1.2,  horiz = F, inset = c(0, 0.2))

#b) ggplot2 --------------------------------------------------------------------
gbox.ggplot <- ggplot(iris, aes(x=Area, y=Petal.Length, fill=Species)) + 
  geom_boxplot()+ labs(title="Petal area per petal length")+ylab("Petal length" )+scale_fill_manual(values=c("#69b3a2","#404080","#FFA500"))
gbox.ggplot

#c) plotly ---------------------------------------------------------------------
gbox.plotly <- plot_ly(iris, x = interaction(iris$Area,iris$Species), y = iris$Petal.Length, color = iris$Species,type = "box",colors=c("#69b3a2","#404080","#FFA500")) %>% 
  layout(title = "Petal area per petal length",yaxis = list(title='Petal Length'),xaxis = list(title='Petal Area',categoryarray = areas))
gbox.plotly





#6. Heatmaps ===================================================================
petal.length <- unique(sort(iris$Petal.Length))
petal.width <- unique(sort(iris$Petal.Width))
areaPetal <- matrix(data=NA, nrow = length(petal.length), ncol = length(petal.width))
for(i in 1:length(petal.length)){
  for(j in 1:length(petal.width)){
    area=petal.length[i]*petal.width[j]
    areaPetal[i,j]=area
  }
}
rownames(areaPetal)<- as.character(petal.length)
colnames(areaPetal)<- as.character(petal.width )

#a) base R/pheatmap ------------------------------------------------------------
pheatmap(areaPetal, cluster_rows = F, cluster_cols = F, main="Petal area",color = hcl.colors(50, "BluYl"))

#b) ggplot2 --------------------------------------------------------------------
areaPetal.m <- melt(areaPetal)
colnames(areaPetal.m) <- c("Length", "Width", "Area")
heatm.ggplot <-ggplot(areaPetal.m, aes(x=Width, y=Length)) + 
  geom_tile(aes(fill=Area)) +scale_fill_gradientn(colors = hcl.colors(50, "BluYl")) +ggtitle("Petal area")
heatm.ggplot

#c) plotly ---------------------------------------------------------------------
heatm.plotly <- plot_ly(
  x = petal.width, y =petal.length,
  z = areaPetal, type = "heatmap"
) %>% layout(title = "Petal area",
        yaxis = list(title='Petal Length'),
        xaxis = list(title='Petal width'))
heatm.plotly

