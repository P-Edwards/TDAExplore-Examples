# If you rerun performance assessment computations using "repeated_computation.R"
# you can run this script in its folder with Rscript extract_main_runs_performance.R. It will 
# aggregate the individual datasets into one file for convenience. 


folder_names <- c("ARP_CK","bbbc13","bbbc14","bbbc15","bbbc16","binucleate","Cofilin","liver_al_gender","liver_cr_gender","Mena","mito","PFN1","TB4")

results_extracts <- list()
number_of_runs <- length(folder_names)
for(i in 1:number_of_runs) { 
  results_extracts[[i]] <- local({load(paste(folder_names[i],"/computation/computation_results/50x_main_hyperparameters_rev.RData",sep=""));environment()})  
}

save(results_extracts,file="aggregated_main_runs_w_addl_metrics.RData",version=2)