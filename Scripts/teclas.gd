extends CanvasLayer
@onready var animatronic_1 = $"Animatronic 1 data"
@onready var animatronic_2 = $"Animatronic 2 data"
@onready var animatronic_3 = $"Animatronic 3 data"

func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	animatronic_1.text = RoomData.get_animatronic_room_location("animatronic_1")
	animatronic_2.text = RoomData.get_animatronic_room_location("animatronic_2")
	animatronic_3.text = RoomData.get_animatronic_room_location("animatronic_3")
	if Input.is_action_pressed("ui_up"):
		$up.animation="click"
	if !Input.is_action_pressed("ui_up"):
		$up.animation="default"

	if Input.is_action_pressed("ui_left"):
		$left.animation="click"
	if !Input.is_action_pressed("ui_left"):
		$left.animation="default"

	if Input.is_action_pressed("ui_right"):
		$right.animation="click"
	if !Input.is_action_pressed("ui_right"):
		$right.animation="default"

	if Input.is_action_pressed("ui_down"):
		$down.animation="click"
	if !Input.is_action_pressed("ui_down"):
		$down.animation="default"
	
	
