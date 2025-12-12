extends Node3D
@onready var label = $"nights, number"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	NightData.load_data()
	NightData.get_current_night()
	await get_tree().process_frame
	if !NightData.first_enter:
		$AnimationPlayer.play("welcome")
	else:
		$AnimationPlayer.play("back_to_game")
	NightData.first_enter = true
	#print(NightData.current_night)

func _process(delta: float) -> void:
	print(NightData.current_night)
	label.text = NightData.current_night
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_button_pressed() -> void:
	$AnimationPlayer.play("fade_out")

func _on_continue_mouse_entered() -> void:
	print("pass # Replace with function body.")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://Main_office.tscn")

func _on_options_button_pressed() -> void:
	get_tree().quit()
