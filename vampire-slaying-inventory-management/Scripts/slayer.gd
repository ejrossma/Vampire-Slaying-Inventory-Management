class_name slayer
extends Node

var ID : int
var slayer_name : String

var Strength : int
var Agility : int
var Intelligence : int

@export var slayerSprite : TextureRect
var slayerTexture : Texture

@export var NameLabel : Label
@export var IntelligenceLabel : Label
@export var StrengthLabel : Label
@export var AgilityLabel : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateCard()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	NameLabel.text = slayer_name
	slayerSprite.texture = slayerTexture
