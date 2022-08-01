library(readr)
library(dplyr)

isaac2 <- read_csv("C:\\Users\\Jackrog\\Desktop\\isaac2round.csv")
jackson2 <- read_csv("C:\\Users\\Jackrog\\Desktop\\jacksonround.csv")
isaac3 <- read_csv("C:\\Users\\Jackrog\\Desktop\\isaac23.csv")
jackson3 <- read_csv("C:\\Users\\Jackrog\\Desktop\\jackson3.csv")
jack <- read_csv("C:\\Users\\Jackrog\\Desktop\\ballinplay3.csv")
View(jack)
View(isaac2)
View(isaac3)
View(jackson2)
View(jackson3)


join2 <- merge(x = isaac2, y = jackson2, by = 'Play', all.x = TRUE)
join3 <- merge(x = isaac2, y = jackson2, by = 'Play', all.x = TRUE)
View(join2)

join2 <- join2 %>%
  mutate(binary = case_when(
    (run2b_field_y < 5) ~ 0,
    (ball_position_y < 5)  ~ 1
  ))
View(join2)
join3 <- join3 %>%
  mutate(binary = case_when(
    (run3b_field_y < 5) ~ 0,
    (ball_position_y < 5)  ~ 1
  )) 
View(join3)

jack3 <- jack %>%
  group_by("game_play") %>%
  filter(run3b_field_x!=0)

jack3 <- jack3 %>%
  filter(any(run3b_field_y<=5))

View(jack3)
binaryjack <- jack3 %>%
  mutate(binary = if_else((ball_position_y < 5 & ball_position_y > -5)&(run3b_field_y<=5), 1, 0))
View(binaryjack)

jack2 <- jack %>%
  group_by("game_play")

jack2 <- jack2 %>%
  group_by(game_play) %>%
  filter(any(run2b_field_y!=0))

jack2 <- jack2 %>%
  group_by(game_play) %>%
  filter(any(run2b_field_y<=5))

View(jack2)

binaryjack2 <- jack2 %>%
  mutate(binary = if_else((ball_position_y < 5 & ball_position_y > -5)&(run2b_field_y<=5), 1, 0))
View(binaryjack2)

binaryJI2 = merge(x=binaryjack2, y = isaac2, by = "game_play", all.x=TRUE)
View(binaryJI2)
