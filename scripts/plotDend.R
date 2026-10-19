plotDend <- function(PLOT_DENDOGRAM,hc,bestK){

if(PLOT_DENDROGRAM){
  dend <- as.dendrogram(hc)
  dend <- color_branches(dend, k = bestK)
  plot(dend)
  
}
}