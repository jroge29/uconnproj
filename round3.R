library(readr)

library(dplyr)

jack <- read_csv("C:\\Users\\Jackrog\\Desktop\\ballinplay3.csv")

jack <- jack %>%
  group_by(game_play) %>%
  filter(run2b_field_x!=0)

undesired <- c("top_bottom_inning", "play_per_game", "team_fld")

jack <- jack %>%
  select(-one_of(undesired))

jack <- jack %>%
  group_by(game_play) %>%
  filter(run2b_field_y <= 58)

View(jack)

write.csv(jack,"C:\\Users\\Jackrog\\Desktop\\round3rd2.csv", row.names = FALSE)

jack <- jack %>% 
  group_by(game_play) %>% 
  filter(any(event_player == "C"))

View(jack)
