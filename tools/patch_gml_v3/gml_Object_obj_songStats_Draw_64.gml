draw_set_font(f_20);
draw_set_halign(fa_left);
draw_text(10, 110, "Score: " + string(global.total_score));
draw_text(10, 140, "Accuracy: " + string(floor((global.total_hit / global.total_notes) * 100)) + "%");
draw_text(10, 170, "Highest Combo: " + string(global.total_highest_combo));
draw_text(10, 200, "Total Missed: " + string(global.total_missed));
draw_text(10, 230, "Total Early: " + string(global.total_too_early + global.total_early));
draw_text(10, 260, "Total Perfect: " + string(global.total_perfect));
draw_text(10, 290, "Total Late: " + string(global.total_late + global.total_too_late));
