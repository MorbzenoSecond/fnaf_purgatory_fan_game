extends Camera2D

@export var shake_fade: float = 0

var _shake_strength: float = 0.3


func _process(delta: float) -> void:
	_shake_strength = lerp(_shake_strength,0.0, 0 *delta)
	offset = Vector2(randf_range(-_shake_strength, _shake_strength),randf_range(-_shake_strength, _shake_strength))
