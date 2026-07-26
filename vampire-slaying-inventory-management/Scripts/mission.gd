class_name mission
extends Node2D

enum Types { STRENGTH, AGILITY, INTELLIGENCE }

#time before expiration
@export var waitTime : Timer
@export var waitTimeLength : float

#mission types
@export var primaryType : Types
@export var secondaryType : Types

#mission name
@export var missionNameLabel : Label
var missionName : String

#mission completion time
@export var missionCompletionTimeLabel : Label
@export var missionCompletionTimeBackground: ColorRect
@export var missionCompletionTimer : Timer
@export var missionCompletionTimeMax : float
@export var missionCompletionTimeMin : float
var missionCompletionTime : float


#mission difficulty
@export var missionDifficultyLabel : Label
@export var missionDifficultyBackground : ColorRect
var missionDifficulty : String

#success chance
@export var successChanceLabel : Label
@export var successChanceBackground : ColorRect
var successChance : float
var successThreshold : float
var secondaryTypeMult = 0.5

#slayer stats
@export var primaryBorder : Texture2D
@export var secondaryBorder : Texture2D
@export var strengthLabel : Label
@export var agilityLabel : Label
@export var intelligenceLabel : Label
@export var strengthBorder : TextureRect
@export var agilityBorder : TextureRect
@export var intelligenceBorder : TextureRect
var strengthStat : int
var agilityStat : int
var intelligenceStat : int

#slayer
@export var slayerCard : TextureRect
var assignedCharacter : slayer

#equipment
@export var equipmentOneCard : TextureRect
var assignedEquipmentOne : equipment
@export var equipmentTwoCard : TextureRect
var assignedEquipmentTwo : equipment
@export var equipmentThreeCard : TextureRect
var assignedEquipmentThree : equipment

#card rewards
var cardsRewarded : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#setup mission wait time before expiration
	waitTime.wait_time = waitTimeLength
	waitTime.timeout.connect(questExpired)
	
	#setup mission completion timer
	missionCompletionTimer.wait_time = randf_range(missionCompletionTimeMin, missionCompletionTimeMax)
	missionCompletionTimer.timeout.connect(calculateSuccess)
	
	$StartQuest.pressed.connect(startQuest)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func startQuest() -> void:
	if assignedCharacter != null:
		waitTime.stop()
		missionCompletionTimer.start()

func questExpired() -> void:
	#if there is a slayer in the quest the quest gets started
	
	#else it dissappears
	queue_free()

func updateSuccessPercentage(assignedCharacter, assignedEquipment) -> int:
	return assignedCharacter.getStat(primaryType) + (assignedCharacter.getStat(secondaryType) * secondaryTypeMult)
	#success
	
#calculate if successful or not
func calculateSuccess() -> bool:
	if randf(0, 1) < successChance:
		pass
	#failure
	else:
		#check if lethal or nonlethal mission
		#destroy gear
		pass
	
func assignSlayer() -> void:
	#add stats to mission
	
	#update slayer TextureRect with slayer card
	pass
	
func unassignSlayer() -> void:
	#remove stats from mission
	pass
	
#need to signify which slot it is in
func assignEquipment() -> void:
	#add stats to mission
	pass

#need to signify which slot it is taken from
func unassignEquipment() -> void:
	#remove stats from mission
	pass

func initialMissionSetup() -> void:
	#mission completion time
	
	pass
	
func updateMissionInfo() -> void:
	
	pass
