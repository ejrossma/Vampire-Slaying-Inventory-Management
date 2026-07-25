class_name GameManager
extends Node

static var instance : GameManager:
	get:
		if instance == null:
			instance = GameManager.new()
		return instance

#signals
signal slayer_killed()
signal mission_spawned(mission: mission)
signal mission_completed(mission: mission)

@export var FinalCountdown : Timer
@export var spawnInterval : Timer
var currentVamp : int = 0
var reputation : int
const MAX_SLAYERS : int = 10
var slayers : Array[slayer] = []
const MAX_ITEMS : int = 10
var items = []

var mission_scene: PackedScene
var missions : Array[mission] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnInterval.timeout.connect(spawnMission)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawnMission() -> void:
	pass
			
