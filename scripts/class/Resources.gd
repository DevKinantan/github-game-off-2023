class_name Resources extends StaticBody2D

enum RESOURCE {
	WOOD,
	ROCK
}

@export var resource_type:RESOURCE
@export var resource_stock = 5


func _on_hurtbox_area_entered(area):
	if area.name == "Hitbox" and area.get_parent() is Player:
		$AnimationPlayer.play("Hit")
		$ResourceHit.play()
		
		match resource_type:
			RESOURCE.WOOD:
				get_parent().set_wood_stock(1)
			RESOURCE.ROCK:
				get_parent().set_rock_stock(1)

		resource_stock -= 1
		if resource_stock <= 0:
			queue_free()


func _on_interaction_area_body_entered(body):
	if body is Player:
		$InteractionArea.show_prompt(true, "Harvest")


func _on_interaction_area_body_exited(body):
	if body is Player:
		$InteractionArea.show_prompt(false, "Harvest")
