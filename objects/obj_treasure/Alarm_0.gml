obj_player.state = states.normal
global.score += 1000
with instance_create(x, y, obj_collect_number)
	num = 1000
global.level_data.treasure = true

if obj_music.mu != noone
	audio_sound_gain(obj_music.mu, 1, 250)
	
instance_destroy()