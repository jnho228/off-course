extends Node


func _on_TitleGUI_start_game() -> void:
	$ScreenFade.load_scene("res://assets/scenes/Opening.tscn")
