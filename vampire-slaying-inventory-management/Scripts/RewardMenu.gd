class_name RewardMenu
extends Node2D

@onready var slot_1: ColorRect = $ColorRect/Slot1
@onready var slot_2: ColorRect = $ColorRect/Slot2
@onready var slot_3: ColorRect = $ColorRect/Slot3

@export var rewards := []
@onready var button_1: TextureButton = $ColorRect/Slot1/Button1
@onready var button_2: TextureButton = $ColorRect/Slot2/Button2
@onready var button_3: TextureButton = $ColorRect/Slot3/Button3


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
	
