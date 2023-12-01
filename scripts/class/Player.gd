class_name Player extends Character

enum {
	_MOVE,
	DASH,
	ATTACK
}

var tool = "axe"


func _ready():
	super()
	speed = default_speed
	set_tool("pickaxe")


func _physics_process(_delta):
	match state:
		MOVE:
			move_state()
	
	if direction.x != 0:
		flip_sprite(direction.x < 0)

	
	if direction == Vector2.ZERO:
		last_position = global_position

	move_and_slide()


func _input(event):
	if state == MOVE:
		direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
		direction = direction.normalized()
		
		if event.is_action_pressed("dash") and direction != Vector2.ZERO:
			dash_state()
		
		if event.is_action_pressed("attack") and is_area_have_resource():
			attack_state()

	if event.is_action_released("dash"):
		speed = default_speed


func set_tool(t):
	tool = t
	match tool:
		"axe":
			$Sprites/Attack/Weapon.texture = load("res://assets/sprite/weapon/axe_tool.png")
		"pickaxe":
			$Sprites/Attack/Weapon.texture = load("res://assets/sprite/weapon/pickaxe_tool.png")


func attack_state():
	state = ATTACK
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	show_sprite("Attack")
	var atk_animation = "AttackLeft" if is_flipped else "AttackRight"
	$AnimationPlayer.play(atk_animation)


func attack_end():
	state = MOVE


func dash_state():
	state = DASH
#	speed *= 2.0
	velocity = direction * speed
	show_sprite("Dash")
	$AnimationPlayer.play("Dash")


func dash_end():
	direction = Vector2.ZERO
	state = MOVE


func is_area_have_resource():
	for body in $ObserveArea.get_overlapping_bodies():
		if body is Resources:
			return true

	return false


func _on_observe_area_area_entered(area):
	if area.get_parent() is Resources:
		match area.get_parent().resource_type:
			Resources.RESOURCE.WOOD:
				set_tool("axe")
			Resources.RESOURCE.ROCK:
				set_tool("pickaxe")
