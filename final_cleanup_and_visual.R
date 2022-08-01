library(readr)
library(dplyr)

jackson3 <- read_csv("C:\\Users\\Jackrog\\Desktop\\throw_dist_binary3.1.csv")
jackson2 <- read_csv("C:\\Users\\Jackrog\\Desktop\\throw_dist_binary2.1.csv")
isaac3 <- read_csv("C:\\Users\\Jackrog\\Desktop\\binary3.2.csv")
isaac2 <- read_csv("C:\\Users\\Jackrog\\Desktop\\binary2.2.csv")


View(isaac2)
View(isaac3)

binary2.4 <- isaac2 %>%
  mutate(momentumx = (lag(current_fielder_pos_x,3))-current_fielder_pos_x)


binary2.4 <- binary2.4 %>%
  mutate(momentumy = (lag(current_fielder_pos_y,3))-current_fielder_pos_y)


binary3.4 <- isaac3 %>%
  mutate(momentumx = (lag(current_fielder_pos_x,3))-current_fielder_pos_x)


binary3.4 <- binary3.4 %>%
  mutate(momentumy = (lag(current_fielder_pos_y,3))-current_fielder_pos_y)

test_set <- binary2.4%>%
  group_by(game_play)%>%
  mutate(binary2 = ifelse(any((ball_position_y < 10 & ball_position_y > -10)&(run3b_field_y<=10)), 1, 0))

View(test_set)



test_set[["binary2"]][is.na(test_set[["binary2"]])] <- 0

binary2.5 <- test_set %>%
  filter(run2b_field_y > 62 & run2b_field_y < 63)

View(binary2.5)

test_set3 <- binary3.4%>%
  group_by(game_play)%>%
  mutate(binary2 = ifelse(any((ball_position_y < 10 & ball_position_y > -10)&(run3b_field_y<=10)), 1, 0))

test_set3[["binary2"]][is.na(test_set3[["binary2"]])] <- 0

binary3.5 <- test_set3 %>%
  filter(ball_height == "fielder has it" & run3b_field_y >62)
View(binary3.5)


write.csv(binary2.5,"C:\\Users\\Jackrog\\Desktop\\final_decision_point.csv", row.names = FALSE)

library(tidyverse)
library(ggplot2)

ggplot(binary2.5, aes(ball_position_x, ball_position_y, col=binary2, size = momentumy, scale="globalminmax") +
  geom_vline(xintercept = 0, linetype = 2) +
  geom_hline(yintercept = 0, linetype = 2) +
  geom_point() +
  theme_minimal()


