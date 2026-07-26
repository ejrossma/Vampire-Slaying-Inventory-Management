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
func play_PickUp():
		if not mute:
				$PickUp.play()
				
func play_Drop():
		if not mute:
				$Drop.play()
func play_Missionfail():
		if not mute:
				$MissionFail.play()
func play_UISelect():
		if not mute:
				$UiSelect.play()	
func play_DraculaReveal():
		if not mute:
				$DraculaReveal.play()
func play_EclipseMusic():
		if not mute:
				$EclipseMusic.play()
func stop_EclipseMusic():
		if not mute:
				$EclipseMusic.stop()
func play_GameWin():
		if not mute:
			$GameWin.play()
func play_GameOver():
		if not mute:
			$GameOver.play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
