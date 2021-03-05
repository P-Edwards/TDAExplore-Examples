load("arp_ctrl_75rad_2rat_50times.RData")
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

# Bar plot for 1D parameter space

accuracy_frame <- data.frame("Ratio"=ratio,"Radius"=factor(radius),"patch"=avg_patch_accuracy,"image"=avg_image_accuracy,"Run"=1:length(ratio))
hist_plot <- ggplot(accuracy_frame,aes(x=Radius,y=image)) + 
  xlab("") + 
  ylab(paste("Number of images correct out of ",total/372)) +
  geom_boxplot(fill=NA) + 
  theme_minimal() + 
  scale_fill_manual(values=c("blue","red","green","purple","turquoise","orange")) + 
  scale_color_manual(values=c("blue","red","green","purple","turquoise","orange")) + 
  theme(legend.position="none",text=element_text(size=20)) +
  geom_dotplot(binaxis='y',stackdir='center',dotsize=0.5,mapping=aes(fill=Radius,color=Radius)) 


png("arp_fifty_times_image_accuracy.png",height=512,width=512)
print(hist_plot)
dev.off()

