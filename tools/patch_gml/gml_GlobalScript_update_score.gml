function update_score(arg0)
{
    var song_time = audio_sound_get_track_position(obj_Conductor.song);
    var notified = 0;
    obj_Conductor.combo += 1;
    global.total_hit++;
    global.total_current_combo++;
    switch (obj_Conductor.combo)
    {
        case 20:
            obj_Conductor.multiplier = 2;
            if (notified == 0)
            {
                instance_create_layer(room_width / 2, camera_get_view_height(view_camera[global.current_view]) / 2, "Notifications", obj_multiplierNotification);
                notified = 1;
            }
            break;
        case 30:
            obj_Conductor.multiplier = 3;
            if (notified == 0)
            {
                instance_create_layer(room_width / 2, camera_get_view_height(view_camera[global.current_view]) / 2, "Notifications", obj_multiplierNotification);
                notified = 1;
            }
            break;
        case 40:
            obj_Conductor.multiplier = 4;
            if (notified == 0)
            {
                instance_create_layer(room_width / 2, camera_get_view_height(view_camera[global.current_view]) / 2, "Notifications", obj_multiplierNotification);
                notified = 1;
            }
            break;
        case 50:
            if (notified == 0)
            {
                obj_Conductor.revenge_available = 1;
                instance_create_layer(room_width / 2, camera_get_view_height(view_camera[global.current_view]) / 2, "Notifications", obj_multiplierNotification);
                notified = 1;
            }
            break;
        default:
            obj_Conductor.multiplier = obj_Conductor.multiplier;
    }
    var timing_score;
    if (song_time > (arg0.note_time - 0.09) && song_time < (arg0.note_time + 0.09))
    {
        obj_lightBar.fade_dir = "in";
        if (obj_lightBar.fade_amount > 0)
        {
            obj_lightBar.fade_amount += (1 - obj_lightBar.fade_amount);
        }
        else
        {
            obj_lightBar.fade_amount = 1;
        }
        timing_score = 150;
        global.total_perfect++;
    }
    else if (song_time > (arg0.note_time - 0.15) && song_time < (arg0.note_time + 0.15))
    {
        obj_lightBar.fade_dir = "in";
        if (obj_lightBar.fade_amount > 0)
        {
            obj_lightBar.fade_amount += (0.9 - obj_lightBar.fade_amount);
        }
        else
        {
            obj_lightBar.fade_amount = 0.9;
        }
        timing_score = 75;
        global.total_early++;
    }
    else if (song_time > (arg0.note_time - 1.02) && song_time < (arg0.note_time + 1.02))
    {
        obj_lightBar.fade_dir = "in";
        if (obj_lightBar.fade_amount > 0)
        {
            obj_lightBar.fade_amount += (0.8 - obj_lightBar.fade_amount);
        }
        else
        {
            obj_lightBar.fade_amount = 0.8;
        }
        timing_score = 50;
        global.total_too_early++;
    }
    else
    {
        obj_lightBar.fade_dir = "in";
        if (obj_lightBar.fade_amount > 0)
        {
            obj_lightBar.fade_amount += (0.7 - obj_lightBar.fade_amount);
        }
        else
        {
            obj_lightBar.fade_amount = 0.7;
        }
        timing_score = 25;
        global.total_too_late++;
    }
    show_debug_message("Song time: " + string(song_time));
    show_debug_message("Note time: " + string(arg0.note_time));
    show_debug_message("Base score: " + string(timing_score));
    show_debug_message("Calculated score: " + string(timing_score * obj_Conductor.multiplier));
    obj_Conductor.curScore += (timing_score * obj_Conductor.multiplier);
    instance_destroy(arg0);
}
