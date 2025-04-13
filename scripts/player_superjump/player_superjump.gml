function player_superjump() 
{
	hsp = xscale * movespeed
	image_speed = 0.35
	
	if (sprite_index == spr_player_superjumpprep || sprite_index == spr_player_superjumpflash)
		movespeed = approach(movespeed, 0, 1)
		
	if (sprite_index == spr_player_superjumpprep)
		reset_anim_on_end(spr_player_superjumpflash)
		
	if (sprite_index == spr_player_Sjumpcancelstart)
	{
		image_speed = 0.5
		vsp = 0
		if (p_move != 0)
		  xscale = p_move
	}
	
	if ((key_up.down || !grounded) && (sprite_index == spr_player_superjumpflash || sprite_index == spr_player_superjumpmove))
	{
		var absMove = abs(p_move);
		movespeed = (!scr_solid(x + xscale, y) || place_meeting(x + xscale, y, obj_slope)) ? absMove * 2 : 0;

		if absMove
		{
			xscale = p_move
			sprite_index = spr_player_superjumpmove
		}
		else
			sprite_index = spr_player_superjumpflash
	}
	
	if (anim_ended() && sprite_index == spr_player_Sjumpcancelstart)
	{
		state = states.mach3
		sprite_index = spr_player_Sjumpcancel
		jumpstop = true
		vsp = -4
		flash = 8
		movespeed = 13
		image_speed = 0.35
		with particle_create(x, y, particles.genericpoof, xscale, 1, spr_crazyruneffect)
			depth = -150
	}
	
	if (sprite_index != spr_player_superjump && sprite_index != spr_player_Sjumpcancel && sprite_index != spr_player_Sjumpcancelstart && sprite_index != spr_player_superjumpprep && !key_up.down && grounded)
	{
		vsp = -12
		sprite_index = spr_player_superjump
		scr_sound_3d(sfx_superjumprelease, x, y)
		create_effect(x, y, spr_superjumpexplosion)
	}
	
	if (sprite_index == spr_player_superjump)
	{
		instakill = true
		image_speed = abs(vsp) / 25
		if (particle_timer > 0)
			particle_timer--
		else
		{
			particle_timer = 20
			with create_effect(x, y, spr_piledrivereffect)
			{
				image_yscale = -1
				depth = -150
			}
			create_effect(x, y, spr_flamecloud)
		}
		movespeed = 0
		
		if (place_meeting(x, y - 1, obj_solid))
		{
			reset_anim(spr_player_ceilinghit)
			state = states.bump
			scr_sound_3d(sfx_groundpound, x, y)
		}
		
		if (sprite_index != spr_player_Sjumpcancelstart)
			vsp -= 0.6
		
		if (input_buffers.grab > 0 || key_dash.pressed) && state != states.bump
		{
			input_buffers.grab = 0
			reset_anim(spr_player_Sjumpcancelstart)
			scr_sound_3d(sfx_superjumpcancel, x, y)
			audio_stop_sound(sfx_superjumprelease)
		}
		
		aftimg_timers.blur.do_it = true
		aftimg_timers.mach.do_it = true
	}
}