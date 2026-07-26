class_name slayer
extends Node2D

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


#drag and drop
var draggable = false
var is_inside_droppable = false
var body_ref
var offset : Vector2
var initialPos : Vector2

func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			offset = get_global_mouse_position() - global.position
			global.is_dragging = true
		
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			global.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_droppable and is_instance_valid(body_ref):
				tween.tween_property(self, "global_position", body_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_entered() -> void:
	if not global.is_dragging:
		draggable = true
		scale = Vector2(2.1, 2.1)

func _on_area_2d_mouse_exited() -> void:
	if not global.is_dragging:
		draggable = false
		scale = Vector2(2,2)

func _on_area_2d_body_entered(body: StaticBody2D) -> void:
	if body.is_in_group("droppable"):
		is_inside_droppable = true
		body.modulate = Color(Color.GRAY, 0.85)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("droppable") && body_ref == body:
		is_inside_droppable = false
		body.modulate = Color(Color.GRAY, 0.7)
