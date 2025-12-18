# room.gd
extends Node3D
signal goto_room(path, path_id)
signal goto_main
@onready var animatronic_icons = $animatronic_icons.get_children()
@onready var sound = $AudioStreamPlayer3D
@onready var main = $"../../.."
var ventilation_paths := {}

func _ready() -> void:
	ventilation_paths = {
		"E1_E2": E1_E2,
		"E1_E3": E1_E3
	}
	await  get_tree().process_frame

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		animatronic_in_ventilation_movement("animatronic_1", "E1_E3", false, 7)
	if Input.is_action_pressed("ui_down"):
		animatronic_in_ventilation_movement("animatronic_2", "E1_E2", true, 7)

func _on_transition_entered(path, path_id):
	call_deferred("emit_signal", "goto_room", path, path_id)
	await get_tree().process_frame
	_check_current_camera(path_id)

func _check_current_camera(path_id):
	var buttons = $Sprite3D.get_children()
	for button in buttons:
		if button.get_path_id() == RoomData.current_room:
			button.sprite.modulate = "ffaf59"
		else:
			button.sprite.modulate = "ffffff"

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouse and Input.is_action_just_pressed("izq_click"):
		choose_tablet_view()

var camera_on = true

func choose_tablet_view():
	
	if camera_on:
		$animatronic_icons.show()
		$Sprite3D.hide()
		for button in $Sprite3D.get_children():
			button.collision.disabled = true
		main._ventilation_off()
	else: 
		$animatronic_icons.hide()
		$Sprite3D.show()
		for button in $Sprite3D.get_children():
			button.collision.disabled = false
		main._camera_on()

@onready var E1_E2 = [$Entraces_ventilation_points/E1.position, $ventilations_points/P1.position, $ventilations_points/P6.position,
$ventilations_points/P8.position, $ventilations_points/P9.position, $Entraces_ventilation_points/E2.position]

@onready var E1_E3 = [$Entraces_ventilation_points/E1.position, $ventilations_points/P1.position,
$ventilations_points/P6.position, $ventilations_points/P8.position, $ventilations_points/P15.position,
$ventilations_points/P14.position, $Entraces_ventilation_points/E3.position]

func animatronic_enter_the_ventilation(animatronic_id : String, start_point : String):
	pass

var ventilation_tween: Tween
var appear_tween : Tween
var animatronics_in_ventilation := {}

func animatronic_in_ventilation_movement(animatronic_id : String, choosen_path : String, reverse : bool, time_spend : float ):
	var path = ventilation_paths.get(choosen_path)
	print(path)
	if reverse:
		path.reverse()
	
	var animatronic_icon
	appear_tween = get_tree().create_tween()
	for e in animatronic_icons:
		if e.animatronic_id == animatronic_id:
			animatronic_icon = e  
			animatronics_in_ventilation.get_or_add(animatronic_icon)
			animatronic_icon.position = path.front()
			appear_tween.tween_property(animatronic_icon.sprite, "modulate", Color("ffffff"), 0.5)
			break;
	
	var time = time_spend/path.size()
	
	if ventilation_tween and ventilation_tween.is_running() and !animatronics_in_ventilation.has(animatronic_icon):
		ventilation_tween.kill()
	ventilation_tween = get_tree().create_tween()
	for i in path:
		ventilation_tween.tween_interval(time)
		ventilation_tween.tween_property(animatronic_icon, "position", i, 0)
	
	if reverse:
		path.reverse()
	await ventilation_tween.finished
	animatronic_exit_the_ventilation(animatronic_icon)

func animatronic_exit_the_ventilation(animatronic):
	if appear_tween and appear_tween.is_running() and !animatronics_in_ventilation.has(animatronic):
		appear_tween.kill()
	animatronics_in_ventilation.erase(animatronic)
	appear_tween = get_tree().create_tween()
	appear_tween.tween_property(animatronic.sprite, "modulate", Color("ffffff00"), 0.5)
