extends State
class_name InVentilationE1_E2
@onready var player = $"../../../.."

func Enter():
	super_animatronic.stop_decision_timer()
	move()

func move():
	await get_tree().create_timer(7).timeout

	super_animatronic.start_decision_timer()
	super_animatronic._room_change("desambling_room")
	Transitioned.emit(self, "InDesamblingRoom")
