extends ColorRect


func _ready() -> void:
	pass


func load_scene(path: String) -> void:
	$AnimationPlayer.play("show")
	yield(get_tree().create_timer(1), "timeout")
	if get_tree().change_scene(path) != OK:
		get_tree().quit(-1)
