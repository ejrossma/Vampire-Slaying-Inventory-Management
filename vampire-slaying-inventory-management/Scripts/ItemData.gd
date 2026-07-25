class_name ItemData
extends Node

static var _instance: ItemData

static var instance: ItemData:
	get:
		if _instance == null:
			_instance = ItemData.new()
		return _instance

var file_path : String = "res://Scripts/The Count is Down Equipment - Sheet1 (5).json"
var itemData : Dictionary = {}

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
		
		var item_data := {
			"ID": entry.get("ID", -1),
			"Item": entry.get("Item", ""),
			"StrStat": _to_int(entry.get("StrStat")),
			"IntStat": _to_int(entry.get("IntStat")),
			"AgiStat": _to_int(entry.get("AgiStat")),
			"TotalEffectiveStats": _to_int(entry.get("TotalEffectiveStats")),
			"Rarity": entry.get("Rarity", "Common")
		}
		
		var id : int = item_data["ID"]
		itemData[id] = item_data

func _to_int(value) -> int:
	if value == null:
		return 0
	return int(value)

func get_item(id: int) -> Dictionary:
	return itemData.get(id, {})
