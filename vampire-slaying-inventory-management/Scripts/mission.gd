class_name mission
extends Node2D

enum Types { STRENGTH, AGILITY, INTELLIGENCE }

@export var StartQuest : TextureButton

#colors
@export var green : Color
@export var yellow : Color
@export var red : Color
@export var gray : Color

#popup
@onready var mission_popup: Sprite2D = $MissionPopup
@onready var mission_ping: TextureProgressBar = $MissionPing
@onready var ping_button: TextureButton = $MissionPing/TextureButton
var wasClicked : bool = false
var started : bool = false
var initialDuration : float
@export var lethal_markers: Node2D

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

#mission lethality
var isLethal : bool

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

#mission stats
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

#missionSuccess
var missionSuccess : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#setup mission wait time before expiration
	waitTime.wait_time = waitTimeLength
	waitTime.timeout.connect(questExpired)
	
	#setup mission completion timer
	missionCompletionTimer.timeout.connect(calculateSuccess)
	
	StartQuest.pressed.connect(startQuest)
	mission_popup.visible = false
	wasClicked = false
	ping_button.pressed.connect(toggleMenu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if started == false:
		mission_ping.value = (waitTime.time_left / 15) * 100
	else:
		mission_ping.value = (missionCompletionTimer.time_left / missionCompletionTime) * 100

func startQuest() -> void:
	if assignedCharacter != null:
		waitTime.stop()
		started = true
		mission_ping.tint_progress = Color(0, .7, 0)
		missionCompletionTimer.start()
		toggleMenu()

func questExpired() -> void:
	#if there is a slayer in the quest the quest gets started
	
	#else it dissappears
	GameManager.instance._on_mission_expired.emit(self)
	queue_free()

func updateSuccessPercentage(assignedCharacter, assignedEquipment) -> int:
	return assignedCharacter.getStat(primaryType) + (assignedCharacter.getStat(secondaryType) * secondaryTypeMult)
	#success
	
#calculate if successful or not
func calculateSuccess() -> void:
	if randf() < successChance:
		missionSuccess = true
	else:
		missionSuccess = false
	GameManager.instance.mission_completed.emit(self)
	#TODO destroy gear

#TODO add visual
func assignSlayer(char: slayer) -> void:
	#add stats to mission
	assignedCharacter = char
	strengthStat += char.Strength
	agilityStat += char.Agility
	intelligenceStat += char.Intelligence
	updateMissionInfo()

#TODO remove visual
func unassignSlayer(char: slayer) -> void:
	#remove stats from mission
	assignedCharacter = null
	strengthStat -= char.Strength
	agilityStat -= char.Agility
	intelligenceStat -= char.Intelligence
	updateMissionInfo()

#TODO add visual
func assignEquipment(item: equipment, equipmentSlot) -> void:
	match equipmentSlot:
		1:
			assignedEquipmentOne = item
		2:
			assignedEquipmentTwo = item
		3:
			assignedEquipmentThree = item
	#add stats to mission
	strengthStat += item.Strength
	agilityStat += item.Agility
	intelligenceStat += item.Intelligence
	updateMissionInfo()

#TODO remove visual
#need to signify which slot it is taken from
func unassignEquipment(item: equipment, equipmentSlot) -> void:
	match equipmentSlot:
		1:
			assignedEquipmentOne = item
		2:
			assignedEquipmentTwo = item
		3:
			assignedEquipmentThree = item
	#remove stats to mission
	strengthStat -= item.Strength
	agilityStat -= item.Agility
	intelligenceStat -= item.Intelligence
	updateMissionInfo()

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

func updateMissionInfo() -> void:
	strengthLabel.text = str(strengthStat)
	agilityLabel.text = str(agilityStat)
	intelligenceLabel.text = str(intelligenceStat)
	if assignedCharacter:
		slayerCard = assignedCharacter.slayerSprite
	if assignedEquipmentOne:
		equipmentOneCard = assignedEquipmentOne.equipmentSprite
	if assignedEquipmentTwo:
		equipmentTwoCard = assignedEquipmentTwo.equipmentSprite
	if assignedEquipmentThree:
		equipmentThreeCard = assignedEquipmentThree.equipmentSprite

func setMissionCompletionTime() -> void:
	missionCompletionTimeLabel.text = str(int(missionCompletionTime))
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
		lethal_markers.visible = isLethal

func toggleMenu() -> void:
	mission_popup.visible = !mission_popup.visible
	wasClicked = true

func _on_static_body_2d_input_event_slayer(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Slayer Clicked")
			if GameManager.instance.selected_item:
				GameManager.instance.assign(self, 0)
			
			#if want to remove a character or item from the mission
			#elif assignedCharacter and not GameManager.instance.selected_item:
				#GameManager.instance.selected_item = assignedCharacter
				#assignedCharacter = null
			#else


func _on_static_body_2d_input_event_item_one(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Equipment 1 Clicked")
			if GameManager.instance.selected_item:
				GameManager.instance.assign(self, 1)


func _on_static_body_2d_input_event_item_two(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if GameManager.instance.selected_item:
				GameManager.instance.assign(self, 2)


func _on_static_body_2d_input_event_item_three(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if GameManager.instance.selected_item:
				GameManager.instance.assign(self, 3)
