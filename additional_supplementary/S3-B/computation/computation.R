library(optparse) 
library(ggplot2)




option_list <- list(make_option(c("-p","--parameters"),type="character",default=NULL,help="File name of parameters .csv file to use. Relative to current directory or absolute."),
                    make_option(c("-c","--cores"),type="numeric",default=0,help="Number of cores on which to execute."))
opt <- parse_args(OptionParser(option_list=option_list))
if(is.null(opt$parameters)) { 
  stop("Must provide parameters file.")
} else { 
  parameters_file_name <- opt$parameters
}

# Default behavior: Use 2 cores
if(opt$cores) { 
  number_of_cores <- opt$cores
} else if("number_of_cores" %in% provided_parameters) { 
  number_of_cores <- data_parameters[1,"number_of_cores"]
} else { 
  number_of_cores <- 2
}



potential_radii <- c(rep(40,5),rep(50,5),rep(60,5),rep(70,5),rep(80,5),rep(90,5),rep(100,5),rep(110,5),rep(120,5),rep(130,5))
potential_patch_ratios <- c(0.25,0.5,0.75,1.0,1.25,1.5,1.75,2.0,2.25,2.5)


parameters_for_testing_runs <- list()
for(i in 1:length(potential_radii)) { 
	for(j in 1:length(potential_patch_ratios)) { 
		parameters_for_testing_runs[[paste(i,j)]] <- list()
		parameters_for_testing_runs[[paste(i,j)]]$radius <- potential_radii[i]
		parameters_for_testing_runs[[paste(i,j)]]$ratio <- potential_patch_ratios[j]
	}
}


accuracies_results <- list()
for(parameters in parameters_for_testing_runs) { 
	radius_of_patches <- parameters$radius
	# Patch ratio is a hyperparameter; static for now
	patch_ratio <- parameters$ratio
	training_results <- TDAExplore::TDAExplore(parameters=parameters_file_name,number_of_cores=number_of_cores,radius_of_patches=radius_of_patches,patch_ratio=patch_ratio,svm=TRUE,verbose=TRUE,benchmark=FALSE)  
	this_run_accuracies <- list()
	this_run_accuracies$per_patch_accuracies <- training_results$svm[[5]]$svm_patch_accuracies
	this_run_accuracies$per_image_accuracies <- training_results$svm[[5]]$svm_image_accuracies
	this_run_accuracies$parameters <- parameters
	accuracies_results <- c(accuracies_results,this_run_accuracies)
}


number_of_runs <- length(accuracies_results)
names_for_labels <- vector(mode="character",length=number_of_runs)
for(i in 1:number_of_runs) { 
  names_for_labels[i] <- paste(accuracies_results[[i]]$parameters$radius,"R_",i,sep="")
}

radii_names <- vector("character",5*length(accuracies_results))
per_patch_accuracy <- vector("double",5*length(accuracies_results))
run_type <- vector("character",5*length(accuracies_results))
run_type[1:(5*length(accuracies_results))] <- "Whole"


# Patch accuracies
for(i in 1:length(accuracies_results)) { 
  per_patch_accuracy[((i-1)*5+1):(5*i)] <- accuracies_results[[i]]$per_patch_accuracies
  radii_names[((i-1)*5+1):(5*i)] <- names_for_labels[i]
}

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


png("computation_results/arp_over_parameter_grid.png",height=512,width=512)
print(tile_plot)
dev.off()

save(accuracies_results,"computation_results/arp_over_parameter_grid.RData",version=2)












