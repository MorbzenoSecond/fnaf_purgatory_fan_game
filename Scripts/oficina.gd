extends Node3D

@onready var phone_light = $Phone_light
@onready var main = $".."

var bump_tween: Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !phone_light.visible:
		return
	if bump_tween != null and bump_tween.is_running():
		return
	bump_tween = get_tree().create_tween()
	bump_tween.tween_property(phone_light, "omni_attenuation", 8.0, 0.5).set_trans(Tween.TRANS_EXPO)
	bump_tween.tween_property(phone_light, "omni_attenuation", 1, 1.5).set_trans(Tween.TRANS_EXPO)


func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouse and Input.is_action_just_pressed("izq_click"):
		$Phone_audio.stream = load("res://art/Sound_effects/cameras.mp3")
		$Phone_audio.play()
		phone_light.hide()
		$Area3D/CollisionShape3D.disabled = true
		$"..".phone_guy.play()

var door_state = false
func _on_door_button_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouse and Input.is_action_just_pressed("izq_click"):
		if !door_state:
			$DoorButtonLights.light_color = Color("ffffff")
			$door/AnimationPlayer.play("Door up")
			$AudioStreamPlayer3D.play()
			door_state = true
			main.front_door_open = false
		else:
			$DoorButtonLights.light_color = Color("e7001f")
			$door/AnimationPlayer.play_backwards("Door up")
			$AudioStreamPlayer3D.play()
			door_state = false
			main.front_door_open = true
