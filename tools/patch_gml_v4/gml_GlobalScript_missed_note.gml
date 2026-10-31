function missed_note()
{
    if (obj_Conductor.no_fail_mode)
    {
        obj_Conductor.show_score_or_miss = "MISS!";
        exit;
    }
    if (obj_Conductor.multiplier == 8)
    {
        obj_Camera.shake = 1;
        set_bg("main");
        with (obj_note)
        {
            image_index = original_index;
        }
    }
    if (global.total_current_combo > global.total_highest_combo)
    {
        global.total_highest_combo = global.total_current_combo;
        global.total_current_combo = 0;
    }
    obj_Conductor.combo = 0;
    obj_Conductor.multiplier = 1;
    obj_Conductor.show_score_or_miss = "MISS!";
    global.total_missed++;
}
