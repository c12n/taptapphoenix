var _x = ds_map_find_value(event_data, "posX");
var _y = ds_map_find_value(event_data, "posY");
if (instance_exists(obj_Credits))
{
    instance_destroy(obj_Credits);
    exit;
}
if (!ds_exists(song_list, ds_type_list))
{
    if (point_in_rectangle(_x, _y, menu_item_starting_x, menu_item_starting_y, menu_item_width, menu_item_starting_y + (menu_item_height * array_length(current_menu))))
    {
        var _index = (_y - menu_item_starting_y) div menu_item_height;
        show_debug_message(_index);
        if (_index >= 0 && _index < array_length(current_menu))
        {
            if (chosen_option != "Options")
            {
                if (current_menu[_index][0] == "Credits")
                {
                    instance_create_depth(room_width / 2, room_height / 2, -1000, obj_Credits);
                }
                else
                {
                    chosen_option = current_menu[_index][0];
                    current_menu = current_menu[_index][1];
                    menu_nav[++menu_index] = current_menu;
                }
            }
            else if (current_menu[_index][0] == "Arrows:")
            {
                can_spawn_arrows = !can_spawn_arrows;
            }
            else if (current_menu[_index][0] == "Miss Sound:")
            {
                miss_sound = !miss_sound;
            }
            else if (current_menu[_index][0] == "No Fail:")
            {
                no_fail = !no_fail;
            }
            else if (current_menu[_index][0] == "Create Account")
            {
                var _account_menu = instance_create_layer(0, 0, "Instances", obj_AccountMenu);
                _account_menu.is_creating_account = 1;
                instance_deactivate_object(self);
            }
            else if (current_menu[_index][0] == "Login")
            {
                var _account_menu = instance_create_layer(0, 0, "Instances", obj_AccountMenu);
                _account_menu.is_creating_account = 0;
                instance_deactivate_object(self);
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
        global.curr_song_difficulty = difficulty;
        curr_song[0] = difficulty;
        global.selected_song = curr_song;
        show_debug_message(global.selected_song);
        room_goto(Room1);
    }
}
