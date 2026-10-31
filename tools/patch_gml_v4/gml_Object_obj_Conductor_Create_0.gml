notes = [];
playing = 0;
can_create = 1;
difficulty = global.selected_song[UnknownEnum.Value_0];
multiplier = 1;
curScore = 0;
cur_note = 0;
combo = 0;
revenge_available = 0;
is_ios = os_type == os_ios;
show_score_or_miss = curScore;
can_spawn_arrows = 1;
options_file_path = is_ios ? "datafiles/phoenixoptions.ini" : "phoenixoptions.ini";
ini_open(options_file_path);
can_spawn_arrows = ini_read_real("options", "spawn_arrows", 1);
play_miss_sound = ini_read_real("options", "miss_sound", 1);
no_fail_mode = ini_read_real("options", "no_fail", 0);
global.no_fail_run = no_fail_mode;
ini_close();
pause_object = -4;
start_background_id = layer_background_get_id(layer_get_id("background_start"));
start_background_fade = 0;
start_background_opacity = 1;
start_background_fade_finished = 0;
cur_tilt_x = 0;
cur_tilt_y = 0;
cur_tilt_z = 0;
start_tilt_z = device_get_tilt_z();
shake_count = 0;
possible_shake = 0;
with (obj_scoreController)
{
    event_user(0);
}
show_debug_message(string_replace(global.selected_song[UnknownEnum.Value_2], "_", difficulty));
var noteIndex = 0;
var _file_name = (is_ios ? "datafiles/" : "") + string_replace(global.selected_song[UnknownEnum.Value_2], "_", difficulty);
var songInfo = file_text_open_read(_file_name);
file_text_readln(songInfo);
file_text_readln(songInfo);
file_text_readln(songInfo);
while (!file_text_eof(songInfo))
{
    notes[noteIndex] = string_explode(file_text_read_string(songInfo));
    notes[noteIndex][UnknownEnum.Value_0] = real(notes[noteIndex][UnknownEnum.Value_0]);
    notes[noteIndex][UnknownEnum.Value_1] = real(notes[noteIndex][UnknownEnum.Value_1]);
    notes[noteIndex][UnknownEnum.Value_2] = real(notes[noteIndex][UnknownEnum.Value_2]);
    if (can_spawn_arrows)
    {
        notes[noteIndex][UnknownEnum.Value_3] = real(notes[noteIndex][UnknownEnum.Value_3]);
    }
    else
    {
        notes[noteIndex][UnknownEnum.Value_3] = 0;
    }
    noteIndex++;
    file_text_readln(songInfo);
}
file_text_close(songInfo);
song = audio_play_sound(global.selected_song[UnknownEnum.Value_1], 1, false);
global.total_notes = array_length(notes);
show_debug_message(array_length(notes));
if ((display_get_height() / display_get_width()) > 2)
{
    var _album = instance_create_layer(room_width / 2, 288, "Instances", obj_AlbumCover);
    _album.image_index = global.selected_song[UnknownEnum.Value_3];
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2,
    Value_3
}
