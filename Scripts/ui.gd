extends CanvasLayer

@onready var camera_pad: Node3D = $"cameras_view"
@onready var player_pov = $"../../Player pov"
@onready var camera_sprite = $Area2D/Camera_sprite

var is_oppen = false
var is_out = true
var animating = false
var active = true
var animating_vent := false
var ventilation_open := false

var rotation_speed = 0
var rotation_per_spot = 0.55
var max_rotation = 0.75

var rotation_speed_x = 0
var rotation_per_spot_x = 0.2
var max_rotation_x = 0.25

var camera_tween: Tween
var ventilation_tween : Tween
var tween = Tween

#region camera functions
func area_camera() -> void:
	if animating:
		return
	var bump_tween := get_tree().create_tween()
	bump_tween.parallel().tween_property(player_pov,"rotation_degrees", Vector3(0,0,0) ,.15).set_trans(Tween.TRANS_QUART)
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
	#camera_pad.visible = true
	camera_tween.tween_property(camera_pad,"position:y", camera_pad.position.y + 30 ,.25)
	camera_tween.parallel().tween_property(camera_pad,"position:z", camera_pad.position.z + 12 ,.20)
	camera_tween.parallel().tween_property(camera_pad,"rotation_degrees:x", 0 ,.25)
	visible_visible($open_ventilations)

func close_camera():
	camera_movement(false)
	is_oppen = false
	visible_visible($open_ventilations)
	camera_tween.tween_property(camera_pad,"position:y", camera_pad.position.y - 30 ,.25)
	camera_tween.parallel().tween_property(camera_pad,"position:z", camera_pad.position.z - 12 ,.20)
	camera_tween.parallel().tween_property(camera_pad,"rotation_degrees:x", -179 ,.25)
	#camera_tween.tween_property(camera_pad, "visible", false, 0)
#endregion

#region activate-deactivate functions
func movement_buttons(status : bool):
	for area in get_children():
		if area is Area2D:
			area.get_child(0).disabled = status
	if status: 
		active = false
	else:
		active = true

func hold_it():
	movement_buttons(true)
	$Timer.start()

func camera_movement(status : bool):
	for area in $Camera_movement_areas.get_children():
		if area is Area2D:
			area.get_child(0).disabled = status

func visible_visible(node):
	var shade_tween = get_tree().create_tween()
	if node.visible:
		shade_tween.tween_property(node, "visible", false, 0)
	else:
		shade_tween.tween_property(node, "visible", true, 0)
#endregion

#region process

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

func rotation_y(orientation):
	rotation_speed += rotation_per_spot * orientation

func rotation_x(orientation):
	rotation_speed_x += rotation_per_spot_x * orientation
#endregion

#region ventilation funcions
func look_at_the_ventilation(rotation: float) -> void:
	if animating_vent:
		return

	if ventilation_tween:
		ventilation_tween.kill()

	animating_vent = true
	ventilation_tween = get_tree().create_tween()
	if ventilation_open:
		visible_visible($Open_close_camera)
		camera_movement(false)
		ventilation_open = false
		ventilation_tween.tween_property(
			player_pov,
			"rotation_degrees",
			Vector3(0,0,0),
			0.25
		)
	else:
		visible_visible($Open_close_camera)
		camera_movement(true)
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

func _show_the_sprite():
	tween = get_tree().create_tween()
	tween.tween_property(camera_sprite, "modulate", Color("ffffff"), 2)

func _hide_the_sprite():
	tween = get_tree().create_tween()
	tween.tween_property(camera_sprite, "modulate", Color("ffffff00"), 2)

#endregion

func _on_timer_timeout() -> void:
	$Timer.stop()
	movement_buttons(false)
	animating = false
