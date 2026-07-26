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

@export var slayer_scene : PackedScene
@export var equipment_scene : PackedScene
@export var card_reward_parent : Node2D

@export var mission_scene : PackedScene
@export var mission_parent : Node

@export var FinalCountdown : Timer
@export var spawnInterval : Timer
var currentVamp : int = 0
var reputation : int = 0
var repToNextSlayer : int = 30
const MAX_SLAYERS : int = 10
var slayers : Array[slayer] = []
const MAX_ITEMS : int = 10
var items = []

@export var missionData : MissionData
@export var itemData : ItemData

var missions : Array[mission] = []

@export var slayerSprites : Array[Texture2D]
@export var equipmentSprites : Array[Texture2D]

var slayerNames := [
	"John",
	"Joe",
	"Bob",
	"George",
	"Frank",
	"Brian",
	"Nate",
	"Kelly",
	"Evan",
	"Thomas",
	"Jose",
	"Adam",
	"Travis",
	"Scott",
	"Ethan",
	"Ulrich",
	"Trevor",
	"Tony",
	"Ely",
	"Jaxon",
	"Drake",
	"Brock",
	"Christian",
	"LeSlayer",
	"Geralt",
	"Davion",
	"Matilda",
	"Beth",
	"Genevieve",
	"Margery",
	"Aveline",
	"Eleanor",
	"Elie",
	"Isabel",
	"Adelaide",
	"Kaladin",
	"Shallan",
	"Adolin",
	"Navani",
	"Dalinar"
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#TODO generate first slayer
	
	spawnInterval.timeout.connect(spawnMission)
	mission_expired.connect(removeMission)
	mission_completed.connect(completeMission)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Card Reward Functions -----------------------------------
func generateCardRewards() -> void:
	return

#Equipment Functions -------------------------------------
func generateEquipment() -> equipment:
	#instantiate an equipment
	var newEquipment = equipment_scene.instantiate()
	#select item
	var newEquipmentData = selectEquipment()
	#set name
	newEquipment.equipment_name = newEquipmentData["Item"]
	#set stats
	newEquipment.assignStats(Vector3i(newEquipment["StrStat"], newEquipment["AgiStat"], newEquipment["IntStat"]))
	#set sprite
	newEquipment.equipmentTexture = equipmentSprites[newEquipment["ID"] - 1]
	#update visuals
	newEquipment.updateCard()
	#assign parent
	#card_reward_parent.add_child(newEquipment)
	return newEquipment
	
func selectEquipment() -> Dictionary:
	var chosenEquipment : Dictionary
	
	#0-10 common, #11-15 uncommon, #16-19 rare, #20 mythic
	var rarity = randi_range(0, 20)
	if rarity < 11:
		while chosenEquipment.Rarity != "Common":
			chosenEquipment = itemData.get_item(randi_range(1, 18))
	elif rarity < 16:
		while chosenEquipment.Rarity != "Uncommon":
			chosenEquipment = itemData.get_item(randi_range(1, 18))
	elif rarity < 20:
		while chosenEquipment.Rarity != "Rare":
			chosenEquipment = itemData.get_item(randi_range(1, 18))
	else:
		chosenEquipment = itemData.get_item(19)
	
	return chosenEquipment

#Slayer Functions ----------------------------------------
func generateSlayer() -> slayer:
	#instantiate a slayer
	var newSlayer = slayer_scene.instantiate()
	#select name
	newSlayer.slayer_name = slayerNames.pick_random()
	#generate stats
	newSlayer.assignStats(generateSlayerStats())
	#select sprite
	newSlayer.slayerTexture = slayerSprites.pick_random()
	#update visuals
	newSlayer.updateCard()
	#assign parent
	#card_reward_parent.add_child(newSlayer)
	return newSlayer
	
func generateSlayerStats() -> Vector3i:
	var slayerStats = Vector3i(1 + currentVamp, 1 + currentVamp, 1 + currentVamp)
	var statsToAssign = 3 + currentVamp
	
	while statsToAssign > 0:
		var statToIncrease = randi_range(0, 2)
		match statToIncrease:
			0:
				slayerStats.x += 1
			1:
				slayerStats.y += 1
			2:
				slayerStats.z += 1
		statsToAssign -= 1
	
	return slayerStats

#Mission Functions ---------------------------------------
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
	return Vector2(randf_range(270, 1020), randf_range(125, 240))
	
func removeMission(missionToErase) -> void:
	missions.erase(missionToErase)

func completeMission(missionCompleted) -> void:
	#check if the mission was successful or failed
	if missionCompleted.missionSuccess:
		reputation += 5 * missionCompleted.missionDifficulty + 10
		if (reputation > repToNextSlayer and slayers.size() < 9):
			#reduce current rep to start working towards next slayer
			reputation -= repToNextSlayer
			#increase amount needed
			repToNextSlayer += 20
			#TODO add slayer reward to rewards
		#TODO Show rewards screen
	else:
		#TODO Check for lethality
		pass
	#remove the mission from mission array
	missions.erase(missionCompleted)
	
	
