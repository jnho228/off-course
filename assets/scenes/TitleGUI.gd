extends Control


signal start_game


func _on_StartButton_pressed() -> void:
	$StartButton.disabled = true
	emit_signal("start_game")
