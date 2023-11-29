class_name Resources extends StaticBody2D

enum RESOURCE {
	WOOD,
	ROCK
}

@export var resource_type:RESOURCE


func _on_hurtbox_area_entered(area):
	if area.name == "Hitbox":# and area.get_parent() is Player:
		$AnimationPlayer.play("Hit")
