extends Node


var credits_text = ["Off Course",
					"by jnho228",
					"Entry for 'Mini Jam 67: Void'",
					"",
					"Programming: jnho228",
					"Music: jnho228",
					"Art and Font: Kenney :)",
					"Thanks for playing!"]

var text_index: int = 0


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	$ParallaxBackground/ParallaxLayer.motion_offset += Vector2(0, -1) * -150 * delta


func _on_Timer_timeout() -> void:
	$CreditsText.text = credits_text[text_index]
	
	text_index += 1
	
	if text_index >= credits_text.size():
		$Timer.stop()
		yield(get_tree().create_timer(2), "timeout")
		$ScreenFade.load_scene("res://assets/scenes/Title.tscn")
