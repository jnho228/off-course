extends Area2D


export (Array, Texture) var meteor_sprites

var move_speed: float = 0
onready var rotation_speed: float = rand_range(-2,2)
var is_active: bool = false


func _process(delta: float) -> void:
	if !is_active:
		return
	
	position.x += sin(rotation) * move_speed * delta
	position.y -= cos(rotation) * move_speed * delta
	
	$Sprite.rotation += rotation_speed * delta


func set_meteor(pos: Vector2, rot: float, speed: float) -> void:
	position = pos
	rotation_degrees = rot
	move_speed = speed
	
	$Sprite.texture = meteor_sprites[randi() % meteor_sprites.size()]
	$Sprite.rotation_degrees = randi() % 360
	
	var new_scale = rand_range(0.2,1)
	scale *= new_scale
	
	$AnimationPlayer.play("spawn")
	$CollisionShape2D.disabled = false
	$Timer.start()
	is_active = true


func _on_Timer_timeout() -> void:
	$AnimationPlayer.play("despawn")
	$CollisionShape2D.disabled = true
	is_active = false


func _on_Meteor_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_bit(0) || area.get_collision_layer_bit(1):
		rotation += rand_range(0,360)
