extends Node


export var location_marker_object: PackedScene
export var meteor_object: PackedScene

signal enter_pressed

var is_playing: bool = false
var player_velocity: Vector2 = Vector2(0,0) # make everything goes go opposite of this?

var meteor_array = []
var current_meteor: int = 0

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
	
	for _x in range(100):
		var new_meteor = meteor_object.instance()
		meteor_array.append(new_meteor)
		add_child(new_meteor)
		new_meteor.position = Vector2(-100, -100)
	
	opening()


func opening() -> void:
	yield(get_tree().create_timer(1), "timeout")
	
	$CanvasLayer/DialoguePanel.toggle_panel()
	
	for x in range(0, opening_dialogue.size()):
		if x == 2: shake_camera(3, 5)
		
		$CanvasLayer/DialoguePanel.set_text(opening_dialogue[x])
		yield(self, "enter_pressed")
	
	$CanvasLayer/DialoguePanel.toggle_panel()
	$OxygenTimer.start()
	$LocationMarkerTimer.start()
	$MeteorTimer.start()
	
	# show an initial marker
	show_location_marker()
	
	is_playing = true


func _process(delta) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("enter_pressed")
	
	if !is_playing:
		return
	
	# Movement
	var move_vector: Vector2 = Vector2(0, 0)
	
	if $CanvasLayer/FuelBar.value > 0:
		if Input.is_action_pressed("ui_up"):
			move_vector.y = -1
		if Input.is_action_pressed("ui_down"):
			move_vector.y = 1
		if Input.is_action_pressed("ui_left"):
			move_vector.x = -1
		if Input.is_action_pressed("ui_right"):
			move_vector.x = 1
	
	if move_vector != Vector2.ZERO:
		$CanvasLayer/FuelBar.value -= 1
	
	player_velocity += move_vector.normalized() * delta
	
	$ParallaxBackground/ParallaxLayer.motion_offset += player_velocity * -.5
	
	# Move everything else
	$SpaceStation.position.y += sin(OS.get_ticks_msec() * .001) * 10 * delta
	$SpaceStation.position += player_velocity * -1
	
	for x in meteor_array:		
		x.position += player_velocity * -1


func _on_OxygenTimer_timeout() -> void:
	var oxygen_value: int = $CanvasLayer/OxygenBar.value
	
	oxygen_value -= 1
	if oxygen_value <= 0:
		oxygen_value = 0
		# trigger a game over death
		trigger_gameover()
	
	$CanvasLayer/OxygenBar.value = oxygen_value


func _on_LocationMarkerTimer_timeout() -> void:
	show_location_marker()


func show_location_marker() -> void:
	var new_marker = location_marker_object.instance()
	add_child(new_marker)
	
	#new_marker.position = $Player.position + Vector2(10, 10)
	# x = cx+r*cos(a)
	# y = cy+r*sin(a) the a needs to be the angle between c (center "player") and the station and in radians!!
	
	var angle_to_station: float = $Player.get_angle_to($SpaceStation.position) # idk if this works lmao
	var spawn_point: Vector2 = Vector2(	$Player.position.x + 300 * cos(angle_to_station),
										$Player.position.y + 300 * sin(angle_to_station))
	
	new_marker.position = spawn_point


func shake_camera(power: float, duration: int) -> void:
	for _x in range(duration):
		$Camera2D.offset = Vector2(rand_range(-power,power), rand_range(-power,power))
		yield(get_tree(), "idle_frame")
	$Camera2D.offset = Vector2(0,0)


func _on_MeteorTimer_timeout() -> void:
	current_meteor += 1
	if current_meteor >= meteor_array.size():
		current_meteor = 0
	
	$Path2D/PathFollow2D.offset = randi()
	
	meteor_array[current_meteor].set_meteor($Path2D/PathFollow2D.position, rand_range(0,360), rand_range(50,100))
	
	print("Spawning meteor at: " + String($Path2D/PathFollow2D.position))


func _on_Player_player_hit() -> void:
	player_velocity *= Vector2(rand_range(-2,2), rand_range(-2,2))
	
	$CanvasLayer/OxygenBar.value -= randi() % 10 + 10
	if $CanvasLayer/OxygenBar.value <= 0:
		$CanvasLayer/OxygenBar.value = 0
		# trigger a game over death
		trigger_gameover()


func _on_ReturnToTitleButton_pressed() -> void:
	$CanvasLayer/ScreenFade.load_scene("res://assets/scenes/Title.tscn")


func trigger_gameover() -> void:
	is_playing = false
	$CanvasLayer/GameOver/AnimationPlayer.play("show")
	$OxygenTimer.stop()
	$MeteorTimer.stop()
	$LocationMarkerTimer.stop()
	for x in meteor_array:
		x.position = Vector2(-1000, -1000)
