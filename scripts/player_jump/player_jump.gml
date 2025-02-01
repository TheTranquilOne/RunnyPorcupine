function player_jump()
{
	if (p_move != 0)
	{
		movespeed = approach(movespeed, 6, 0.5)
		xscale = p_move
	}
	else if (p_move == 0 || xscale != p_move)
		movespeed = approach(movespeed, 0, 0.5)
	
	hsp = movespeed * xscale
	
	if (!jumpstop && !key_jump.down && vsp < 0)
	{
		jumpstop = true
		vsp /= 10
	}
	
	if sprite_index != spr_player_grabbump
		do_grab()
	do_groundpound()
	
	if (grounded && vsp >= 0)
	{
		state = states.normal
		reset_anim(movespeed < 1 ? spr_player_land : spr_player_landmove)
		if (key_dash.down)
		{
			state = states.mach2
			if (movespeed < 6)
				movespeed = 6
			reset_anim(spr_player_mach1)
		}
	}
	
	image_speed = 0.35
	switch (sprite_index)
	{
		case spr_player_jump:
		case spr_player_grabcancel:
		case spr_player_piledriverjump:
			reset_anim_on_end(spr_player_fall)
			break;
		case spr_player_stomp:
			if anim_ended()
				image_index = 3
			break;
	}
	do_taunt()
}