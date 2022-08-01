# -*- coding: utf-8 -*-
"""
Created on Tue Jul 26 15:39:54 2022

@author: jrbal
"""

import pandas as pd
from math import sqrt

def throw_distance(file_name):
    data = pd.read_csv(file_name, index_col = 0)
    data = data.dropna(subset = ['event_code'])
    new_data = [str(data['game_str'].iloc[i]) + ' ' + str(data['play_id'].iloc[i]) for i in range(len(data))]
    data['upid'] = new_data
    
    player_to_pos = {'1B': ('1b_field_x', '1b_field_y'),
                     '2B': ('2b_field_x', '2b_field_y'),
                     '3B': ('3b_field_x', '3b_field_y'),
                     'C': ('c_field_x', 'c_field_y'),
                     'CF': ('cf_field_x', 'cf_field_y'),
                     'LF': ('lf_field_x', 'lf_field_y'),
                     'P': ('p_field_x',
                            'p_field_y'),
                     'RF': ('rf_field_x', 'rf_field_y'),
                     'SS': ('ss_field_x', 'ss_field_y')}
    
    plays_with_throws = data[data['event_code'] == 'throw (ball-in-play, unknown field position)']
    
    plays_with_catches = data[(data['event_code'] == 'ball acquired') & (data['upid'].isin(plays_with_throws['upid']))]
    
    useful_plays = data[(data['event_code'] == 'throw (ball-in-play, unknown field position)') | ( 
                        (data['event_code'] == 'ball acquired') &
                        (data['upid'].isin(plays_with_throws['upid'])))]
    
    throw_dist_list = []
    for i in range(len(useful_plays)-1):
        thrower_row = useful_plays.iloc[i]
        throw_time = thrower_row['timestamp']
        thrower_id = thrower_row['event_player']
        thrower_tup = player_to_pos[str(thrower_id)]
        thrower_x = thrower_row[thrower_tup[0]]
        thrower_y = thrower_row[thrower_tup[1]]
        if useful_plays['event_code'].iloc[i + 1] == 'ball acquired':
            catcher_row = useful_plays.iloc[i + 1]
            catcher_time = catcher_row['timestamp']
            catcher_id = catcher_row['event_player']
            catcher_tup = player_to_pos[str(catcher_id)]
            catcher_x = catcher_row[catcher_tup[0]]
            catcher_y = catcher_row[catcher_tup[1]]
            a, b = (float(thrower_x) - float(catcher_x)), (float(thrower_y) - float(catcher_y))
            throw_dist = sqrt((a ** 2) + (b ** 2))
            throw_dist_list += [(thrower_row['upid'], thrower_id, catcher_id, throw_dist, throw_time, catcher_time)]
            
            
    
    df = pd.DataFrame(throw_dist_list, columns = ['Play', 'Fielder', 'Reciever', 'Throw Distance', 'Throw Time', 'Catch Time'])
    df2 = df.dropna(subset = ['Throw Distance'])
    df2.to_csv('throw_dist_' + file_name)
    

def dist_from_home(file_name):
    data = pd.read_csv(file_name, index_col = 0)
    new_data = [str(data['game_str'].iloc[i]) + ' ' + str(data['play_id'].iloc[i]) for i in range(len(data))]
    data['upid'] = new_data
    data = data.dropna(subset = ['ball_position_x', 'ball_position_y'])
    
    ball_dist_list = []
    for i in range(len(data)-1):
        ball_row = data.iloc[i]
        ball_time = ball_row['timestamp']
        ball_x = float(ball_row['ball_position_x'])
        ball_y = float(ball_row['ball_position_y'])
        dist_from_home = sqrt(ball_x ** 2 + ball_y ** 2)
        ball_dist_list += [(ball_row['upid'], ball_time, dist_from_home)]
        
    df = pd.DataFrame(ball_dist_list, columns = ['Play', 'Ball Time', 'Dist From Home'])
    df2 = df.dropna(subset = ['Dist From Home'])
    df2.to_csv('ball_dist_' + file_name)
    
        

    
    
        