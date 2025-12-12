extends Node3D
class_name animatronics

@onready var main = $"../../"
@export var animatronic_id = ""
var possible_rooms = []
var menace_level: int
var active:bool = false
var old_room

func _room_change(new_room):
	for room in possible_rooms:
		if room != new_room:
			RoomData.rooms_actual_data[room]["animatronics"][animatronic_id] = false
		elif room == new_room:
			RoomData.rooms_actual_data[room]["animatronics"][animatronic_id] = true
		if old_room == new_room:
			return
		elif old_room != new_room and old_room == RoomData.current_room:
			main._activate_static()
		elif new_room == RoomData.current_room:
			main._activate_static()
		main._reload_current_room(RoomData.current_room)
		if room == "main_room":
			main._animatronics_in_actual_room()
		old_room = new_room
		#print(RoomData.rooms_actual_data[room]["animatronics"][animatronic_id])
	return
