function player_mach3() 
{
	hsp = xscale * movespeed
	mach4mode = movespeed > 16
	
	var dashpad = sprite_index == spr_player_dashpad
	
	if (mach4mode)
	{
		if (sprite_index != spr_player_mach4)
		{
			flash = 8
			sprite_index = spr_player_mach4
		}
		/*if (superjumpeffecttimer > 0)
			superjumpeffecttimer--
		else
		{
			superjumpeffecttimer = 20
			createEffect('mach4effect', depth + 1)
			particleeffect.mirrorX(xscale)
			createEffect('flamecloud.down
		}*/
	}
	else if (sprite_index == spr_player_mach4)
	{
		flash = 8
		sprite_index = spr_player_mach3
	}
	
	if (key_jump.pressed && coyote_time) 
	{
		vsp = -11
		jumpstop = false
		reset_anim(spr_player_mach3jump)
		scr_sound_3d(sfx_jump, x, y)
	}
	
	if (grounded)
	{
		if (sprite_index == spr_player_Sjumpcancel)
			sprite_index = spr_player_mach3
		if (!key_dash.down && !dashpad)
		{
			reset_anim(spr_player_machslidestart)
			state = states.slide
			scr_sound_3d(sfx_break, x, y)
		}
		if (p_move != 0 && p_move != xscale && !dashpad)
		{
			reset_anim(spr_player_machslideboost3)
			state = states.slide
			scr_sound_3d(sfx_machslideboost, x, y)
		}
		if (movespeed < 20 && p_move == xscale)
		{
			if (mach4mode)
			{
				movespeed += 0.1
			}
			else
			{
				movespeed += 0.025
			}
		}
		if (key_up.down && !dashpad)
		{
			state = states.superjump
			reset_anim(spr_player_superjumpprep)
		}
	}
	else
	{
		if (!jumpstop && !key_jump.down && vsp < 0)
		{
			jumpstop = true
			vsp /= 10
		}
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
	
	do_grab()
	
	if ((!grounded || scr_slope(x, y + 1)) && place_meeting(x + xscale, y, obj_solid))
	{
		{
			wallspeed = movespeed
			if (movespeed < 1)
				wallspeed = 1
			else
				movespeed = wallspeed
			state = states.climbwall
		}
	}
	else if (grounded && place_meeting(x + xscale, y, obj_solid))
	{
		state = states.bump
		reset_anim(spr_player_mach3hitwall)
		vsp = -6
		hsp = xscale * -6
		shake_camera()
		scr_sound_3d(sfx_groundpound, x, y)
		scr_sound_3d(sfx_bumpwall, x, y)
	}
	image_speed = 0.4
	switch (sprite_index)
	{
		case spr_player_mach3:
			image_speed = 0.35
			break
		case spr_player_mach4:
			image_speed = movespeed / 30
			break
		case spr_player_mach3jump:
		case spr_player_rollgetup:
		case spr_player_mach3kill:
		case spr_player_dashpad:
			reset_anim_on_end(spr_player_mach3)
			break
	}
	do_taunt()
	
	aftimg_timers.mach.do_it = true
	instakill = true
	
	if !obj_particlecontroller.active_particles.machcharge
		particle_create(x, y, particles.machcharge, xscale)
}