extends Node


signal enter_pressed

export var meteor_object: PackedScene

var player_velocity: Vector2 = Vector2(0,0)

var opening_dialogue = [ 	"Log Date: 6-32-67", 
							"It's been a full year now since we last recieved any signal from Earth.", 
							"I miss the blue skies, blue oceans...", 
							"Just blue in general.", 
							"...", # Shake the screen
							"What was that?",
							"And the power has flickered... great.",
							"Guess I'm going to check the solar panels.", # Change the view or something idk
							"...",
							"Oh, I hate these space-walking missions.",
							"It's like going in the deep end of the pool.",
							"But instead of a bottom, it's just infinity.",
							"...",
							"Oh dear, this looks worse than I imagined.",
							"It appears a few small asteroids have damaged the few solar cells we have left.",
							"...", # Shake the screen and show player flying off, spinning
							"AHHHH!! SOMEONE......."]


func _ready() -> void:
	opening()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("enter_pressed")
	
	# Background??
	$ParallaxBackground/ParallaxLayer.motion_offset.x -= delta * 50
	
	$SpaceStation.position.y += sin(OS.get_ticks_msec() * .001) * 10 * delta
	
	$Player.position += player_velocity * delta


func opening() -> void:
	yield(get_tree().create_timer(1), "timeout")
	
	$CanvasLayer/DialoguePanel.toggle_panel()
	
	for x in range(0, opening_dialogue.size()):
		if x == 4: 
			for _y in range(15):
				var new_meteor = meteor_object.instance()
				add_child(new_meteor)
				new_meteor.set_meteor(Vector2(850, randi() % 600), 270 + rand_range(-45,45), rand_range(50,75))
				var new_scale = rand_range(0.01, 0.1)
				new_meteor.scale = Vector2(new_scale, new_scale)
		
		if x == 6:
			$SpaceStation/AnimationPlayer.play("flicker")
		
		if x == 8:
			$Camera2D/AnimationPlayer.play("zoom")
			$Player.show()
			$Player/CollisionShape2D.disabled = false
			
		if x == 15: 
			for _y in range(1):
				var new_meteor = meteor_object.instance()
				add_child(new_meteor)
				new_meteor.set_meteor(Vector2(850, 275), 270, 60)
				var new_scale = rand_range(0.2, 0.4)
				new_meteor.scale = Vector2(new_scale, new_scale)
		
		$CanvasLayer/DialoguePanel.set_text(opening_dialogue[x])
		yield(self, "enter_pressed")
	
	$CanvasLayer/DialoguePanel.toggle_panel()
	yield(get_tree().create_timer(2), "timeout")
	
	$CanvasLayer/ScreenFade.load_scene("res://assets/scenes/Game.tscn")


func shake_camera(power: float, duration: int) -> void:
	var current_offset = $Camera2D.offset
	for _x in range(duration):
		$Camera2D.offset += Vector2(rand_range(-power,power), rand_range(-power,power))
		yield(get_tree(), "idle_frame")
	$Camera2D.offset = current_offset


func _on_SpaceStation_area_entered(_area: Area2D) -> void:
	shake_camera(7, 5)
	$EffectPlayer.play()


func _on_Player_area_entered(_area: Area2D) -> void:
	shake_camera(10, 20)
	player_velocity.x = -65
	$EffectPlayer.play()
