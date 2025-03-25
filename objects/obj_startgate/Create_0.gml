bg_surf = -1
image_speed = 0
depth = 20

bg_parallax = []

for (var i = 0; i < array_length(speed_array); i++) 
{
	var s = {
		spd: speed_array[i],
		x: 0
	}
	
    array_push(bg_parallax, s)
}

#region create masking effect

//i feel like drawing inside a create event might be bad, but it works
var s = surface_create(sprite_get_width(door_gate), sprite_get_height(door_gate))

surface_set_target(s)

draw_clear(c_white)

gpu_set_blendmode(bm_subtract)
draw_sprite(door_gate, 1, sprite_get_xoffset(door_gate), sprite_get_yoffset(door_gate)) // subtract the masking from the drawing 
gpu_set_blendmode(bm_normal)

surface_reset_target()

subtract_spr = sprite_create_from_surface(s, 0, 0, sprite_get_width(door_gate), sprite_get_height(door_gate), false, false, 0, 0)

surface_free(s)

#endregion

save_data = {
	score_num: 0,
	treasure: false,
	secret_count: 0,
	rank: 0
}

save_exists = false
spanwed_score = false

ini_open($"saves/saveData{global.savefile}.ini")

if ini_section_exists(level_name)
{
	show_debug_message("save exists!")
	save_exists = true
	save_data = {
		score_num: ini_read_real(level_name, "score", 0),
		treasure: ini_read_real(level_name, "treasure", false),
		secret_count: ini_read_real(level_name, "secret_count", 0),
		rank: ini_read_real(level_name, "rank", 0)
	}
}

ini_close()
