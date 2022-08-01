library(readr)

library(dplyr)

jack <- read_csv("C:\\Users\\Jackrog\\Desktop\\ballinplay3.csv")
isaac <- read_csv("C:\\Users\\Jackrog\\Desktop\\fielder_distance_from_ball.csv")
jackson <- read_csv("C:\\Users\\Jackrog\\Desktop\\throw_distance_by_play.csv")

isaac <- isaac %>%
  select("game_play", "what_to_track", "catch", "ball_height", "next_ball_position_x", "next_ball_position_y", "next_ball_position_z", "fielder_col_name_x", "fielder_col_name_y", "current_fielder_pos_x", "current_fielder_pos_y", "fielder_dist_from_ball")

View(jack)

jack <- jack %>%
  group_by(game_play) %>%
  filter(run3b_field_x!=0)

View(jack)


undesired <- c("top_bottom_inning", "play_per_game", "team_fld")

jack <- jack %>%
  select(-one_of(undesired))

jack <- jack %>% 
  group_by(game_play) %>% 
  filter(any(ball_position_z >= 20))

jack <- jack %>% 
  group_by(game_play) %>% 
  filter(any(ball_position_y >= 100))

View(jack)
write.csv(jack,"C:\\Users\\Jackrog\\Desktop\\3flyball.csv", row.names = FALSE)

jack <- jack %>% 
  group_by(game_play) %>% 
  filter(any(event_player == "C"))

View(jack)

