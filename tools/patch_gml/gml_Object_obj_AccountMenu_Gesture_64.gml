var _x = ds_map_find_value(event_data, "posX");
var _y = ds_map_find_value(event_data, "posY");
if (keyboard_virtual_status())
{
    keyboard_virtual_hide();
}
with (obj_TextField)
{
    is_active = 0;
    keyboard_string = "";
}
if (point_in_rectangle(_x, _y, menu_item_starting_x, menu_item_starting_y, menu_item_width, menu_item_starting_y + (menu_item_height * array_length(current_menu))))
{
    var _index = (_y - menu_item_starting_y) div menu_item_height;
    if (_index >= 0 && _index < array_length(current_menu))
    {
        var _keyboard_type = 1;
        var _keyboard_return_type = 0;
        switch (current_menu[_index][0])
        {
            case "Email:":
                email_field.is_active = 1;
                if (!keyboard_virtual_status())
                {
                    keyboard_virtual_show(_keyboard_type, _keyboard_return_type, 0, 0);
                }
                else
                {
                    keyboard_string = "";
                    keyboard_virtual_hide();
                }
                break;
            case "Username:":
                username_field.is_active = 1;
                if (!keyboard_virtual_status())
                {
                    keyboard_virtual_show(_keyboard_type, _keyboard_return_type, 0, 0);
                }
                else
                {
                    keyboard_string = "";
                    keyboard_virtual_hide();
                }
                break;
            case "Password:":
                password_field.is_active = 1;
                if (!keyboard_virtual_status())
                {
                    keyboard_virtual_show(_keyboard_type, _keyboard_return_type, 0, 0);
                }
                else
                {
                    keyboard_string = "";
                    keyboard_virtual_hide();
                }
                break;
            case "Submit":
                post = http_post_string("https://ttp.07051969.xyz/new_user.php?auth=" + global.tap_phoenix_key, "&user=" + username_field.text + "&email=" + email_field.text + "&pass=" + string(sha1_string_utf8(password_field.text)));
                if (keyboard_virtual_status())
                {
                    keyboard_virtual_hide();
                }
                break;
            case "Login":
                post = http_post_string("https://ttp.07051969.xyz/user_login.php?auth=" + global.tap_phoenix_key, "&user=" + username_field.text + "&pass=" + string(sha1_string_utf8(password_field.text)));
                if (keyboard_virtual_status())
                {
                    keyboard_virtual_hide();
                }
                break;
        }
        event_user(0);
    }
}
