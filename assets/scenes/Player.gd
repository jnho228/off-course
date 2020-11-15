extends Area2D


signal player_hit

var player_velocity: Vector2 = Vector2(0,0)


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	var thrust_direction: Vector2 = Vector2(0,0)
	if Input.is_action_pressed("ui_up"):
		thrust_direction.y = -1
	if Input.is_action_pressed("ui_down"):
		thrust_direction.y = 1
	if Input.is_action_pressed("ui_left"):
		thrust_direction.x = -1
	if Input.is_action_pressed("ui_right"):
		thrust_direction.x = 1
	
	player_velocity = thrust_direction.normalized()
	
	if player_velocity == Vector2.ZERO:
		$spaceEffects_001.hide()
		return
	
	$spaceEffects_001.show()
	$spaceEffects_001.rotation = thrust_direction.angle() - PI/2
	$Sprite.rotation = thrust_direction.angle()


func _on_Player_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_bit(1):
		$AudioStreamPlayer2D.play()
		print("I have hit a meteor!")
		emit_signal("player_hit")
