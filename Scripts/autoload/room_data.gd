extends Node

var rooms_actual_data = {
	"main_room":{
		"animatronics" : {
			"animatronic_1" : false,
			"animatronic_2" : false
		},
	},
	"office_room":{
		"animatronics" : {
			"animatronic_1" : false,
			"animatronic_2" : true
		},
	},
	"desambling_room":{
		"animatronics" : {
			"animatronic_1" : false,
			"animatronic_3" : false,
			"animatronic_6" : false
		},
	},
	"rearm_room":{
		"animatronics" : {
			"animatronic_1" : true,
			"animatronic_4" : true
		},
	},
}

var current_room = "office_room"


func get_animatronic_room_location(label_animatronic)->String:
	for room in rooms_actual_data.keys():
		for animatronic in rooms_actual_data[room]["animatronics"]:
			if rooms_actual_data[room]["animatronics"][animatronic]:
				if animatronic == label_animatronic:
					return str(animatronic, ": ", room)
	return ""

func get_animatronic_room_locations()->String:
	for room in rooms_actual_data.keys():
		for animatronic in rooms_actual_data[room]["animatronics"]:
			if rooms_actual_data[room]["animatronics"][animatronic]:
				return str(rooms_actual_data[room]["animatronics"][animatronic])
	return ""

# Called when the node enters the scene tree for the first time.
func get_room_by_name(room_name):
	if room_name in rooms_actual_data:
		return rooms_actual_data[room_name]
	return
