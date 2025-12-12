extends State
class_name InOfficeRoom

func Enter():
	pass

func move():
	if randf_range(0.045 * super_animatronic.treath_level,1.75) > 1:
		super_animatronic._room_change("office_room")
		Transitioned.emit(self, "InDesamblingRoom")
	else:
		super_animatronic._room_change("main_room")
		Transitioned.emit(self, "InMainRoom")
