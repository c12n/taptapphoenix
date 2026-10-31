var _x = ds_map_find_value(event_data, "posX");
var _y = ds_map_find_value(event_data, "posY");
var difficulty;
if (!ds_exists(song_list, ds_type_list))
{
    if (point_in_rectangle(_x, _y, menu_item_starting_x, menu_item_starting_y, menu_item_width, menu_item_starting_y + (menu_item_height * array_length(current_menu))))
    {
        var _index = (_y - menu_item_starting_y) div menu_item_height;
        show_debug_message(_index);
        if (_index >= 0 && _index < array_length(current_menu))
        {
            if (current_menu[_index][0] == "Register Your Score")
            {
                if (global.account_key != "" && registering_score == 0)
                {
                    if (global.no_fail_run)
                    {
                        show_message_async("No Fail mode was on for that run, so the score is not registered. Turn No Fail off in Options to submit scores.");
                        exit;
                    }
                    registering_score = 1;
                    var _validity_key = string(sha1_string_utf8(md5_string_utf8(string(global.account_key)) + sha1_string_utf8(string(global.total_score)) + md5_string_utf8(string(global.curr_song_artist)) + sha1_string_utf8(string(global.curr_song_title))));
                    post = http_post_string("https://ttp.07051969.xyz/update_leaderboard.php?auth=" + string(global.tap_phoenix_key), "&userkey=" + string(global.account_key) + "&validitykey=" + string(_validity_key) + "&score=" + string(global.total_score) + "&artist=" + string(global.curr_song_artist) + "&song=" + string(global.curr_song_title) + "&difficulty=" + string(global.curr_song_difficulty));
                }
                else
                {
                    show_message_async("No account found!");
                    account_question = show_question_async("Would you like to create an account or login?");
                }
            }
            else if (current_menu[_index][0] == "Next Song")
            {
                difficulty = "";
                var allSongs = variable_struct_get_names(global.songs);
                var list = ds_list_create();
                for (var i = 0; i < array_length(allSongs); i++)
                {
                    var _trackInfo = variable_struct_get(global.songs, allSongs[i]);
                    switch (global.curr_song_difficulty)
                    {
                        case "easy":
                            if (_trackInfo[0][0] == 1)
                            {
                                ds_list_add(list, _trackInfo);
                            }
                            break;
                        case "medium":
                            if (_trackInfo[0][1] == 1)
                            {
                                ds_list_add(list, _trackInfo);
                            }
                            break;
                        case "hard":
                            if (_trackInfo[0][2] == 1)
                            {
                                ds_list_add(list, _trackInfo);
                            }
                            break;
                        case "extreme":
                            if (_trackInfo[0][3] == 1)
                            {
                                ds_list_add(list, _trackInfo);
                            }
                            break;
                    }
                }
                song_list_sort(list);
                for (var i = 0; i < ds_list_size(list); i++)
                {
                    if (array_get(array_get(ds_list_find_value(list, i), 0), 5) == global.curr_song_title)
                    {
                        if ((i + 1) < ds_list_size(list))
                        {
                            curr_song = ds_list_find_value(list, i + 1);
                        }
                        else
                        {
                            curr_song = ds_list_find_value(list, 0);
                        }
                        global.curr_song_title = curr_song[0][5];
                        global.curr_song_artist = curr_song[0][4];
                        curr_song[0] = global.curr_song_difficulty;
                        global.selected_song = curr_song;
                        show_debug_message(global.selected_song);
                        ds_list_destroy(list);
                        room_goto(Room1);
                        break;
                    }
                }
            }
            event_user(0);
        }
    }
}
else if (point_in_rectangle(_x, _y, menu_item_starting_x, menu_item_starting_y, menu_item_starting_x + menu_item_width, menu_item_starting_y + (menu_item_height * ds_list_size(song_list))))
{
    var _index = (_y - menu_item_surface_current_y - menu_item_starting_y) div menu_item_height;
    if (_index >= 0 && _index < ds_list_size(song_list))
    {
        curr_song = ds_list_find_value(song_list, _index);
        global.curr_song_title = curr_song[0][5];
        global.curr_song_artist = curr_song[0][4];
        curr_song[0] = difficulty;
        global.selected_song = curr_song;
        room_goto(Room1);
    }
}
