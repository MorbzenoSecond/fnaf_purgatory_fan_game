extends Area3D


func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouse and Input.is_action_just_pressed("izq_click"):
		$"../Fredy_noice".play()
