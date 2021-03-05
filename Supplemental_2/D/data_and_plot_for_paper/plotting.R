load("pfn1_classifier_applied_to_other_controls.RData")
library(ggplot2)
plotting_name_stem <- "pfn1_classifier_applied_to_other_controls"
image_results_directory <- "."

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


