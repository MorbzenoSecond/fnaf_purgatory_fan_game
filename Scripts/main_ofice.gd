# room_manager.gd
extends Node3D

var old_room: Node3D 
var current_room: Node3D
@onready var viewport = $SubViewport
@onready var sprite = $"Ui/CanvasLayer/cameras_view/Sprite3D2"
@onready var hours_label: = $"Ui/Hours System/AnimatedSprite2D"
@onready var phone_guy = $Phone_guy
@onready var timer_jumpscare = $Timer_jumscare
@onready var timer_desactivate_static = $SubViewport/Timer_desactivate_static
var hours = 0

func _ready() -> void:
	Input.warp_mouse(Vector2(575, 325))
	$Node3D/AnimationPlayer.play("start_shift")
	phone_guy.stream = load(NightData.nights_data[NightData.current_night]["phone_guy_call"])
	var tex = viewport.get_texture()
	sprite.texture = tex
	current_room = $Rooms/Node3D
	var connection_to_path = $"Ui/CanvasLayer/cameras_view"
	connection_to_path.goto_room.connect(_on_goto_room)

var max_light_reached := false
var bump_tween: Tween

func _process(delta: float) -> void:
	$"Player pov".global_position.y += sin(Time.get_ticks_msec() / 1000) * 0.3 * delta
	if bump_tween != null and bump_tween.is_running():
		return

	bump_tween = get_tree().create_tween()

	if not max_light_reached:
		bump_tween.tween_property($Lights/SpotLight3D, "light_energy", 10.0, 10.0)
		max_light_reached = true
	else:
		bump_tween.tween_property($Lights/SpotLight3D, "light_energy", 0.2, 0.2).set_trans(Tween.TRANS_EXPO)
		bump_tween.tween_property($Lights/SpotLight3D, "light_energy", 8.0, 0.2).set_trans(Tween.TRANS_EXPO)
		bump_tween.tween_property($Lights/SpotLight3D, "light_energy", 0.2, 0.2).set_trans(Tween.TRANS_EXPO)
		bump_tween.tween_property($Lights/SpotLight3D, "light_energy", 8.0, 0.2).set_trans(Tween.TRANS_EXPO)
		bump_tween.tween_property($Lights/SpotLight3D, "light_energy", 2.0, 3.0).set_trans(Tween.TRANS_EXPO)

		max_light_reached = false

func _on_goto_room(path: String, path_id):
	RoomData.get_room_by_name(path_id)
	var scene = load(path)
	_new_room(scene, path_id)
	await get_tree().process_frame

func _activate_static():
	camera_filter.material = camera_filter.material.duplicate()
	camera_filter.material.set_shader_parameter("STATIC", true)
	timer_desactivate_static.start()

func _new_room(scene: PackedScene, path_id):
	var new_room = scene.instantiate()
	camera_filter.material = camera_filter.material.duplicate()
	camera_filter.material.set_shader_parameter("STATIC", true)
	
	$Rooms.add_child(new_room)
	
	old_room = current_room
	current_room = new_room
	current_room.position = $"Marker3D".position
	RoomData.current_room = path_id
	if old_room:
		old_room.queue_free()
	_reload_current_room(path_id)
	camera_new_settings(current_room.camera_spoot.global_position, current_room.camera_spoot.rotation)

func camera_new_settings(new_global_position : Vector3, rotation):
	var camera = $SubViewport/Security_camera
	camera.global_position = new_global_position
	camera.rotation = rotation

func _reload_current_room(path_id):
	var animatronics_in_room = RoomData.rooms_actual_data[path_id]["animatronics"].keys()
	for anim in animatronics_in_room:
		var animatronic_in_room_status = RoomData.rooms_actual_data[path_id]["animatronics"][anim]
		var node = current_room.find_child(str(anim), true, false)
		if node:
			node.visible = animatronic_in_room_status
		else:
			return

func _animatronics_in_actual_room():
	var animatronics_in_room = RoomData.rooms_actual_data["main_room"]["animatronics"].keys()
	for anim in animatronics_in_room:
		var animatronic_in_room_status = RoomData.rooms_actual_data["main_room"]["animatronics"][anim]
		var node = $animatronics.find_child(str(anim), true, false)
		if node:
			node.visible = animatronic_in_room_status
		else:
			return
	

func _on_timer_timeout() -> void:
	if hours < 6:
		hours += 1
		hours_label.play(str(hours))
	if hours == 6:
		finish_the_night()
		$Timer.stop()
		return

func finish_the_night():
	NightData.nights_data[NightData.current_night]["night_status"] = true
	var tween = get_tree().create_tween()
	tween.tween_property($"Player pov", "rotation_degrees", Vector3(0,0,0) ,3)
	$Ui/CanvasLayer.desactivate_all_functions()
	NightData.get_current_night()
	await get_tree().process_frame
	NightData.save()
	$AudioStreamPlayer3D.stream = load("res://art/Sound_effects/FNAF - 6 AM sound.mp3")
	$AudioStreamPlayer3D.play()
	$Node3D/AnimationPlayer.play("Finish_night")

func game_over():
	$animatronics.hide()
	$Timer.stop()
	$Phone_guy.stop()
	$Node3D/VideoStreamPlayer.show()
	$AudioStreamPlayer3D.stream = load("res://GET OUT Meme Sound Effect.mp3")
	$AudioStreamPlayer3D.play()
	timer_jumpscare.start()
	$Node3D/VideoStreamPlayer.play()

	#$Node3D/AnimationPlayer.play("Finish_night")
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Finish_night":
		get_tree().change_scene_to_file("res://Main_menu.tscn")

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("izq_click"):
		#game_over()

func _on_timer_jumscare_timeout() -> void:
	get_tree().change_scene_to_file("res://Main_menu.tscn")

@onready var camera_filter = $SubViewport/ColorRect

func _on_timer_desactivate_static_timeout() -> void:
	camera_filter.material = camera_filter.material.duplicate()
	camera_filter.material.set_shader_parameter("STATIC", false)
