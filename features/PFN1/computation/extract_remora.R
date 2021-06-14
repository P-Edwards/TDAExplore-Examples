library(optparse)
option_list <- list(make_option(c("--radius"),type="numeric",default=0),
                    make_option(c("--ratio"),type="numeric",default=0))
opt <- parse_args(OptionParser(option_list=option_list))

radius_parameter <- opt$radius
ratio_parameter <- opt$ratio

memory_dir <- grep("*MEMORY*",list.dirs(),value=TRUE)

summary_file <- list.files(memory_dir,pattern="*all*",full.names = TRUE)
stat_file <- list.files(memory_dir,pattern="*stat*",full.names = TRUE)

summary_data <- read.table(summary_file)
stat_data <- read.table(stat_file)

max_rss <- summary_data$V3
time_in_seconds <- max(stat_data$V1) - min(stat_data$V1)

# Append to file 
row_to_write <- matrix(0L,1,4)
row_to_write[1,] <- c(radius_parameter,ratio_parameter,max_rss,time_in_seconds)
write.table(row_to_write,file="benchmarking.csv",sep=",",append=TRUE,col.names=FALSE,row.names=FALSE)

# Delete directory to prep for next run
unlink(dirname(memory_dir),recursive = TRUE)