global.score += val
global.combo.timer = 60

var c = {
	sprite_index: self.sprite_index,
	image_index: self.image_index,
	x: self.x - obj_camera.campos.x,
	y: self.y - obj_camera.campos.y,
	val: self.val
}

array_push(obj_collect_got_visual.collects, c)

with instance_create(x, y, obj_collect_number)
	num = other.val

scr_sound(sfx_collectbig)
instance_destroy()

ds_list_add(global.ds_saveroom, id)

with obj_tv
	tv_expression(spr_tv_collect)
