extract_statistics <- function(accuracies_results) { 
  output <- list()
  
  len <- length(accuracies_results)-1
  output$patch_aucs <- vector("double",len)
  output$image_aucs <- vector("double",len)
  output$patch_f1 <- vector("double",len)
  output$image_f1 <- vector("double",len)
  output$patch_recall <- vector("double",len)
  output$image_recall <- vector("double",len)
  output$patch_precision <- vector("double",len)
  output$image_precision <- vector("double",len)
  
  eps <- 1e-9  
  for(i in 2:length(accuracies_results)) { 
    this_run_results <- accuracies_results[[i]]
    accuracies_results[[i]]$patch_roc[1,] <- accuracies_results[[i]]$patch_roc[1,] + eps*(1:ncol(accuracies_results[[i]]$patch_roc)-1)
    accuracies_results[[i]]$patch_roc <- cbind(accuracies_results[[i]]$patch_roc,c(1,1))
    accuracies_results[[i]]$image_roc[1,] <- accuracies_results[[i]]$image_roc[1,] + eps*(1:ncol(accuracies_results[[i]]$image_roc)-1)
    accuracies_results[[i]]$image_roc <- cbind(accuracies_results[[i]]$image_roc,c(1,1))
    output$patch_aucs[i-1] <- this_run_results$patch_auc
    output$image_aucs[i-1] <- this_run_results$image_auc
    output$patch_f1[i-1] <- this_run_results$patch_f1
    output$image_f1[i-1] <- this_run_results$image_f1
    output$image_recall[i-1] <- this_run_results$image_recall
    output$patch_recall[i-1] <- this_run_results$patch_recall
    output$image_precision[i-1] <- this_run_results$image_precision
    output$patch_precision[i-1] <- this_run_results$patch_precision
  }
  

  patch_same_disc_rocs <- matrix(0L,nrow=length(accuracies_results)-1,ncol=2*ncol(accuracies_results[[2]]$patch_roc))
  image_same_disc_rocs <- matrix(0L,nrow=length(accuracies_results)-1,ncol=2*ncol(accuracies_results[[2]]$image_roc))
  for(i in 1:nrow(patch_same_disc_rocs)) { 
    this_run_results <- accuracies_results[[i+1]]
    patch_same_disc_rocs[i,] <- approx(this_run_results$patch_roc[1,],this_run_results$patch_roc[2,],method="constant",n=2*ncol(this_run_results$patch_roc),ties="ordered")$y
    image_same_disc_rocs[i,] <- approx(this_run_results$image_roc[1,],this_run_results$image_roc[2,],method="constant",n=2*ncol(this_run_results$image_roc),ties="ordered")$y
  }
  output$patch_roc <- patch_same_disc_rocs
  output$x_patch_roc <- approx(this_run_results$patch_roc[1,],this_run_results$patch_roc[2,],method="constant",n=2*ncol(this_run_results$patch_roc),ties="ordered")$x
  output$image_roc <- image_same_disc_rocs
  output$x_image_roc <- approx(this_run_results$image_roc[1,],this_run_results$image_roc[2,],method="constant",n=2*ncol(this_run_results$image_roc),ties="ordered")$x
  output$name <- accuracies_results$name
  return(output)
}

load("aggregated_main_runs_w_addl_metrics.RData")

lineError <- function(input_column){sd(input_column,na.rm=TRUE)}
apply_sd <- function(input_data) { 
  return(apply(input_data,2,lineError)) 
} 

y_mean_patch_values <- vector()
y_mean_image_values <- vector()
y_sd_patch_values <- vector()
y_sd_image_values <- vector() 
x_patch_values <- vector()
x_image_values <- vector()
expanded_patch_groups <- vector()
expanded_image_groups <- vector()

stats_combos <- expand.grid(c("patch","image"),c("aucs","f1","precision","recall"),stringsAsFactors = FALSE)
mean_stats_list <- list() 
sd_stats_list <- list()
for(i in 1:nrow(stats_combos)) { 
  this_name <- paste(stats_combos[i,1],stats_combos[i,2],sep="_")
  mean_stats_list[[this_name]] <- vector()
  sd_stats_list[[this_name]] <- vector()
}

number_of_runs <- length(results_extracts)
names <- vector()
for(i in 1:number_of_runs) { 
  z <- extract_statistics(results_extracts[[i]]$accuracies_results)
  names <- c(names,z$name)
  y_mean_patch_values <- c(y_mean_patch_values,colMeans(z$patch_roc))
  y_mean_image_values <- c(y_mean_image_values,colMeans(z$image_roc))
  y_sd_patch_values <- c(y_sd_patch_values,apply_sd(z$patch_roc))
  y_sd_image_values <- c(y_sd_image_values,apply_sd(z$image_roc))
  x_patch_values <- c(x_patch_values,z$x_patch_roc)
  x_image_values <- c(x_image_values,z$x_image_roc)
  expanded_patch_groups <- c(expanded_patch_groups,rep(z$name,ncol(z$patch_roc)))
  expanded_image_groups <- c(expanded_image_groups,rep(z$name,ncol(z$image_roc)))
  
  for(j in 1:nrow(stats_combos)) { 
    this_name <- paste(stats_combos[j,1],stats_combos[j,2],sep="_")
    mean_stats_list[[this_name]] <- c(mean_stats_list[[this_name]],mean(z[[this_name]]))
    sd_stats_list[[this_name]] <- c(sd_stats_list[[this_name]],sd(z[[this_name]]))
  }
}

# Make grobs for all the ROC's and then lay them out in a large grid figure

library(ggplot2)
library(gridExtra)
library(ggplotify)
library(grid)

plot_grobs <- list()
group_names <- unique(expanded_patch_groups)
for(i in 1:length(group_names)) { 
  indices <- which(expanded_patch_groups == group_names[i])
  line_data <- data.frame(X=x_patch_values[indices],Y=y_mean_patch_values[indices],sd=y_sd_patch_values[indices],Dataset=expanded_patch_groups[indices])
  line_plot <- ggplot(line_data,aes(x=X, y=Y,group=Dataset)) + 
    geom_line(aes(color=Dataset),size=1.0,color=i)+
    theme_bw() +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),text=element_text(size=14)) +
    labs(title=paste(group_names[i],sep="")) +
    geom_abline(slope=1,intercept=0,linetype="dashed") +
    ylab("True positive rate") +
    xlab("False positive rate") + theme(text=element_text(size=8))
  plot_grobs[[i]] <- line_plot
}

layout <- c(1:12,14,13,15)
dim(layout) <- c(3,5)
layout <- t(layout)
grid.arrange(grobs=plot_grobs,layout_matrix=layout,padding=unit(0.0,"null"))

plot_grobs <- list()
group_names <- unique(expanded_image_groups)
for(i in 1:length(group_names)) { 
  indices <- which(expanded_image_groups == group_names[i])
  line_data <- data.frame(X=x_image_values[indices],Y=y_mean_image_values[indices],sd=y_sd_image_values[indices],Dataset=expanded_image_groups[indices])
  line_plot <- ggplot(line_data,aes(x=X, y=Y,group=Dataset)) + 
    geom_line(aes(color=Dataset),size=1.0,color=i)+
    theme_bw() +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),text=element_text(size=14)) +
    labs(title=paste(group_names[i],sep="")) +
    geom_abline(slope=1,intercept=0,linetype="dashed") +
    ylab("True positive rate") +
    xlab("False positive rate") + theme(text=element_text(size=7))
  plot_grobs[[i]] <- line_plot
}

layout <- c(1:12,14,13,15)
dim(layout) <- c(3,5)
layout <- t(layout)
grid.arrange(grobs=plot_grobs,layout_matrix=layout,padding=unit(0.0,"null"))

