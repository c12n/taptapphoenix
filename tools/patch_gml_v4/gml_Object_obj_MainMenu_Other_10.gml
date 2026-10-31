event_user(1);
if (!ds_exists(song_list, ds_type_list))
{
    menu_item_count = array_length(current_menu);
}
else
{
    menu_item_count = ds_list_size(song_list);
}
menu_item_surface_height = menu_item_count * menu_item_height;
menu_item_surface_min_y = menu_item_surface_start_y - ((menu_item_count * menu_item_height) - (room_height - menu_item_starting_y)) - 16;
menu_item_surface_max_y = menu_item_surface_start_y;
if (!surface_exists(main_surface))
{
    main_surface = surface_create(menu_item_width, room_height - menu_item_starting_y);
}
if (surface_exists(menu_item_surface))
{
    surface_free(menu_item_surface);
}
menu_item_surface = surface_create(menu_item_width, menu_item_surface_height);
surface_set_target(menu_item_surface);
draw_clear_alpha(c_black, 0);
draw_set_alpha(1);
var _menu_item_height = sprite_get_height(spr_MenuItem);
if (!ds_exists(song_list, ds_type_list))
{
    for (var i = 0; i < array_length(current_menu); i++)
    {
        var _y = i * _menu_item_height;
        draw_set_alpha(button_opacity);
        draw_sprite(spr_MenuItem, 0, 0, _y);
        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_set_font(f_33);
        draw_text(37, _y + 24, current_menu[i][0]);
        if (current_menu[i][0] == "Arrows:")
        {
            draw_set_color(can_spawn_arrows ? c_lime : c_red);
            draw_text(37 + string_width(current_menu[i][0]), _y + 25, (can_spawn_arrows == 1) ? " ON" : " OFF");
        }
        if (current_menu[i][0] == "Miss Sound:")
        {
            draw_set_color(miss_sound ? c_lime : c_red);
            draw_text(37 + string_width(current_menu[i][0]), _y + 25, (miss_sound == 1) ? " ON" : " OFF");
        }
        if (current_menu[i][0] == "No Fail:")
        {
            draw_set_color(no_fail ? c_lime : c_red);
            draw_text(37 + string_width(current_menu[i][0]), _y + 25, (no_fail == 1) ? " ON" : " OFF");
        }
    }
}
else
{
    var _lengths = ["1:57", "2:23", "1:58", "1:55", "1:55", "3:44", "1:30", "", "3:08", "2:04", "1:42", "3:28", "2:32", "1:52", "2:58", "1:56", "3:35", "2:16", "1:54", "4:16", "3:22", "3:00", "1:48", "2:49", "1:51"];
    for (var i = 0; i < ds_list_size(song_list); i++)
    {
        var _y = i * _menu_item_height;
        var _entry = ds_list_find_value(song_list, i);
        draw_set_alpha(button_opacity);
        draw_sprite(spr_MenuItem, 0, 0, _y);
        draw_set_alpha(1);
        draw_set_font(f_33);
        draw_text(37, _y + 8, array_get(array_get(_entry, 0), 5));
        draw_set_color(c_white);
        draw_set_halign(fa_right);
        draw_text(menu_item_width - 37, _y + 8, _lengths[array_get(_entry, 1)]);
        draw_set_halign(fa_left);
        draw_set_font(f_20);
        draw_text(41, _y + 53, array_get(array_get(_entry, 0), 4));
    }
}
surface_reset_target();
surface_set_target(main_surface);
draw_clear_alpha(c_white, 0);
draw_surface(menu_item_surface, 0, menu_item_surface_current_y);
surface_reset_target();
