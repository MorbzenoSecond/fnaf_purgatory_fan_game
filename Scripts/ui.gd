extends CanvasLayer

@onready var camera_pad: Node3D = $"cameras_view"
@onready var player_pov = $"../../Player pov"
var is_oppen = false
var is_out = true
var animating = false
var rotation_speed = 0
var rotation_per_spot = 0.55
var max_rotation = 0.75
var active = true
var rotation_speed_x = 0
var rotation_per_spot_x = 0.2
var max_rotation_x = 0.25

func _on_area_2d_mouse_entered() -> void:
	if animating:
		return
	if !is_oppen and is_out:
		is_out = false
		animating = true

		$Timer.start()
	if is_oppen:
		is_out = true
		animating = true
		$Timer.start()
		

func desactivate_all_functions():
	for area in get_children():
		if area is Area2D:
			area.get_child(0).disabled = true
			print(area.get_child(0).disabled)
	await get_tree().process_frame
	active = false
	$Area2D/Sprite2D.visible = false

func _on_timer_timeout() -> void:
	$Timer.stop()

	var bump_tween := get_tree().create_tween()

	if not is_oppen:
		is_oppen = true

		for area in get_children():
			if area is Area2D and not area == $Area2D:
				area.get_child(0).disabled = true
		bump_tween.tween_property(camera_pad,"position:y", camera_pad.position.y + 30 ,.25)
		camera_pad.visible = true
		camera_pad.sound.play()
		bump_tween.parallel().tween_property(camera_pad,"position:z", camera_pad.position.z + 12 ,.20)
		bump_tween.parallel().tween_property(camera_pad,"rotation_degrees:x", 0 ,.25)
		bump_tween.parallel().tween_property(player_pov,"rotation_degrees", Vector3(0,0,0) ,.15).set_trans(Tween.TRANS_QUART)
	else:
		for area in get_children():
			if area is Area2D and not area == $Area2D:
				area.get_child(0).disabled = false
		camera_pad.sound.play()
		bump_tween.tween_property(camera_pad,"position:y", camera_pad.position.y - 30 ,.25)
		bump_tween.parallel().tween_property(camera_pad,"position:z", camera_pad.position.z - 12 ,.20)
		bump_tween.parallel().tween_property(camera_pad,"rotation_degrees:x", -179 ,.25)
		bump_tween.tween_property(camera_pad, "visible", false, 0)
		is_oppen = false

	animating = false

func _process(delta: float) -> void:
	if player_pov.rotation.y > max_rotation and rotation_speed > 0:
		return
	if player_pov.rotation.y < -max_rotation and rotation_speed < 0:
		return
	if active:
		player_pov.rotation.y += rotation_speed * delta

func _physics_process(delta: float) -> void:
	if player_pov.rotation.x > max_rotation_x and rotation_speed_x > 0:
		return
	if player_pov.rotation.x < -max_rotation_x and rotation_speed_x < 0:
		return
	if active:
		player_pov.rotation.x += rotation_speed_x * delta
func _on_area_2d_mouse_exited() -> void:
	if animating:
		return

func _on_area_2d_left_1_mouse_entered() -> void:
	rotation_speed += rotation_per_spot

func _on_area_2d_left_1_mouse_exited() -> void:
	rotation_speed -= rotation_per_spot

func _on_area_2d_right_1_mouse_entered() -> void:
	rotation_speed -= rotation_per_spot

func _on_area_2d_right_1_mouse_exited() -> void:
	rotation_speed += rotation_per_spot

func _on_area_2d_up_1_mouse_entered() -> void:
	rotation_speed_x += rotation_per_spot_x

func _on_area_2d_up_1_mouse_exited() -> void:
	rotation_speed_x -= rotation_per_spot_x

func _on_area_2d_up_2_mouse_entered() -> void:
	rotation_speed_x += rotation_per_spot_x

func _on_area_2d_up_2_mouse_exited() -> void:
	rotation_speed_x -= rotation_per_spot_x

func _on_area_2d_down_1_mouse_entered() -> void:
	rotation_speed_x -= rotation_per_spot_x

func _on_area_2d_down_1_mouse_exited() -> void:
	rotation_speed_x += rotation_per_spot_x

func _on_area_2d_down_2_mouse_entered() -> void:
	rotation_speed_x -= rotation_per_spot_x

func _on_area_2d_down_2_mouse_exited() -> void:
	rotation_speed_x += rotation_per_spot_x
