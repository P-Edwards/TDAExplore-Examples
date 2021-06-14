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



# potential_radii <- (1:6)*30
# potential_patch_ratios <- (1/3)*(1:6)
potential_radii <- c(75)
potential_patch_ratios <- c(2.0)
potential_proportions <- c(0.025)

parameters_for_testing_runs <- expand.grid(radius=potential_radii,ratio=potential_patch_ratios,proportion=potential_proportions)
number_per_parameter_selection <- 50
number_of_folds <- 5

accuracies_results <- list()
for(i in 1:nrow(parameters_for_testing_runs)) { 
  for(j in 1:number_per_parameter_selection) { 
    parameters <- parameters_for_testing_runs[i,]
    radius_of_patches <- parameters$radius
    # Patch ratio is a hyperparameter; static for now
    patch_ratio <- parameters$ratio
    proportion_sparse <- parameters$proportion
    training_results <- TDAExplore::TDAExplore(parameters=parameters_file_name,number_of_cores=number_of_cores,radius_of_patches=radius_of_patches,patch_ratio=patch_ratio,proportion=proportion_sparse,svm=TRUE,verbose=TRUE,benchmark=FALSE,number_of_folds=number_of_folds)  
    this_run_accuracies <- list()
    this_run_accuracies$per_patch_accuracies <- training_results$svm[[number_of_folds]]$svm_patch_accuracies
    this_run_accuracies$per_image_accuracies <- training_results$svm[[number_of_folds]]$svm_image_accuracies
    this_run_accuracies$parameters <- parameters
    accuracies_results <- c(accuracies_results,list(this_run_accuracies))
  }
}

save(accuracies_results,file="computation_results/50x_main_hyperparameters.RData",version=2)












