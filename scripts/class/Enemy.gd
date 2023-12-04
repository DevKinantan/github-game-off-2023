class_name Enemy extends Character

enum {
	_MOVE,
	ATTACK,
	MOVE_AND_ATTACK,
	DEAD
}

@export var target_queue = []
@export var attack = 1

var atk_target = null
var have_target = false

func _ready():
	state = MOVE_AND_ATTACK
#	target_queue.append(get_parent().get_node_or_null("MainTower/AncientTower4"))
#	target_queue.append(get_parent().get_node_or_null("MainTower/AncientRune"))
	atk_target = target_queue[0]


func _physics_process(_delta):
	if not is_instance_valid(atk_target):
		target_queue.pop_front()
		if len(target_queue) >= 1:
			atk_target = target_queue[0]
		else:
			atk_target = null

	match state:
		MOVE:
			move_state()
		MOVE_AND_ATTACK:
			move_and_attack_state(atk_target)
	
	if direction.x != 0:
		flip_sprite(direction.x < 0)

	move_and_slide()


func is_target(area):
	if area.name == "Hurtbox":
		return area.get_parent() is Player or area.get_parent() is Tower 
	return false


func target_in_area():
#	var overlap_area = $AttackArea.get_overlapping_areas()
#	for idx in range(0, len(overlap_area)-1):
#		print(idx)
#		if overlap_area[idx].name == "Hurtbox":
#			return overlap_area[idx].get_parent() is Tower or overlap_area[idx].get_parent() is Player
	
	return len($AttackArea.get_overlapping_areas().filter(is_target)) >= 1


func attack_end():
	state = MOVE_AND_ATTACK


func dead_end():
	queue_free()


func move_and_attack_state(current_target=null):
	if have_target:
#		state = ATTACK
		direction = Vector2.ZERO
		velocity = Vector2.ZERO
		show_sprite("Attack")
		$AnimationPlayer.play("Attack")
		
	elif current_target:
		
		direction = global_position.direction_to(current_target.get_node("Hurtbox").global_position)
		velocity = speed * direction
		if velocity != Vector2.ZERO:
			show_sprite("Walk")
			$AnimationPlayer.play("Walk")
		else:
			show_sprite("Move")
			$AnimationPlayer.play("Idle")


func _on_hurtbox_area_entered(area):
	if area.name == "Hitbox" and area.get_parent() != self and not (area.get_parent() is Enemy):
		if $TintEffect.is_playing():
			$TintEffect.stop()
		$TintEffect.play("Damaged")
		
		if not invincible:
			hp -= area.get_parent().attack
			if hp <= 0:
				tags = []
				state = DEAD
				direction = Vector2.ZERO
				velocity = Vector2.ZERO
				show_sprite("Dead")
				$AnimationPlayer.play("Dead")


func _on_cooldown_timeout():
	pass # Replace with function body.


func _on_refresh_target_timeout():
	have_target = target_in_area()
