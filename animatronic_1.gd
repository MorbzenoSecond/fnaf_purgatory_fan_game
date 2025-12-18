extends animatronics
@export_range(0, 20) var treath_level : int = 1

var cam_change_speeds = [
	3, 
	3, 
	3,
	3, 
	3, 
	3, 
	3, 
	3,
	3, 
	3, 
	3, 
	3, 
	3, 
	3, 
	3,
	3, 
	3, 
	3,
	3, 
	3, 
	3,
	3.0
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	possible_rooms = ["desambling_room", "office_room", "main_room", "ventilations"]

	treath_level = NightData.set_animatronic_treath_levels(animatronic_id)

	timer.wait_time = cam_change_speeds[treath_level] / 3
	timer.start()

#func _process(delta: float) -> void:
	##super._process(delta)
	#if timer.time_left > 0:
		#print("Timer corriendo:", timer.time_left)
