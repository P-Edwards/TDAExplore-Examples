load("aggregated_many_hyperparameters.RData")

library(ggplot2)
ggplot(all_models_frame,aes(x=types,y=image)) +
  xlab("Data set")+
  ylab("Average image testing accuracy") + 
  geom_boxplot(fill=NA,outlier.shape=NA) +
  theme_minimal() +
  theme(legend.position="none",text=element_text(size=12))  + 
  geom_dotplot(data=data.frame(x=unique(type),y=main_accuracies),mapping=aes(x=x,y=y,fill="orange",color="orange"),binaxis='y',stackdir='center',dotsize=0.5) +
  scale_color_manual(values=c("red")) + 
  scale_fill_manual(values=c("red"))
