extends Node3D

@onready var sprite = $Sprite3D
@export var animatronic_id :String = ""
@export var sprite_texture : Texture2D
var _shake_strength := 2.5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = sprite_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite.offset = Vector2(randf_range(-_shake_strength, _shake_strength),randf_range(-_shake_strength, _shake_strength))
