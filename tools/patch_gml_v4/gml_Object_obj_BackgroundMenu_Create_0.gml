randomize();
if (room == rm_MainMenu)
{
    instance_create_layer(0, 0 + global.notch_padding, "Instances", obj_MainMenu);
}
else if (room == rm_songStats)
{
    instance_create_layer(0, 0 + global.notch_padding, "Instances", obj_SongStatsMenu);
}
is_ios = os_type == os_ios;
options_file_path = is_ios ? "datafiles/phoenixoptions.ini" : "phoenixoptions.ini";
if (!file_exists(options_file_path))
{
    ini_open(options_file_path);
    ini_write_real("options", "spawn_arrows", 1);
    ini_write_real("options", "miss_sound", 1);
    ini_write_real("options", "no_fail", 0);
    ini_close();
}
menu_backbutton_starting_x = 44;
menu_backbutton_starting_y = 153 + global.notch_padding;
menu_backbutton_width = sprite_get_width(spr_MenuBack) * 2;
menu_backbutton_height = sprite_get_height(spr_MenuBack) * 2;
menu_homebutton_starting_x = 492;
menu_homebutton_starting_y = 153 + global.notch_padding;
menu_homebutton_width = sprite_get_width(spr_MenuHome) * 2;
menu_homebutton_height = sprite_get_height(spr_MenuHome) * 2;
alarm[0] = irandom_range(3, 8) * room_speed;
