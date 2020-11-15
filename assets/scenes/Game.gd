extends Node


signal enter_pressed

var is_playing: bool = false
var player_velocity: Vector2 = Vector2(0,0) # make everything goes go opposite of this?

var opening_dialogue = ["Fuck",
						"I should be able to lock onto the station's signal...",
						"...",
						"There we.. go!"]


func _ready() -> void:
	randomize()
	
	#move the space station somewhere 'far away'
	var left_or_right: int = randi() % 2
	var up_or_down: int = randi() % 2
	var new_position: Vector2 = Vector2((randi() % 10000 + 10000) * (1 if left_or_right == 0 else -1),
										(randi() % 10000 + 10000) * (1 if up_or_down == 0 else -1))
	$SpaceStation.position = new_position
	print("New Position: " + String(new_position))
	
	opening()


func opening() -> void:
	yield(get_tree().create_timer(1), "timeout")
	
	$DialoguePanel.toggle_panel()
	
	for x in range(0, opening_dialogue.size()):
		$DialoguePanel.set_text(opening_dialogue[x])
		yield(self, "enter_pressed")
	
	$DialoguePanel.toggle_panel()
	$OxygenTimer.start()
	$LocationMarkerTimer.start()
	
	# show an initial marker
	
	is_playing = true


func _process(delta) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("enter_pressed")
	
	if !is_playing:
		return
	
	# Movement
	var move_vector: Vector2 = Vector2(0, 0)
	
	if $FuelBar.value > 0:
		if Input.is_action_pressed("ui_up"):
			move_vector.y = -1
		if Input.is_action_pressed("ui_down"):
			move_vector.y = 1
		if Input.is_action_pressed("ui_left"):
			move_vector.x = -1
		if Input.is_action_pressed("ui_right"):
			move_vector.x = 1
	
	if move_vector != Vector2.ZERO:
		$FuelBar.value -= 1
	
	player_velocity += move_vector.normalized() * delta
	
	$ParallaxBackground/ParallaxLayer.motion_offset += player_velocity * -.5
	
	# Move everything else
	$SpaceStation.position.y += sin(OS.get_ticks_msec() * .001) * 10 * delta
	$SpaceStation.position += player_velocity * -1


func _on_OxygenTimer_timeout() -> void:
	var oxygen_value: int = $OxygenBar.value
	
	oxygen_value -= 1
	if oxygen_value <= 0:
		oxygen_value = 0
		# trigger a game over death
	
	$OxygenBar.value = oxygen_value


func _on_LocationMarkerTimer_timeout() -> void:
	# show a marker on the edge of the screen for where we should be going
	pass # Replace with function body.
