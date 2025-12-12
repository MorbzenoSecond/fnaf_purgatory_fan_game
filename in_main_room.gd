extends State
class_name InMainRoom
@onready var player = $"../../../.."

func Enter():
	pass

func move():
	if randf_range(0.045 * super_animatronic.treath_level,1.75) > 1:
		#player.game_over()
		Transitioned.emit(self, "InDesamblingRoom")
	else:
		pass
