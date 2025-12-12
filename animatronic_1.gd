extends animatronics
@export_range(0, 20) var treath_level : int = 1
var cam_change_speeds = [
	30.0, 
	29.0, 
	28.0, 
	27.0, 
	26.0, 
	25.0, 
	24.0, 
	23.0, 
	22.0, 
	21.5, 
	21.0, 
	20.5, 
	20.0, 
	18.5, 
	17.0, 
	15.5, 
	14.0, 
	13.0, 
	11.5, 
	10.0,
	3.0
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(0.04 * treath_level)
	possible_rooms = ["desambling_room", "office_room", "main_room"]
	#$"State Machine/Timer".start(cam_change_speeds[treath_level])
	treath_level = NightData.set_animatronic_treath_levels(animatronic_id)
	print(treath_level) 
