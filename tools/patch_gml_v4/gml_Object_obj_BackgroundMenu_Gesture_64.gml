var _x = ds_map_find_value(event_data, "posX");
var _y = ds_map_find_value(event_data, "posY");
if (point_in_rectangle(_x, _y, (room_width / 2) - ((sprite_get_width(spr_MenuTapTap) - 42) / 2), _y, (room_width / 2) + ((sprite_get_width(spr_MenuTapTap) - 24) / 2), sprite_get_height(spr_MenuTapTap) - 25))
{
    if (instance_exists(obj_AccountMenu))
    {
        instance_activate_object(obj_MainMenu);
        instance_destroy(obj_AccountMenu);
        with (obj_TextField)
        {
            instance_destroy();
        }
    }
    if (instance_exists(obj_SongStatsMenu))
    {
        room_goto(rm_MainMenu);
    }
    if (room == rm_songStats)
    {
        room_goto(rm_MainMenu);
    }
    with (obj_MainMenu)
    {
        if (room == rm_songStats)
        {
            room_goto(rm_MainMenu);
        }
        else if (current_menu != home_menu)
        {
            if (chosen_option == "Options")
            {
                ini_open(options_file_path);
                ini_write_real("options", "spawn_arrows", can_spawn_arrows);
                ini_write_real("options", "miss_sound", miss_sound);
                ini_write_real("options", "no_fail", no_fail);
                ini_close();
            }
            current_menu = home_menu;
            menu_nav = [home_menu];
            menu_index = 0;
            chosen_option = "";
            menu_item_surface_current_y = menu_item_surface_start_y;
            if (ds_exists(song_list, ds_type_list))
            {
            }
            event_user(0);
        }
    }
}
if (point_in_rectangle(_x, _y, menu_backbutton_starting_x, menu_backbutton_starting_y, menu_backbutton_starting_x + menu_backbutton_width, menu_backbutton_starting_y + menu_backbutton_height))
{
    if (room == rm_songStats)
    {
        exit;
    }
    if (instance_exists(obj_AccountMenu))
    {
        instance_activate_object(obj_MainMenu);
        instance_destroy(obj_AccountMenu);
        with (obj_TextField)
        {
            instance_destroy();
        }
    }
    else
    {
        with (obj_MainMenu)
        {
            if (room == rm_songStats)
            {
                instance_activate_object(obj_SongStatsMenu);
                instance_destroy();
            }
            else if (current_menu != home_menu)
            {
                if (chosen_option == "Options")
                {
                    ini_open(options_file_path);
                    ini_write_real("options", "spawn_arrows", can_spawn_arrows);
                    ini_write_real("options", "miss_sound", miss_sound);
                ini_write_real("options", "no_fail", no_fail);
                    ini_close();
                }
                current_menu = menu_nav[--menu_index];
                chosen_option = "";
                menu_item_surface_current_y = menu_item_surface_start_y;
                if (ds_exists(song_list, ds_type_list))
                {
                }
                event_user(0);
            }
        }
    }
}
else if (point_in_rectangle(_x, _y, menu_homebutton_starting_x, menu_homebutton_starting_y, menu_homebutton_starting_x + menu_homebutton_width, menu_homebutton_starting_y + menu_homebutton_height))
{
    if (instance_exists(obj_AccountMenu))
    {
        instance_activate_object(obj_MainMenu);
        instance_destroy(obj_AccountMenu);
        with (obj_TextField)
        {
            instance_destroy();
        }
    }
    if (instance_exists(obj_SongStatsMenu))
    {
        room_goto(rm_MainMenu);
    }
    if (room == rm_songStats)
    {
        room_goto(rm_MainMenu);
    }
    with (obj_MainMenu)
    {
        if (room == rm_songStats)
        {
            room_goto(rm_MainMenu);
        }
        else if (current_menu != home_menu)
        {
            if (chosen_option == "Options")
            {
                ini_open(options_file_path);
                ini_write_real("options", "spawn_arrows", can_spawn_arrows);
                ini_write_real("options", "miss_sound", miss_sound);
                ini_write_real("options", "no_fail", no_fail);
                ini_close();
            }
            current_menu = home_menu;
            menu_nav = [home_menu];
            menu_index = 0;
            chosen_option = "";
            menu_item_surface_current_y = menu_item_surface_start_y;
            if (ds_exists(song_list, ds_type_list))
            {
            }
            event_user(0);
        }
    }
}
