class_name mission
extends Node2D

enum Types { STRENGTH, AGILITY, INTELLIGENCE }

@export var StartQuest : TextureButton

#colors
@export var green : Color
@export var yellow : Color
@export var red : Color
@export var gray : Color

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
var missionDifficulty : int

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
var strengthStat = 0
var agilityStat = 0
var intelligenceStat = 0

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
	#TODO missionCompletionTimer.timeout.connect(calculateSuccess)
	
	StartQuest.pressed.connect(startQuest)


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
#TODO func calculateSuccess() -> bool:
	#success
#	if randf(0, 1) < successChance:
#		pass
	
	#failure
#	else:
		#check if lethal or nonlethal mission
		#destroy gear
#		pass
	
#TODO
func assignSlayer() -> void:
	#add stats to mission
	
	#update slayer TextureRect with slayer card
	pass
	
func unassignSlayer() -> void:
	#remove stats from mission
	assignedCharacter = null
	#TODO remove visual
	updateMissionInfo()
	pass

#TODO
#need to signify which slot it is in
func assignEquipment(equipmentSlot) -> void:
	#add stats to mission
	
	pass

#need to signify which slot it is taken from
func unassignEquipment(equipmentSlot) -> void:
	#remove stats from mission
	equipmentSlot = null
	#TODO remove visual
	updateMissionInfo()
	pass

#TODO
func initialMissionSetup() -> void:
	#mission completion time
	setMissionCompletionTime()
	#mission name
	missionNameLabel.text = missionName
	#mission difficulty
	setMissionDifficulty()
	#mission primary and secondary stat
	setMissionPrimarySecondary()
	#mission lethality
	setMissionLethality()

#TODO
func updateMissionInfo() -> void:
	
	pass

func setMissionCompletionTime() -> void:
	missionCompletionTimeLabel.text = str(missionCompletionTime)
	if missionCompletionTime < 11:
		missionCompletionTimeBackground.color = green
	elif missionCompletionTime < 16:
		missionCompletionTimeBackground.color = yellow
	else:
		missionCompletionTimeBackground.color = red
	
func setMissionDifficulty() -> void:
	if missionDifficulty == 0:
		missionDifficultyBackground.color = green
		missionDifficultyLabel.text = "EAS"
	elif missionDifficulty == 1:
		missionDifficultyBackground.color = yellow
		missionDifficultyLabel.text = "MED"
	else:
		missionCompletionTimeBackground.color = red
		missionDifficultyLabel.text = "HAR"

func setMissionPrimarySecondary() -> void:
	#primary
	if primaryType == Types.STRENGTH:
		strengthBorder.visible = true
		strengthBorder.texture = primaryBorder
	elif primaryType == Types.AGILITY:
		agilityBorder.visible = true
		agilityBorder.texture = primaryBorder
	else:
		intelligenceBorder.visible = true
		intelligenceBorder.texture = primaryBorder
	
	#secondary
	if secondaryType == Types.STRENGTH:
		strengthBorder.visible = true
		strengthBorder.texture = secondaryBorder
	elif secondaryType == Types.AGILITY:
		agilityBorder.visible = true
		agilityBorder.texture = secondaryBorder
	else:
		intelligenceBorder.visible = true
		intelligenceBorder.texture = secondaryBorder
	
func setMissionLethality() -> void:
	return
	
