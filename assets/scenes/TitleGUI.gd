extends Control


signal start_game


func _on_StartButton_pressed() -> void:
	$StartButton.disabled = true
	$AudioStreamPlayer.play()
	emit_signal("start_game")
