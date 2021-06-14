number_of_cores <- 24
benchmarking_results <- data.frame(read.csv("benchmarking.csv"))

benchmarking_results <- data.frame(benchmarking_results,linear=benchmarking_results$ratio/benchmarking_results$radius**2)
benchmarking_results$per_core_mem <- benchmarking_results$max_rss/number_of_cores

# This is just least squares regression to get a slope and intercept
A <- cbind(benchmarking_results$linear,1)
y <- benchmarking_results$per_core_mem*1000
x_hat <- solve(t(A)%*%A)%*%t(A)%*%y

scientific_10 <- function(x) {
  gsub("e-0", "e-", scales::scientific_format()(x))
}

# Line is 450940 * x + 439
library(ggplot2)
exact_points <- data.frame(per_core_mem=c(599),linear=c(2/(75^2)))
ggplot(mapping=aes(x=linear,group=linear,y=per_core_mem*1000)) + 
  geom_abline(slope = x_hat[1],intercept=x_hat[2],color="red") +
  geom_dotplot(data=benchmarking_results,binaxis='y',stackdir='center',dotsize=0.5) + 
  geom_point(data=exact_points,mapping=aes(x=linear,y=per_core_mem,fill="orange"),color="orange",size=3,inherit.aes = FALSE) +
  xlab("Ratio/Radius^2") + 
  ylab("Maximum memory used per CPU (MB)") +
  scale_y_continuous(breaks=400+200*(0:8)) + 
  scale_x_continuous(breaks=.0005*(1:6),labels=scientific_10) + 
  guides(fill=FALSE)

  
target_cores <- 24
scaling_factor <- number_of_cores/target_cores

A <- cbind(benchmarking_results$linear,1)
y <- scaling_factor*benchmarking_results$time/60
x_hat <- solve(t(A)%*%A)%*%t(A)%*%y

exact_points <- data.frame(time=c(4.29,12.87),linear=c(2/(75^2),2/(75^2)))

# Line is 38837.5*x - 0.938
ggplot(mapping=aes(x=linear,group=linear,y=scaling_factor*time/60)) + 
  geom_abline(mapping=aes(slope = x_hat[1],intercept=x_hat[2],color="red"),show.legend=TRUE) +
  geom_abline(mapping=aes(slope = x_hat[1]*3,intercept=x_hat[2]*3,color="blue"),show.legend=TRUE) +
  geom_dotplot(data=benchmarking_results,mapping=aes(fill="black"),binaxis='y',stackdir='center',dotsize=0.5) +
  geom_point(data=exact_points,mapping=aes(x=linear,y=time,fill="orange"),color="orange",size=3,inherit.aes = FALSE) +
  xlab("Ratio/Radius^2") + 
  ylab("Total computation time (minutes)") +
  scale_y_continuous("Time (minutes)",
                     breaks=c(4.29,12.87,5*scaling_factor*c(1.5/scaling_factor,(1:10)))) + 
  scale_x_continuous(breaks=c(.0005*(1:6),.00036),labels = scientific_10) + 
  scale_fill_manual(name="",guide=guide_legend(override.aes = list( linetype=c(0,0),fill=c("black","orange"),color=c("black","orange"))),values=c("black"="black","orange"="orange"),labels=c("Observed value, 24CPU","Predicted value @ Ratio/Radius^2 = 2/75^2")) +
  scale_color_manual(name="",guide=guide_legend(override.aes = list(linetype=c(1,1),color=c("red","blue"),shape=c(NA,NA))),values=c("red"="red","blue"="blue"),labels=c("Least squares, 24CPU","Predicted, 8CPU"," ")) +
  guides(size=FALSE) +
  theme(legend.background = element_blank()) 
  
  

