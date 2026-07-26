class_name GameManager
extends Node

static var instance : GameManager:
	get:
		if instance == null:
			instance = GameManager.new()
		return instance

#signals
signal slayer_killed()
signal mission_spawned(mission: mission)
signal mission_completed(mission: mission)
signal mission_expired(mission: mission)

@export var slayerSlots : Node2D
@export var inventorySlots : Node2D

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
	
	spawnInterval.timeout.connect(spawnMission)
	mission_expired.connect(removeMission)
	mission_completed.connect(completeMission)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawnMission() -> void:
	if (missions.size() > slayers.size()):
		return
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
	
	#call missionintialsetup
	newMission.initialMissionSetup()
	#TODO generate and set position
	newMission.position = generateMissionLocation()
	#add mission to mission array
	missions.append(newMission)
	#add mission to scene
	mission_parent.add_child(newMission)
	
func toType(type) -> mission.Types:
	if type == "Agi":
		return mission.Types.AGILITY
	elif type == "Str":
		return mission.Types.STRENGTH
	else:
		return mission.Types.INTELLIGENCE
		
func generateMissionLocation() -> Vector2:
	return Vector2(randf_range(270, 1020), randf_range(125, 335))
	
func removeMission(missionToErase) -> void:
	missions.erase(missionToErase)

func completeMission(missionCompleted) -> void:
	missions.erase(missionCompleted)
	#TODO Show rewards screen
