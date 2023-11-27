class_name Player extends Character

enum {
	_MOVE,
	DASH,
	ATTACK
}


func _ready():
	super()
	speed = default_speed


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
		
		elif event.is_action_pressed("attack"):
			attack_state()
		
		
	if event.is_action_released("dash"):
		speed = default_speed


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
	speed *= 2.0
	velocity = direction * speed
	show_sprite("Dash")
	$AnimationPlayer.play("Dash")


func dash_end():
	direction = Vector2.ZERO
	state = MOVE
