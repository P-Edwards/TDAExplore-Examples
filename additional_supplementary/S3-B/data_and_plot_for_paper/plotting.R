load("arp_over_ratio_and_radius.RData")
ratio <- vector("double",length(accuracies_results))
radius <- vector("double",length(accuracies_results))
avg_patch_accuracy <- vector("double",length(accuracies_results))
avg_image_accuracy <- vector("double",length(accuracies_results))
i <- 1
for(result in accuracies_results) { 
  ratio[i] <- accuracies_results[[i]]$parameters$ratio
  radius[i] <- accuracies_results[[i]]$parameters$radius
  correct <- 0 
  for(table in accuracies_results[[i]]$image_confusion_tables) { 
    correct <- correct+sum(diag(table))
  }
  avg_image_accuracy[i] <- correct
  correct <- 0
  total <- 0
  for(table in accuracies_results[[i]]$confusion_tables) { 
    correct <- correct+sum(diag(table))
    total <- total+sum(table)
  }
  avg_patch_accuracy[i] <- correct/total
  i <- i+1
}



library(ggplot2)
library(dplyr)
# Bar plot for 1D parameter space

accuracy_frame <- data.frame("Ratio"=ratio,"Radius"=radius,"patch"=avg_patch_accuracy,"image"=avg_image_accuracy)
plotting_frame <-  accuracy_frame %>% dplyr::group_by(Ratio,Radius) %>% dplyr::summarise(accuracy=mean(image),.groups="keep")

tile_plot <- ggplot(data=plotting_frame,mapping=aes(x=Ratio,y=Radius,fill=accuracy))+geom_tile()+
  scale_fill_gradient(low="white",high="red") +
  scale_y_continuous(breaks=10*(4:13)) +
  scale_x_continuous(breaks=.25*(1:10)) 


png("arp_over_parameter_grid.png",height=512,width=512)
print(tile_plot)
dev.off()

