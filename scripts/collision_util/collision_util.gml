function collide()
{
	grounded = false
	
	var old_x = x
	var old_y = y
	
	var hsp_plat = 0
	var vsp_plat = 0
	
	if (vsp < 20)
		vsp += grav
	
	old_x2 = x
	old_y2 = y
		
	var h = bbox_bottom - y
	with (instance_place(x, y + 1 + other.vsp, obj_movingplatform))
	{
		if (other.bbox_bottom - other.vsp <= bbox_top)
		{
			hsp_plat = hsp
			vsp_plat = vsp
			other.vsp = 0
			other.grounded = true
			other.y = bbox_top - h
		}
	}
	
	var hsp_final = hsp + hsp_plat
	var vsp_final = vsp + vsp_plat
	
	var abs_final = abs(vsp_final);
	
	repeat round(abs_final)
	{
		old_y = y
		
		if abs_final
			y += sign(vsp_final);
		else
			y += vsp_final;
		
		if (scr_solid(x, y))
		{
			y = old_y
			vsp = 0
			vsp_final = 0
		}
	}
		
	abs_final = abs(hsp_final);
		
	repeat round(abs_final)
	{
		old_x = x
		
		if abs_final
			x += sign(hsp_final)
		else
			x += hsp_final;
		
		var h = 4
		
		for (var i = 1; i < h; i++) 
		{
			if !scr_solid(x, y - i)
			{
				while scr_solid(x, y)
					y--;
			}
			if (scr_solid(x, y + i + 1) && scr_solid(x - sign(hsp_final), y + 1))
			{
				while !scr_solid(x, y + 1)
					y++
			}
		}
		
		if (scr_solid(x, y))
		{
			x = old_x
			hsp = 0
			hsp_final = 0
		}
	}
	
	grounded |= scr_solid(x, y + 1)
}

function init_collide()
{
	hsp = 0
	vsp = 0
	grav = 0.5
	grounded = false
	old_x2 = x
	old_y2 = y
}

function scr_solid(_x, _y)
{
	var collided = false
	var master = id
	var do_parent_check = false
	var climbingladder = false
	if variable_instance_exists(master, "state")
	{
		if (master.state == states.ladder)
			climbingladder = true
	}
	for (var i = 0; i < ds_list_size(global.col_obj_list); i++) 
	{
		var _id = ds_list_find_value(global.col_obj_list, i)
		with (instance_place(_x, _y, _id))
		{
			switch (object_index)
			{
				case obj_solid:
					collided = true
					break;
				case obj_platform:
					if (master.bbox_bottom <= bbox_top + 1 && (master.y - master.old_y2) >= 0 && !climbingladder)
						collided = true
					break;
				case obj_slope:
					if (collide_slope(master, _x, _y))
						collided = true
					break;
				case obj_slopeplatform:
					if (collide_slopeplatform(master, _x, _y) && !climbingladder)
						collided = true
					break;
				default:
					do_parent_check = true
			}
			if do_parent_check
			{
				switch (object_get_parent(object_index))
				{
					case obj_solid:
						collided = true
						break;
					case obj_destroyable:
						collided = true
						break;
				}
			}
		}
	}
	return collided;
}

function collide_slope(master, _x, _y)
{
	var side = 0
	var height = master.bbox_bottom - master.y
	var slope_y = 0
	var slope = (bbox_bottom - bbox_top) / (bbox_right - bbox_left)
	if (image_xscale > 0)
	{
		side = _x + (master.bbox_right - master.x)
		slope_y = bbox_bottom - ((side - bbox_left) * slope)
	}
	else
	{
		side = _x + (master.bbox_left - master.x)
		slope_y = bbox_bottom + ((side - bbox_right) * slope);
	}
	return _y + height > slope_y;
}

function collide_slopeplatform(master, _x, _y)
{
	var side = 0
	var height = master.bbox_bottom - master.y
	var slope_y = 0
	var slope = (bbox_bottom - bbox_top) / (bbox_right - bbox_left)
	var check_1 = false
	var check_2 = false
	if (image_xscale > 0)
	{
		side = _x + (master.bbox_right - master.x)
		slope_y = bbox_bottom - ((side - bbox_left) * slope)
	}
	else
	{
		side = _x + (master.bbox_left - master.x)
		slope_y = bbox_bottom + ((side - bbox_right) * slope);
	}
	
	check_1 = _y + height > max(slope_y, bbox_top)
	
	if (image_xscale > 0)
	{
		side = master.old_x2 + (master.bbox_right - master.x)
		slope_y = bbox_bottom - ((side - bbox_left) * slope)
	}
	else
	{
		side = master.old_x2 + (master.bbox_left - master.x)
		slope_y = bbox_bottom + ((side - bbox_right) * slope);
	}
	
	check_2 = master.old_y2 + height <= max(slope_y, bbox_top) + 1
	
	return check_1 && check_2
}

function scr_slope(_x, _y)
{
	var s_list = ds_list_create()
	instance_place_list(_x, _y, obj_slope, s_list, false)
	for (var i = 0; i < ds_list_size(s_list); i++) {
	    with (ds_list_find_value(s_list, i))
		{
			if (collide_slope(other, _x, _y))
				return true;
		}
	}
	
	instance_place_list(_x, _y, obj_slopeplatform, s_list, false)
	for (var i = 0; i < ds_list_size(s_list); i++) {
	    with (ds_list_find_value(s_list, i))
		{
			if (collide_slope(other, _x, _y))
				return true;
		}
	}
	
	ds_list_destroy(s_list)
	return false;
}

function do_slope_momentum(spd_up = 20)
{
	var go_down = false
	with (instance_place(x, y + 1, obj_slope))
	{
		if (collide_slope(other, other.x, other.y + 1) && other.xscale != sign(image_xscale))
			go_down = true
	}
	
	with (instance_place(x, y, obj_slopeplatform))
	{
		if (collide_slopeplatform(other, other.x, other.y + 1) && other.xscale != sign(image_xscale))
			go_down = true
	}
	if (go_down)
		movespeed = approach(movespeed, spd_up, 0.1)
}
