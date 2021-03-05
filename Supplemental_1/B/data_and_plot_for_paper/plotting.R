library(ggplot2)

load("mito_DMSO_v_FCCP_many_radius.RData")
radii_names <- vector("character",5*length(accuracies_results))
per_patch_accuracy <- vector("double",5*length(accuracies_results))
run_type <- vector("character",5*length(accuracies_results))
run_type[1:(5*length(accuracies_results))] <- "Whole"


# Patch accuracies
for(i in 1:length(accuracies_results)) { 
  per_patch_accuracy[((i-1)*5+1):(5*i)] <- accuracies_results[[i]]$per_patch_accuracies
  radii_names[((i-1)*5+1):(5*i)] <- colnames(run_dissimilarities)[i]
}
radii_names <- factor(radii_names,levels=colnames(run_dissimilarities))
run_frame <- data.frame(Radii=radii_names,Accuracy=per_patch_accuracy,Type=run_type)

patch_plot <- ggplot(run_frame,mapping=aes(x=Radii,y=Accuracy,color=Type))+
  geom_dotplot(binaxis='y',stackdir='center',dotsize=0.5)+stat_summary(mapping=aes(group=Type),geom="line",fun.y=mean,size=2)+
  theme(text=element_text(size=15))+ylab("Patch accuracy")+scale_y_continuous(breaks=c(5*(1:12)/50,(60:100)/100))

# Image accuracies
for(i in 1:length(accuracies_results)) { 
  per_patch_accuracy[((i-1)*5+1):(5*i)] <- accuracies_results[[i]]$per_image_accuracies
  radii_names[((i-1)*5+1):(5*i)] <- colnames(run_dissimilarities)[i]
}
radii_names <- factor(radii_names,levels=colnames(run_dissimilarities))
run_frame <- data.frame(Radii=radii_names,Accuracy=per_patch_accuracy,Type=run_type)

image_plot <- ggplot(run_frame,mapping=aes(x=Radii,y=Accuracy,color=Type))+
  geom_dotplot(binaxis='y',stackdir='center',dotsize=0.5)+stat_summary(mapping=aes(group=Type),geom="line",fun.y=mean,size=2)+
  theme(text=element_text(size=15))+ylab("Image accuracy")+scale_y_continuous(breaks=c(5*(1:12)/50,(60:100)/100))


png("mito_many_radius_patch_accuracy.png",height=512,width=512)
print(patch_plot)
dev.off()
png("mito_many_radius_image_accuracy.png",height=512,width=512)
print(image_plot)
dev.off()

