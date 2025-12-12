extends Area3D

signal goto_room(path, path_id)
signal goto_main

@onready var path_id
@onready var parent = $"../../"
@onready var sprite = $Sprite3D
enum room_scene {office_room, desambling_room, rearm_room} 
@export var roomScene: room_scene = room_scene.office_room
var room_data =  {
	"office_room":{
		"path_id" : "office_room",
		"scene_path" : "res://rooms/room_1.tscn"
	},
	"desambling_room":{
		"path_id" : "desambling_room",
		"scene_path" : "res://rooms/room_2.tscn"
	},
	"rearm_room":{
		"path_id" : "rearm_room",
		"scene_path" : "res://rooms/room_3.tscn"
	},
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Room_key(roomScene)

func Room_key(scene_index) -> String:
	match scene_index:
		room_scene.office_room:
			return "office_room"
		room_scene.desambling_room:
			return "desambling_room"
		room_scene.rearm_room:
			return "rearm_room"
	return ""

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouse and Input.is_action_just_pressed("izq_click"):
		transition()

func transition():
	var key = Room_key(roomScene)
	var selected_room = room_data[key]
	parent._on_transition_entered(
		selected_room["scene_path"], 
		selected_room["path_id"]
	)

func get_path_id() -> String:
	var key = Room_key(roomScene)
	var selected_room = room_data[key]
	return selected_room["path_id"]
