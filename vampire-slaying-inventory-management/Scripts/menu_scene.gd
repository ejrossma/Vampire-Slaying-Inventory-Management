extends CanvasLayer

@export var instructionsPage : ColorRect
func _ready():	
	AudioManager.play_MainMenuMusic()
func _on_button_pressed() -> void:
	AudioManager.stop_MainMenuMusic()
	get_tree().change_scene_to_file("res://Scenes/PlayScene.tscn")

func _on_button_pressed_instructions() -> void:
	instructionsPage.visible = true
	get_tree().paused = true
	
func _on_button_pressed_back() -> void:
	instructionsPage.visible = false
	get_tree().paused = false
