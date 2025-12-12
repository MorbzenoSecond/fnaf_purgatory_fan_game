extends Node3D
class_name rooms

@onready var animatronicos = $animatronics
@onready var camera_spoot = $camera_spoot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var animatronicos_in_room = animatronicos.get_children()
	for anima in animatronicos_in_room:
		pass
		#print(anima)
