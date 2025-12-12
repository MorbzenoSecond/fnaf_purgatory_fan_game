# room.gd
extends Node3D
signal goto_room(path, path_id)
signal goto_main
@onready var sound = $AudioStreamPlayer3D

func _ready() -> void:
	$Sprite3D2.texture = ViewportTexture
	$Sprite3D2.scale = Vector3(1200,800,1)
	print($Sprite3D2.get_viewport())

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
