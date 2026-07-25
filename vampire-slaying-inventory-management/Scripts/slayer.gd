class_name slayer
extends Node

var ID : int
var slayer_name : String

@export var Strength : int
@export var Agility : int
@export var Intelligence : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getStat(stat : String) -> int:
	match stat:
		mission.Types.STRENGTH:
			return Strength
		mission.Types.AGILITY:
			return Agility
		mission.Types.INTELLIGENCE:
			return Intelligence
	return 0
	
func incrStat(stat: String) -> void:
	match stat:
		mission.Types.STRENGTH:
			Strength += 1
		mission.Types.AGILITY:
			Agility += 1
		mission.Types.INTELLIGENCE:
			Intelligence += 1
	return
		
