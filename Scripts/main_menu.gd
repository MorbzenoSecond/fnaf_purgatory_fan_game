extends Node2D

@onready var label = $"Buttons/nights, number"
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	NightData.load_data()
	await get_tree().process_frame
	NightData.get_current_night()
	if !NightData.first_enter:
		$AnimationPlayer.play("welcome")
	else:
		$AnimationPlayer.play("back_to_game")
	NightData.first_enter = true
	for button in $Buttons.get_children():
		if button is Button:
			button.toggled
			button.pressed.connect(play_button_click_animation.bind(button))
	for button in $New_game_warning.get_children():
		if button is Button:
			button.pressed.connect(play_button_click_animation.bind(button))
	#print(NightData.current_night)

func _process(delta: float) -> void:
	label.text = NightData.current_night

func _on_button_pressed() -> void:
	$AnimationPlayer.play("fade_out")

func _on_continue_mouse_entered() -> void:
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://Main_office.tscn")

func _on_options_button_pressed() -> void:
	get_tree().quit()
var tween: Tween

func enable_all_buttons():
	tween = get_tree().create_tween()
	tween.tween_property($Buttons, "modulate", Color("ffffff"), 2)
	enable_buttons()

func enable_buttons():
	for button in $Buttons.get_children():
		if button is Button:
			button.disabled = false
		if button == $Buttons/Continue and NightData.current_night == "Night 1":
			button.disabled = true

func dissable_buttons():
	for button in $Buttons.get_children():
		if button is Button:
			button.disabled = true
		if button == $Buttons/Continue and NightData.current_night == "Night 1":
			button.disabled = true

func _on_new_game_button_pressed() -> void:
	if !NightData.current_night == "Night 1":
		_new_game_warning_on()
	else: 
		$AnimationPlayer.play("fade_out")

func _new_game_warning_on():
	dissable_buttons()
	$AnimationPlayer.play("new_game_warning")
	for button in $New_game_warning.get_children():
		if button is Button:
			button.disabled = false

func _new_game_warning_off():
	enable_buttons()
	$AnimationPlayer.play_backwards("new_game_warning")
	for button in $New_game_warning.get_children():
		if button is Button:
			button.disabled = true

func _on_accept_pressed() -> void:
	NightData.new_game()
	$AnimationPlayer.play("fade_out")

func _on_cancel_pressed() -> void:
	_new_game_warning_off()

func play_button_click_animation(button: Button) -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(button, "modulate", Color("ffbf3b"), 0.15)
	tween.parallel().tween_property(button, "scale", Vector2(0.32,0.32), 0.15)
	tween.tween_property(button, "modulate", Color("ffffff"), 0.15)
	tween.parallel().tween_property(button, "scale", Vector2(0.3,0.3), 0.15)
