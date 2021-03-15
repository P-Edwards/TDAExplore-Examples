library(ggplot2)
this_run_data <- aggregated_interval_reps[[plotting_name_stem]]
interval_reps <- rbind(this_run_data$first_class_intervals,this_run_data$second_class_intervals)
interval_reps <- -interval_reps
list_of_image_classes <- c(rep(this_run_data$first_class_name,nrow(this_run_data$first_class_intervals)),rep(this_run_data$second_class_name,nrow(this_run_data$second_class_intervals)))

image_classes <- unique(list_of_image_classes)
x_values <- rep(length(interval_reps[1,]):1,length(image_classes))
y_mean_values <- vector() 
y_sd_values <- vector() 
expanded_groups <- vector()
lineError <- function(input_column){sd(input_column)/sqrt(length(input_column))}
apply_sd <- function(input_data) { 
  return(apply(input_data,2,lineError)) 
} 
for(name in image_classes) { 
    this_class_data <- interval_reps[which(list_of_image_classes==name,arr.ind=TRUE),]
    y_mean_values <- c(y_mean_values,colMeans(this_class_data))
    y_sd_values <- c(y_sd_values,apply_sd(this_class_data))
    expanded_groups <- c(expanded_groups,rep(name,ncol(this_class_data)))
}
#plot as distance from leading edge, "group" refers to experimental groupings such as control or KO
line_data <- data.frame(X=2*x_values,Y=y_mean_values,sd=y_sd_values,Class=expanded_groups)
line_plot <- ggplot(line_data,aes(x=X, y=Y,group=Class)) + 
  geom_line(aes(color=Class), size=2.0)+
  theme_bw() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),text=element_text(size=14)) +
  ylab("Average topological score") +
  xlab("% Distance from leading edge")
line_plot <- line_plot + 
  geom_ribbon(aes(ymin=Y-sd,ymax=Y+sd,fill=Class,alpha=0.1),show.legend=FALSE) 
png(file.path(image_results_directory,paste('line_plot_',plotting_name_stem,'.png',sep="")),height=740,width=1280)
print(line_plot)
dev.off()