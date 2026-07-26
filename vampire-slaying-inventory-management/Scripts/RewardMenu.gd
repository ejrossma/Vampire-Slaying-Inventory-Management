class_name RewardMenu
extends Node2D

@export var slot_1: TextureRect
@export var slot_2: TextureRect
@export var slot_3: TextureRect

@export var rewards := []
@export var button_1: Button
@export var button_2: Button
@export var button_3: Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_1.pressed.connect(pickFirst)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func populateSlots() -> void:
	rewards = []
	
	var equipment1: equipment = GameManager.instance.generateEquipment()
	slot_1.add_child(equipment1)
	equipment1.position =  Vector2.ZERO
	rewards.append(equipment1)
	
	var equipment2: equipment = GameManager.instance.generateEquipment()
	slot_2.add_child(equipment2)
	equipment2.position = Vector2.ZERO
	rewards.append(equipment2)
	
	var equipment3: equipment = GameManager.instance.generateEquipment()
	slot_3.add_child(equipment3)
	equipment3.position = Vector2.ZERO
	rewards.append(equipment3)

func pickFirst() -> void:
	print(rewards[0])
	
