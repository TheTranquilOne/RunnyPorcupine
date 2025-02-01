function player_mach2() 
{
	hsp = xscale * movespeed
	
	if (grounded && vsp >= 0)
	{
		if (sprite_index != spr_player_mach1 && sprite_index != spr_player_rollgetup)
			sprite_index = spr_player_mach2
		if (!key_dash.down)
		{
			if (movespeed < 8)
			{
				state = states.normal
				movespeed = 0
			}
			else
			{
				reset_anim(spr_player_machslidestart)
				state = states.slide
				scr_sound_3d(sfx_break, x, y)
			}
		}
		if (p_move != 0 && p_move != xscale)
		{
			if (movespeed < 8)
			{
				xscale = p_move
				movespeed = 6
			}
			else
			{
				reset_anim(spr_player_machslideboost)
				state = states.slide
				scr_sound_3d(sfx_machslideboost, x, y)
			}
		}
		if (movespeed < 12)
			movespeed += 0.1
		else
		{
			if (sprite_index != spr_player_rollgetup)
				sprite_index = spr_player_mach3
			state = states.mach3
			flash = 8
		}
	}
	else
	{
		if (sprite_index != spr_player_secondjump && 
			sprite_index != spr_player_secondjumploop && 
			sprite_index != spr_player_walljump && 
			sprite_index != spr_player_walljumpfall && 
			sprite_index != spr_player_longjump &&
			sprite_index != spr_player_mach2jump)
			reset_anim(spr_player_secondjump)
		if (!jumpstop && !key_jump.down && vsp < 0)
		{
			jumpstop = true
			vsp /= 10
		}
	}
	if (key_jump.pressed && coyote_time) 
	{
		jumpstop = false
		vsp = -11
		scr_sound_3d(sfx_jump, x, y)
	}
	do_slope_momentum()
	if (key_down.down)
	{
		state = states.tumble
		if (grounded)
			reset_anim(spr_player_machroll)
		else
		{
			sprite_index = spr_player_dive
			vsp = 10
			scr_sound_3d_pitched(sfx_dive, x, y, 1.3, 1.315)
		}
	}
	if ((!grounded || scr_slope(x, y + 1)) && place_meeting(x + xscale, y, obj_solid))
	{
		wallspeed = movespeed
		if (movespeed < 1)
			wallspeed = 1
		else
			movespeed = wallspeed
		state = states.climbwall
	}
	else if (grounded && place_meeting(x + xscale, y, obj_solid))
	{
		state = states.bump
		reset_anim(spr_player_wallsplat)
	}
	
	do_grab()
	
	image_speed = movespeed / 20
	switch (sprite_index)
	{
		case spr_player_mach1:
			image_speed = 0.5
			reset_anim_on_end(spr_player_mach2)
			break
		case spr_player_secondjump:
			image_speed = 0.4
			reset_anim_on_end(spr_player_secondjumploop)
			break
		case spr_player_walljump:
			image_speed = 0.4
			reset_anim_on_end(spr_player_walljumpfall)
			break
		case spr_player_rollgetup:
			image_speed = 0.4
			reset_anim_on_end(spr_player_mach2)
			break
		case spr_player_longjump:
			image_speed = 0.35
			if (anim_ended())
				image_index = 10
			break
		/*case spr_player_secondjump:
			sprite_index = spr_player_secondjumploop
			break
		case 'longjump':
			sprite_index = spr_player_longjumpend'
			break
		case 'walljump':
			sprite_index = spr_player_walljumpfall'
			break*/
	}
	do_taunt()
	
	aftimg_timers.mach.do_it = true
}