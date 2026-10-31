var col = make_color_rgb(251, 225, 145);
draw_set_color(col);
draw_set_font(f_20);
draw_set_halign(fa_left);
var _y = 10;
var _adjust_y = 1;
if ((display_get_height() / display_get_width()) < 2)
{
    _adjust_y = 0;
}
if (_adjust_y)
{
    _y = 100;
}
if (start_background_fade_finished == 1)
{
    draw_text(15, _y, string(multiplier) + "x");
    draw_set_halign(fa_right);
    draw_text(room_width - 15, _y, string(combo));
    draw_set_font(f_33);
    draw_set_halign(fa_center);
    if (show_score_or_miss != "MISS!")
    {
        draw_text(room_width / 2, _y, add_comma(show_score_or_miss, 3));
    }
    else
    {
        draw_text(room_width / 2, _y, string(show_score_or_miss));
    }
    if (array_length(notes) > 0)
    {
        var _total_time = notes[array_length(notes) - 1][2];
        var _frac = clamp(audio_sound_get_track_position(song) / _total_time, 0, 1);
        draw_set_alpha(0.35);
        draw_set_color(c_black);
        draw_rectangle(15, _y + 56, room_width - 15, _y + 62, false);
        draw_set_alpha(1);
        draw_set_color(col);
        if (_frac > 0)
        {
            draw_rectangle(15, _y + 56, 15 + ((room_width - 30) * _frac), _y + 62, false);
        }
    }
}
