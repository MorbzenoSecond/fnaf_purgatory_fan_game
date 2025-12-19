extends CanvasLayer

@onready var camera_pad: Node3D = $"cameras_view"
@onready var player_pov = $"../../Player pov"
@onready var camera_sprite = $Area2D/Camera_sprite

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
var camera_tween: Tween

#region camera functions
func area_camera() -> void:
	if animating:
		return
	var bump_tween := get_tree().create_tween()
	bump_tween.parallel().tween_property(player_pov,"rotation_degrees", Vector3(0,0,0) ,.15).set_trans(Tween.TRANS_QUART)
	movement_buttons(true)
	$Timer.start()
	if ventilation_open:
		ventilation_open = false
		is_oppen = true
		return
	if !is_oppen and is_out:
		is_out = false
		animating = true
	if is_oppen:
		is_out = true
		animating = true
	camera_pad.sound.play()

	if camera_tween and camera_tween.is_running():
		camera_tween.kill()
	camera_tween = get_tree().create_tween()
	
	if not is_oppen and !ventilation_open:
		open_camera()
	elif !ventilation_open:
		close_camera()



func open_camera():
	camera_movement(true)
	is_oppen = true
	camera_pad.visible = true
	camera_tween.tween_property(camera_pad,"position:y", camera_pad.position.y + 30 ,.25)
	camera_tween.parallel().tween_property(camera_pad,"position:z", camera_pad.position.z + 12 ,.20)
	camera_tween.parallel().tween_property(camera_pad,"rotation_degrees:x", 0 ,.25)
	camera_tween.tween_property($open_ventilations, "visible", true, 0)
func close_camera():
	camera_movement(false)
	is_oppen = false
	camera_tween.tween_property($open_ventilations, "visible", false, 0)
	camera_tween.tween_property(camera_pad,"position:y", camera_pad.position.y - 30 ,.25)
	camera_tween.parallel().tween_property(camera_pad,"position:z", camera_pad.position.z - 12 ,.20)
	camera_tween.parallel().tween_property(camera_pad,"rotation_degrees:x", -179 ,.25)
	camera_tween.tween_property(camera_pad, "visible", false, 0)
#endregion

#region activate-deactivate functions
func movement_buttons(status : bool):
	for area in get_children():
		if area is Area2D:
			area.get_child(0).disabled = status
	await get_tree().process_frame
	if status: 
		active = false
	else:
		active = true

func camera_movement(status : bool):
	for area in $Camera_movement_areas.get_children():
		if area is Area2D:
			area.get_child(0).disabled = status
#endregion

func _on_timer_timeout() -> void:
	$Timer.stop()
	movement_buttons(false)
	animating = false
	
var ventilation_tween : Tween
var animating_vent := false
var ventilation_open := false

func look_at_the_ventilation(rotation: float) -> void:
	if animating_vent:
		return

	if ventilation_tween:
		ventilation_tween.kill()

	animating_vent = true
	ventilation_tween = get_tree().create_tween()
	movement_buttons(true)
	if ventilation_open:
		ventilation_open = false
		ventilation_tween.tween_property(
			player_pov,
			"rotation_degrees",
			Vector3(0,0,0),
			0.25
		)
	else:
		ventilation_open = true
		ventilation_tween.tween_property(
			player_pov,
			"rotation_degrees",
			Vector3(0.0,rotation,0.0),
			0.25
		)

	ventilation_tween.finished.connect(func():
		animating_vent = false
	)

	$Timer2.start()


func _on_timer_2_timeout() -> void:
	$Timer2.stop()
	if not is_oppen:
		is_oppen = true
	else:
		is_oppen = false
	movement_buttons(false)
	animating_vent = false

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
var tween = Tween

func _show_the_sprite():
	tween = get_tree().create_tween()
	tween.tween_property(camera_sprite, "modulate", Color("ffffff00"), 3)
	tween.tween_property(camera_sprite, "modulate", Color("ffffff"), 2)

func _hide_the_sprite():
	tween = get_tree().create_tween()
	tween.tween_property(camera_sprite, "modulate", Color("ffffff00"), 2)
