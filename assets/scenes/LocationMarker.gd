extends AnimatedSprite


func _ready() -> void:
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(2), "timeout")
	call_deferred("queue_free")
