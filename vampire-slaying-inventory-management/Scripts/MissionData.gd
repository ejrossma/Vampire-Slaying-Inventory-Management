class_name MissionData
extends Node

static var _instance: MissionData

static var instance: MissionData:
	get:
		if _instance == null:
			_instance = MissionData.new()
		return _instance

var file_path : String = "res://Scripts/The Count is Down Missions - Sheet1 (1).json"
var missionData : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_instance = self
	load_json_file(file_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_json_file(file_path: String) -> void:
	var file := FileAccess.open(file_path, FileAccess.READ)
	var text := file.get_as_text()
	file.close()
	
	var parsedText = JSON.parse_string(text)
	for entry in parsedText:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		
		var mission_data := {
			"ID": entry.get("ID", -1),
			"Name": entry.get("Name", ""),
			"Difficulty": _to_int(entry.get("Difficulty")),
			"Lethality": entry.get("Lethality"),
			"PrimaryStat": entry.get("PrimaryStat"),
			"SecondaryStat": entry.get("SecondaryStat")
		}
		
		var id : int = mission_data["ID"]
		missionData[id] = mission_data

func _to_int(value) -> int:
	if value == null:
		return 0
	return int(value)

func get_item(id: int) -> Dictionary:
	return missionData.get(id, {})
