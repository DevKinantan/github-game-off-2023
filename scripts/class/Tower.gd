class_name Tower extends StaticBody2D

@export var max_hp:int = 10
@export var damage:int = 1
@export var rate_of_fire:int = 1

var projectile_scn = preload("res://scenes/props/projectile.tscn")

var can_shoot = true
var current_target:Character = null


func _physics_process(delta):
	shoot_target()


func is_enemy(body):
	if body is Character:
		return "enemy" in body.tags
	return false


func get_target():
	var overlapping_bodies = $AttackArea.get_overlapping_bodies().filter(is_enemy)
	if not overlapping_bodies:
		current_target = null
		return

	for body in overlapping_bodies:
		if current_target == null:
			current_target = body
		elif global_position.distance_to(body.global_position) < global_position.distance_to(current_target.global_position):
			current_target = body


func shoot_target():
	if current_target and can_shoot:
		var projectile = projectile_scn.instantiate()
		projectile.global_position = global_position
		projectile.velocity = global_position.direction_to(current_target.global_position) * 300
		get_parent().add_child(projectile)
		can_shoot = false
		$Cooldown.start()


func _on_attack_area_body_entered(body):
	pass


func _on_refresh_target_timeout():
	get_target()


func _on_cooldown_timeout():
	can_shoot = true


func _on_mouse_detector_mouse_entered():
	$FocusLine.visible = true


func _on_mouse_detector_mouse_exited():
	$FocusLine.visible = false
