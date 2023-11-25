extends CharacterBody2D


func _physics_process(delta):
	move_and_slide()


func _on_hitbox_area_entered(area):
	if area.name == "Hurtbox":
		queue_free()
