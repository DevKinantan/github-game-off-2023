class_name Tower extends StaticBody2D

@export var can_attack:bool = true

@export var max_hp:int = 10
@export var attack:int = 1
@export var attack_cooldown:float = 1.0
@export var attack_radius:int = 100

@export var projectile_source:Vector2 = Vector2.ZERO

var projectile_scn = preload("res://scenes/props/projectile.tscn")

var can_shoot:bool = true
var current_target:Character = null


func _ready():
	$FocusLine.visible = false
	$RadiusIndicator.visible = false
	
	set_attack_radius(attack_radius)


func _physics_process(_delta):
	if can_attack:
		shoot_target()


func set_attack_radius(n:int):
	var area_scale = n/100.0
	$RadiusIndicator.scale = Vector2(area_scale, area_scale)
	$AttackArea.scale = Vector2(area_scale, area_scale)


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
		var target_hurtbox = current_target.get_node("Hurtbox").global_position

		add_child(projectile)
		projectile.set_origin_position(to_global(projectile_source))
		projectile.attack = attack
		projectile.velocity = projectile.global_position.direction_to(target_hurtbox) * 1000
		can_shoot = false
		$Cooldown.start(attack_cooldown)


func _on_attack_area_body_entered(_body):
	pass
#	if body is Player:
#		print("yay")


func _on_refresh_target_timeout():
	get_target()


func _on_cooldown_timeout():
	can_shoot = true


func _on_mouse_detector_mouse_entered():
	$FocusLine.visible = true
	$RadiusIndicator.visible = true


func _on_mouse_detector_mouse_exited():
	$FocusLine.visible = false
	$RadiusIndicator.visible = false
