extends Node3D

@onready var animatronic_icons = $animatronic_icons.get_children()
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


@onready var E1_E2 = [$Entraces_ventilation_points/E1.position, $ventilations_points/P1.position, $ventilations_points/P6.position,
$ventilations_points/P8.position, $ventilations_points/P9.position, $Entraces_ventilation_points/E2.position]

@onready var E1_E3 = [$Entraces_ventilation_points/E1.position, $ventilations_points/P1.position,
$ventilations_points/P6.position, $ventilations_points/P8.position, $ventilations_points/P15.position,
$ventilations_points/P14.position, $Entraces_ventilation_points/E3.position]

var ventilation_tween: Tween
var appear_tween : Tween
var animatronics_in_ventilation := {}

func animatronic_in_ventilation_movement(animatronic_id : String, choosen_path : String, reverse : bool, time_spend : float ):
	var path = ventilation_paths.get(choosen_path)
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
