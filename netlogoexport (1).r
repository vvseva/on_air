library(readr)
data <- read_csv("~/model building/Spread of Disease population-density-table.csv", 
              
                                                         skip = 6)
head(data)

data <- as.data.frame(data)

library(dplyr)

data_agg <- data %>% group_by(`num-people`) %>% summarise(mean = mean(`ticks`), sd = sd(`ticks`))
data_agg


data <- data %>% select("num-people", "ticks")
names(data) <- c("num", "ticks")

ggplot(data = data, aes(group = num, y = ticks))+
  geom_boxplot()


data_2 <- read_csv("~/model building/Spread of Disease population-density-2-table.csv", 
                                                         skip = 6)

names(data_2) <- c("run", "var", "c", "nump", "numi", "dd", "step", "infected")
data_2_agg <- data_2 %>% group_by(`num-people`, `[step]`) %>% summarise(mean = mean(`count turtles with [ infected? ]`), sd = sd(`count turtles with [ infected? ]`))

data_2_agg <- as.data.frame(data_2_agg)
head(data_2_agg)

data_2_agg[is.na(data_2_agg)] <- 0

ggplot(data_2_agg, aes(x = `[step]`, y= mean, group = `num-people`, color = `num-people`)) + 
  geom_line() + geom_point() + 
  geom_errorbar(aes(ymin = mean - sd, ymax= mean + sd), 
                width=.2, position=position_dodge(0.05))


data_3 <- read_csv("~/model building/Spread of Disease degree 2-table.csv", 
                                             skip = 6)

data_3_agg <- data_3 %>% group_by(`num-people`, `connections-per-node`) %>% summarise(mean = mean(`num-infected`))


m1 <- glm(`num-infected` ~ `num-people`+ `connections-per-node`, data = data_3)
summary(m1)
