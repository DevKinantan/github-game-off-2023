class_name Tower extends StaticBody2D

signal tower_destroyed

@export var tags = []
@export var can_attack:bool = true
@export var is_decoy = false

@export var max_hp:int = 10
@export var attack:int = 1
@export var attack_cooldown:float = 1.0
@export var attack_radius:int = 100

@export var projectile_source:Vector2 = Vector2.ZERO

var projectile_scn = preload("res://scenes/props/projectile.tscn")

var can_shoot:bool = true
var current_target:Character = null
var hp = max_hp

var attack_bonus = 0


func _ready():
	$FocusLine.visible = false
	$RadiusIndicator.visible = false
	
	hp = max_hp
	
	set_attack_radius(attack_radius)
	set_attack_bonus(0)


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
	if current_target and can_shoot and is_instance_valid(current_target):
		var projectile = projectile_scn.instantiate()
		var target_hurtbox = current_target.get_node_or_null("Hurtbox").global_position

		add_child(projectile)
		projectile.set_origin_position(to_global(projectile_source))
		projectile.attack = attack
		projectile.velocity = projectile.global_position.direction_to(target_hurtbox) * 1000
		can_shoot = false
		$Cooldown.start(attack_cooldown)


func update_tower_hp_bar():
	var hp_bar = get_node_or_null("HealthBar/Bar")
	if hp_bar:
		hp_bar.size.y = 132.0 * (hp/float(max_hp))


func set_attack_bonus(n:int):
	attack_bonus += n
	attack += n
	
	var buff_icon = get_node_or_null("BuffIcon")
	if buff_icon:
		buff_icon.visible = attack_bonus > 0
	
#	print(self, "attack +", n)


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


func _on_hurtbox_area_entered(area):
	if area.name == "Hitbox":
		if area.get_parent() is Enemy:
			hp -= area.get_parent().attack
			update_tower_hp_bar()
		
			if hp <= 0:
				emit_signal("tower_destroyed")
				queue_free()
		
			if $TintEffect.is_playing():
				$TintEffect.stop()
			$TintEffect.play("Damaged")


func _on_attack_area_area_entered(area):
	if area.name == "BuffArea":
		attack_bonus += 1


func is_tower(body):
	return body is Tower


func _on_buff_area_tree_entered():
	var towers = $AttackArea/BuffArea.get_overlapping_bodies().filter(is_tower)
	for tower in towers:
		tower.set_attack_bonus(1)


func _on_buff_area_tree_exiting():
	var towers = $AttackArea/BuffArea.get_overlapping_bodies().filter(is_tower)
	for tower in towers:
		tower.set_attack_bonus(-1)


func _on_buff_area_body_entered(body):
	if body is Tower:
		body.set_attack_bonus(1)


func _on_mouse_detector_area_entered(area):
	if area.name == "BuffArea":
		set_attack_bonus(1)


func _on_attack_area_body_entered(body):
	if is_decoy and body is Enemy:
		body.target_queue.insert(0, self)
		body.atk_target = self
