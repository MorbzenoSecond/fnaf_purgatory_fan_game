extends Node

var nights_data = {
	"Night 1" : {
		"night_status" : false,
		"phone_guy_call" : "res://art/Sound_effects/ElevenLabs_2025-11-15T03_34_59_Roger_pre_sp91_s89_sb75_se0_b_m2.mp3",
		"animatronics_treath_level" : {
			"animatronic_1" : 1,
			"animatronic_2" : 1,
			"animatronic_3" : 0,
			"animatronic_4" : 0,
			"animatronic_5" : 0,
			"animatronic_6" : 0,
		}
	},
	"Night 2" : {
		"night_status" : false,
		"phone_guy_call" : "res://art/Sound_effects/ElevenLabs_2025-11-15T03_34_59_Roger_pre_sp91_s89_sb75_se0_b_m2.mp3",
		"animatronics_treath_level" : {
			"animatronic_1" : 20,
			"animatronic_2" : 4,
			"animatronic_3" : 6,
			"animatronic_4" : 2,
			"animatronic_5" : 9,
			"animatronic_6" : 0,
		}
	},
	"Night 3" : {
		"night_status" : false,
		"phone_guy_call" : "res://art/Sound_effects/ElevenLabs_2025-11-15T03_34_59_Roger_pre_sp91_s89_sb75_se0_b_m2.mp3",
		"animatronics_treath_level" : {
			"animatronic_1" : 1,
			"animatronic_2" : 4,
			"animatronic_3" : 6,
			"animatronic_4" : 2,
			"animatronic_5" : 9,
			"animatronic_6" : 0,
		}
	},
	"Night 4" : {
		"night_status" : false,
		"phone_guy_call" : "res://art/Sound_effects/ElevenLabs_2025-11-15T03_34_59_Roger_pre_sp91_s89_sb75_se0_b_m2.mp3",
		"animatronics_treath_level" : {
			"animatronic_1" : 1,
			"animatronic_2" : 4,
			"animatronic_3" : 6,
			"animatronic_4" : 2,
			"animatronic_5" : 9,
			"animatronic_6" : 0,
		}
	},
}

var first_enter:bool = false
var current_night : String = "night 1"

func get_current_night():
	for night_name in nights_data.keys():
		#print(nights_data[night_name]["night_status"])
		if !nights_data[night_name]["night_status"]:
			current_night = night_name
			#print(current_night)
			get_animatronic_treath_levels()
			break;

func get_animatronic_treath_levels():
	var animatronics_in_nights = nights_data[current_night]["animatronics_treath_level"].keys()

	for animatronics_in_night in animatronics_in_nights:
		pass
		#print("el animatronico: ", animatronics_in_night, " tiene un nivel de amenaza: ", nights_data[current_night]["animatronics_treath_level"][animatronics_in_night])

func set_animatronic_treath_levels(animatronic):
	return nights_data[current_night]["animatronics_treath_level"][animatronic]

func _ready() -> void:
	get_current_night()
	
const SAVE_PATH = "res://game_file/save_file.json"
func save():
	var file = FileAccess.open(SAVE_PATH,FileAccess.WRITE)
	file.store_string(JSON.stringify(nights_data))
	file.close()

func load_data():
	if not FileAccess.file_exists(SAVE_PATH):
		save()
		await save()
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	file.close()
	if json:
		nights_data = json
	else:
		return
