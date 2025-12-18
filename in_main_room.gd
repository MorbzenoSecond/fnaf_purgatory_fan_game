extends State
class_name InMainRoom
@onready var player = $"../../../.."

func Enter():
	pass

func move():
	if randf_range(0.045 * super_animatronic.treath_level,1.75) > 1:
		#player.game_over()
		super_animatronic._ventilation_enter("animatronic_1", "E1_E3", false, 7)
		await get_tree().process_frame
		Transitioned.emit(self, "InVentilationE1_E2")
	pass
