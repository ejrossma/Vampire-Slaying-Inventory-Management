extends Node2D

@export var mute: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
		
	pass # Replace with function body.

func play_MainMenuMusic():
		if not mute:
				$MainMenuMusic.play()
func stop_MainMenuMusic():
		if not mute:
				$MainMenuMusic.stop()
func play_Pause():
		if not mute:
				#$Pause.play()
				return
func play_Unpause():
		if not mute:
				#$UnPause.play()
				return
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
