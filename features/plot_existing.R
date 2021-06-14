library(ggplot2)


for(plotting_details in plotting_data) { 
  if(is.null(plotting_details)) { next }
  if(plotting_details$dim == 1) { 
    boxplot_data <- data.frame(features=plotting_details$data,types=plotting_details$named_types)
    p <- ggplot(boxplot_data,aes(x=types,y=features))+xlab("Experimental groups")+ylab("Average topological score") + geom_boxplot(fill=NA)+theme_minimal()+scale_fill_manual(values=c("blue","red","green","purple","turquoise","orange"))+scale_color_manual(values=c("blue","red","green","purple","turquoise","orange"))+theme(legend.position="none",text=element_text(size=20)) 
    if(length(plotting_details$types) < 200) {
      p <- p+geom_dotplot(binaxis='y',stackdir='center',dotsize=0.5,mapping=aes(fill=types,color=types))
    }
    p
    ggsave(file.path(image_results_directory,paste('boxplot_',plotting_details$name,plotting_name_stem,'.svg',sep="")),width=15,height=10)
  } 
}

plotting_details <- plotting_data$image_svm
classes <- levels(plotting_details$named_types)
classification_status <- vector("character",length=length(plotting_details$data))
classification_name <- vector("character",length=length(plotting_details$data))
for(i in 1:length(plotting_details$data)) {     
  if(plotting_details$data[i] < 0) { 
    classification_name[i] <- classes[1]
    if(plotting_details$named_types[i] == classes[1]) {
      classification_status[i] <- "Correct"  
    } else { 
      classification_status[i] <- "Incorrect"
    }
  } else { 
    classification_name[i] <- classes[2]
    if(plotting_details$named_types[i]==classes[2]) {
     classification_status[i] <- "Correct"  
    } else {
      classification_status[i] <- "Incorrect"
    }
  }
}
boxplot_data_for_confusion <- data.frame(features=plotting_details$data,types=plotting_details$named_types,testtypes=factor(classification_name),labelstatus=classification_status,replicate=plotting_data$image_svm$which_run)  
boxplot_data_for_confusion[,"testtypes"] <- factor(boxplot_data_for_confusion[,"testtypes"],levels=rev(levels(boxplot_data_for_confusion[,"testtypes"])))
actual_labels <- levels(boxplot_data_for_confusion[,"types"])
levels(boxplot_data_for_confusion[,"types"]) <- c(paste("Actual ",actual_labels[1]),paste("Actual ",actual_labels[2]))
predicted_labels <- levels(boxplot_data_for_confusion[,"testtypes"])
levels(boxplot_data_for_confusion[,"testtypes"]) <- c(paste("Predicted ",predicted_labels[1]),paste("Predicted ",predicted_labels[2]))

base_confusion_matrix <- table(boxplot_data_for_confusion[,"testtypes"],boxplot_data_for_confusion[,"types"])
if(actual_labels[1]!=predicted_labels[1]) {
  base_confusion_matrix <- base_confusion_matrix[,c(2,1)]
  accuracy <- 100*sum(diag(base_confusion_matrix))/sum(base_confusion_matrix)
} else { 
  accuracy <- 100*sum(diag(base_confusion_matrix))/sum(base_confusion_matrix)  
}
confusion_matrix <- as.data.frame(base_confusion_matrix[,c(2,1)])

p <- ggplot(data = confusion_matrix,
       mapping = aes(x = Var1,
                     y = Var2)) +
  geom_tile(aes(fill = Freq)) +
  geom_text(aes(label = sprintf("%1.0f", Freq)), vjust = 1,size=10) +
  scale_fill_gradient(low = "blue",
                      high = "red") +
  xlab(paste("Testing accuracy: ",round(accuracy,0),"%")) +
  ylab("") +
  theme(legend.position="none",panel.background = element_blank(),text=element_text(size=16,face="bold"))
p
ggsave(file.path(image_results_directory,paste(plotting_name_stem,"_confusion_matrix.svg",sep="")),width=7,height=3.5)    
