extends Node2D


@onready var timer: Timer = $Timer
@onready var fill: TextureProgressBar = $TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill.value = 100.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fill.value = clamp(timer.time_left / 300, 0.0, 1.0) * 100.0
	
