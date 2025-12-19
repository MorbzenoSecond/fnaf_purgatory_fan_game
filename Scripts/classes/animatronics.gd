extends Node3D
class_name animatronics

@onready var main = $"../../"
@onready var timer = $"State Machine/Timer"
@export var animatronic_id = ""


var possible_rooms = []
var menace_level: int
var active:bool = false
var in_ventilation = false
var old_room

func _room_change(new_room: String) -> void:
	# 1. Si no hubo cambio, salimos
	if new_room == old_room:
		return

	# 2. Actualizar estado del animatrónico en todas las habitaciones
	for room in possible_rooms:
		RoomData.rooms_actual_data[room]["animatronics"][animatronic_id] = (room == new_room)

	# 3. Estado especial para main_room
	var in_main_room := new_room == "main_room"
	RoomData.rooms_actual_data["main_room"]["animatronics"
	
	][animatronic_id] = in_main_room

	main._animatronics_in_actual_room()

	# 4. Activar estática si entra o sale de la habitación actual
	if old_room == RoomData.current_room or new_room == RoomData.current_room:
		main._activate_static()

	# 5. Recargar habitación
	main._reload_current_room(RoomData.current_room)

	# 6. Actualizar old_room
	old_room = new_room

func _ventilation_enter(animatronic_id : String, choosen_path : String, reverse : bool, time_spend : float ):
	if old_room == RoomData.current_room:
		main._activate_static()

	for room in possible_rooms:
		RoomData.rooms_actual_data[room]["animatronics"][animatronic_id]  = false

	main._animatronics_in_actual_room()
	main._reload_current_room(RoomData.current_room)

	main._ventilation_update(animatronic_id, choosen_path, reverse, time_spend)

func _process(delta: float) -> void:
	if Input.is_action_pressed("izq_click"):
		start_decision_timer()

func start_decision_timer():
	timer.start()

func stop_decision_timer():
	timer.stop()
