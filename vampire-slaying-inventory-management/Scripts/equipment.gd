class_name equipment
extends Node2D

var inventory_index : int
var equipment_name : String

var Strength : int
var Agility : int
var Intelligence : int

@export var equipmentSprite : TextureRect
var equipmentTexture : Texture

@export var NameLabel : Label
@export var IntelligenceLabel : Label
@export var StrengthLabel : Label
@export var AgilityLabel : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateCard()
	pass # Replace with function body.

func getStat(stat : String) -> int:
	if stat == "STRENGTH":
		return Strength
	elif stat == "AGILITY":
		return Agility
	else:
		return Intelligence
	
func incrStat(stat: String) -> void:
	match stat:
		mission.Types.STRENGTH:
			Strength += 1
		mission.Types.AGILITY:
			Agility += 1
		mission.Types.INTELLIGENCE:
			Intelligence += 1
	updateCard()
	return
		
func assignStats(stats: Vector3i) -> void:
	Strength = stats.x
	Agility = stats.y
	Intelligence = stats.z

func updateCard() -> void:
	IntelligenceLabel.text = str(getStat("INTELLIGENCE"))
	StrengthLabel.text = str(getStat("STRENGTH"))
	AgilityLabel.text = str(getStat("AGILITY"))
	NameLabel.text = equipment_name
	equipmentSprite.texture = equipmentTexture

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button.index == MOUSE_BUTTON_LEFT and event.pressed:
			GameManager.click(self)
