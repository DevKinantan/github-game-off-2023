extends CharacterBody2D

@export var max_distance = 400
@export var attack = 1

var origin_position = Vector2.ZERO


func _physics_process(_delta):
	move_and_slide()
	
	if global_position.distance_to(origin_position) > max_distance:
		queue_free()


func _on_hitbox_area_entered(area):
	if area.name == "Hurtbox":
		queue_free()


func set_origin_position(pos:Vector2):
	global_position = pos
	origin_position = pos
