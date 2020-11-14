extends Node


signal enter_pressed


func _ready() -> void:
	opening()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("enter_pressed")


func opening() -> void:
	yield(get_tree().create_timer(1), "timeout")
	
	$DialoguePanel.toggle_panel()
	$DialoguePanel.set_text("Log 14.11.53")
	yield(self, "enter_pressed")
	
	$DialoguePanel.set_text("TEST 1")
	yield(self, "enter_pressed")
	
	$DialoguePanel.set_text("TEST 2")
	yield(self, "enter_pressed")
	
	$DialoguePanel.set_text("TEST 3")
	yield(self, "enter_pressed")
	
	$DialoguePanel.toggle_panel()
	yield(get_tree().create_timer(1), "timeout")
	
	$ScreenFade.load_scene("res://assets/scenes/Game.tscn")
