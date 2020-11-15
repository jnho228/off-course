extends Node


signal enter_pressed

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
	
	$spaceStation_020.position.y += sin(OS.get_ticks_msec() * .001) * 10 * delta


func opening() -> void:
	yield(get_tree().create_timer(1), "timeout")
	
	$DialoguePanel.toggle_panel()
	
	for x in range(0, opening_dialogue.size()):
		if x == 4: shake_camera(10, 5)
		if x == 15: shake_camera(40, 10)
		
		$DialoguePanel.set_text(opening_dialogue[x])
		yield(self, "enter_pressed")
	
	$DialoguePanel.toggle_panel()
	yield(get_tree().create_timer(1), "timeout")
	
	$ScreenFade.load_scene("res://assets/scenes/Game.tscn")


func shake_camera(power: float, duration: int) -> void:
	for _x in range(duration):
		$Camera2D.offset = Vector2(rand_range(-power,power), rand_range(-power,power))
		yield(get_tree(), "idle_frame")
	$Camera2D.offset = Vector2(0,0)
