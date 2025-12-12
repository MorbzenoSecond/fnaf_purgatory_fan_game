extends State
class_name InDesamblingRoom

func Enter():
	pass

func move():
	if randf_range(0.045 * super_animatronic.treath_level, 1.75) > 1:
		super_animatronic._room_change("office_room")
		Transitioned.emit(self, "InOfficeRoom")
	else:
		pass
