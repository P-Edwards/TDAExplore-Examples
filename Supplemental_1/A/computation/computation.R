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



potential_radii <- c(45,55,65,75,85,95,105,115,125,135,145,155)
potential_patch_ratios <- c(2)


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
	accuracies_results <- c(accuracies_results,list(this_run_accuracies))
}


number_of_runs <- length(accuracies_results)
names_for_labels <- vector(mode="character",length=number_of_runs)
for(i in 1:number_of_runs) { 
  current_results <- accuracies_results[[i]]
  current_parameters <- current_results$parameters
  names_for_labels[i] <- paste(current_parameters$radius,"R_",i,sep="")
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
radii_names <- factor(radii_names,levels=names_for_labels)
run_frame <- data.frame(Radii=radii_names,Accuracy=per_patch_accuracy,Type=run_type)

patch_plot <- ggplot(run_frame,mapping=aes(x=Radii,y=Accuracy,color=Type))+
  geom_dotplot(binaxis='y',stackdir='center',dotsize=0.5)+stat_summary(mapping=aes(group=Type),geom="line",fun.y=mean,size=2)+
  theme(text=element_text(size=15))+ylab("Patch accuracy")+scale_y_continuous(breaks=c(5*(1:12)/50,(60:100)/100))

# Image accuracies
for(i in 1:length(accuracies_results)) { 
  per_patch_accuracy[((i-1)*5+1):(5*i)] <- accuracies_results[[i]]$per_image_accuracies
  radii_names[((i-1)*5+1):(5*i)] <- names_for_labels[i]
}
radii_names <- factor(radii_names,levels=names_for_labels)
run_frame <- data.frame(Radii=radii_names,Accuracy=per_patch_accuracy,Type=run_type)

image_plot <- ggplot(run_frame,mapping=aes(x=Radii,y=Accuracy,color=Type))+
  geom_dotplot(binaxis='y',stackdir='center',dotsize=0.5)+stat_summary(mapping=aes(group=Type),geom="line",fun.y=mean,size=2)+
  theme(text=element_text(size=15))+ylab("Image accuracy")+scale_y_continuous(breaks=c(5*(1:12)/50,(60:100)/100))


png("computation_results/pfn1_many_radius_patch_accuracy.png",height=512,width=512)
print(patch_plot)
dev.off()
png("computation_results/pfn1_many_radius_image_accuracy.png",height=512,width=512)
print(image_plot)
dev.off()

save(accuracies_results,file="computation_results/pfn1_many_radius.RData",version=2)












