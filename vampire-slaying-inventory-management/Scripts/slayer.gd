class_name Adventurer
extends Node
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
		quest.Types.STRENGTH:
			return Strength
		quest.Types.AGILITY:
			return Agility
		quest.Types.INTELLIGENCE:
			return Intelligence
	return 0
