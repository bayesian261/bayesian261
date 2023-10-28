dtf<-matrix(c(16,28,9,37),2,2,byrow=T)
rownames(dtf)<-c("A","B")
colnames(dtf)<-c("Improve","Not improve")

testdf<-chisq.test(as.table(dtf),correct = F)
testdf
cust_stat <- credit %>% group_by(Gender) %>% summarise(num_customers = n(), mean_crScore = round(mean(CreditScore),2), mean_age = round(mean(Age),2), mean_tenure = round(mean(Tenure),2), mean_balance = round(mean(Balance),2), mean_salary = round(mean(EstimatedSalary),2))

formattable(cust_stat, 
            align =c("l","c","c","c","c","c","c"), 
            list(`Indicator Name` = formatter(
              "span", style = ~ style(color = "grey",font.weight = "bold"))))


ggplot(credit,aes(x = Geography, group = Gender)) + 
  geom_bar(aes(y = ..prop.., fill = factor(..x..)), 
           stat="count", color = "black", alpha = 0.7) +
  geom_text(aes(label = scales::percent(..prop..),
                y= ..prop.. ), stat= "count", position = position_stack(vjust = 0.5), size = 4.5) +
  facet_grid(~Gender) +
  scale_y_continuous(labels = scales::percent)+
  guides(fill = F)+
  labs(title = "Gender and geographical composition
         ", 
       x = "", y = "Percentage")+
  theme_minimal()+
  scale_fill_brewer(palette="Set2")+
  theme(text = element_text(size = 12), 
        plot.title = element_text(hjust = 0.5), title = element_text(size = 12))


salary = credit %>% group_by(Gender, Geography) %>% summarise(mean_sal = round(mean(EstimatedSalary),2))


ggplot(salary,aes(x = Gender, y = mean_sal, fill = Gender)) + 
  geom_bar(stat = "identity",color = "black", alpha = 0.7) +
  geom_text(aes(label = mean_sal, vjust = -.5), size = 4)+
  facet_grid(~ Geography) +
  labs(title = "Gender and geographical composition of salaries
         ", 
       x = "", y = "Mean salery")+
  theme_minimal()+
  coord_cartesian(ylim=c(95000,103000))+
  scale_y_continuous(breaks = seq(95000,103000, 1000))+
  guides(fill = F)+
  theme(text = element_text(size = 12), 
        plot.title = element_text(hjust = 0.5), title = element_text(size = 12))
