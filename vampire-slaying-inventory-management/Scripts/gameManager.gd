class_name GameManager
extends Node

static var instance : GameManager:
	get:
		if instance == null:
			instance = GameManager.new()
		return instance

enum Types { STRENGTH, AGILITY, INTELLIGENCE }

#signals
signal slayer_killed()
signal mission_spawned(mission: mission)
signal mission_completed(mission: mission)

@export var mission_scene : PackedScene
@export var mission_parent : Node

@export var FinalCountdown : Timer
@export var spawnInterval : Timer
var currentVamp : int = 0
var reputation : int
const MAX_SLAYERS : int = 10
var slayers : Array[slayer] = []
const MAX_ITEMS : int = 10
var items = []

@export var missionData : MissionData
@export var itemData : ItemData

var missions : Array[mission] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#TODO generate first slayer
	
	if (missions.size() <= slayers.size()):
		spawnInterval.timeout.connect(spawnMission)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#var mission_data := {
#			"ID": entry.get("ID", -1),
#			"Name": entry.get("Name", ""),
#			"Difficulty": _to_int(entry.get("Difficulty")),
#			"Lethality": entry.get("Lethality"),
#			"PrimaryStat": entry.get("PrimaryStat"),
#			"SecondaryStat": entry.get("SecondaryStat")
#		}

func spawnMission() -> void:
	var newMission = mission_scene.instantiate()
	var newMissionData : Dictionary
	#mission between 1 and 20
	if currentVamp == 0:
		newMissionData = missionData.get_item(randi_range(1, 20))
	#mission between 1 and 40
	if currentVamp == 1:
		newMissionData = missionData.get_item(randi_range(5, 40))
	#mission between 1 and 50
	if currentVamp == 2:
		newMissionData = missionData.get_item(randi_range(10, 50))
	#mission between 21 and 50
	if currentVamp == 3:
		newMissionData = missionData.get_item(randi_range(30, 50))
		
	#missionCompletionTimer
	newMission.missionCompletionTime = randf_range(newMission.missionCompletionTimeMin, newMission.missionCompletionTimeMax)
	#missionDifficulty
	newMission.missionDifficulty = newMissionData["Difficulty"]
	#missionName
	newMission.missionName = newMissionData["Name"]
	#primary and secondary stat
	newMission.primaryType = toType(newMissionData["PrimaryStat"])
	newMission.secondaryType = toType(newMissionData["SecondaryStat"])
	
	#TODO generate and set position
	newMission.position = Vector2(100,100)
	
	#add mission to mission array
	missions.append(newMission)
	
	#add mission to scene
	add_child(newMission)
	
func toType(type) -> Types:
	if type == "Agi":
		return Types.AGILITY
	elif type == "str":
		return Types.STRENGTH
	else:
		return Types.INTELLIGENCE
