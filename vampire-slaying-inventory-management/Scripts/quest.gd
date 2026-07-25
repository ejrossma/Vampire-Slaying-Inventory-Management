class_name quest
extends Node2D

enum Types { None, STRENGTH, AGILITY, INTELLIGENCE }

@export var favoredType : Types
@export var favoredTypeMult : int
@export var secondaryType : Types
@export var secondaryTypeMult : int
@export var duration : Timer
@export var waitTime : Timer
@export var successThreshold : int

var assignedCharacter : Adventurer
var assignedItems := []

var cardsRewarded : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	waitTime.timeout.connect(questExpired)
	duration.time.connect(calculateSuccess)
	$StartQuest.pressed.connect(startQuest)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func startQuest() -> void:
	if assignedCharacter != null:
		waitTime.stop()
		duration.start()

func questExpired() -> void:
	queue_free()

func calculateSuccess(assignedCharacter, assignedEquipment) -> int:
	if randi_range(1,6) + (favoredTypeMult * assignedCharacter.getStat(favoredType)) + (secondaryTypeMult * assignedCharacter.getStat(secondaryType)) > successThreshold:
		return cardsRewarded
	return 0
	
