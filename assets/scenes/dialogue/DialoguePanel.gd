extends NinePatchRect


var is_panel_showing: bool = false


func toggle_panel() -> void:
	$AnimationPlayer.play("hide" if is_panel_showing else "show")
	is_panel_showing = !is_panel_showing


func set_text(text: String) -> void:
	$DialogueText.text = text
