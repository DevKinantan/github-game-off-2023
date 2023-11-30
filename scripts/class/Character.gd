class_name Character extends CharacterBody2D

signal hp_changed(percentage)
signal assignment_done(character, assignment)

enum {
	MOVE
}

const DIR_VECTOR = {
	"up": Vector2(0.0, -1.0),
	"down": Vector2(0.0, 1.0),
	"left": Vector2(-1.0, 0.0),
	"right": Vector2(1.0, 0.0)
}

@onready var nav = $NavigationAgent2D

@export var tags = []
@export var default_speed:float = 100
@export var max_hp:int = 5
@export var sprite_offset = 0
@export var invincible:bool = false

var shadow:Sprite2D = null

var hp = max_hp
var is_flipped = false
var state = MOVE
var direction = Vector2.ZERO
var speed:float = default_speed

var last_position:Vector2
var target:Node2D
var safe_velocity = Vector2.ZERO

var assignments = []


func _ready():
	last_position = global_position
	shadow = get_node_or_null("Shadow")
	nav.connect("velocity_computed", _on_velocity_computed)
	call_deferred("setup_navigation")
	pass


func _physics_process(_delta):
	match state:
		MOVE:
			move_state()
	
	if direction.x != 0:
		flip_sprite(direction.x < 0)
	
	if direction == Vector2.ZERO:
		last_position = global_position

	move_and_slide()


func setup_navigation():
	await get_tree().physics_frame


func _on_velocity_computed(sv):
	safe_velocity = sv


func flip_sprite(value:bool):
	if value != is_flipped:
		is_flipped = value
		for sprite in $Sprites.get_children():
			if sprite is Sprite2D:
				sprite.flip_h = value
	
	if shadow:
		shadow.offset.x = sprite_offset if value else 0

func show_sprite(sprite_name:String):
	for sprite in $Sprites.get_children():
		sprite.visible = (sprite.name == sprite_name)


func execute_assignment():
	match assignments[0]["name"]:
		"move_to":
			if global_position.distance_to(last_position) >= assignments[0]["distance"]:
				assignment_done.emit(self, assignments[0]["name"])
				assignments.pop_front()
				speed = default_speed
				direction = Vector2.ZERO
			else:
				speed = assignments[0]["speed"]
				direction = assignments[0]["direction"]
		
		"move_to_point":
			if global_position.distance_to(assignments[0]["position"]) < 1:
				assignment_done.emit(self, assignments[0]["name"])
				assignments.pop_front()
				speed = default_speed
				direction = Vector2.ZERO
			else:
				speed = assignments[0]["speed"]
				if assignments[0]["use_nav2D"]:
					nav.target_position = assignments[0]["position"]
					direction = global_position.direction_to(nav.get_next_path_position())
				else:
					direction = global_position.direction_to(assignments[0]["position"])

		"follow_target":
			var distance_to_target = global_position.distance_to(assignments[0]["target"].global_position)
			if distance_to_target < assignments[0]["space"]:
				direction = Vector2.ZERO
			else:
				speed = assignments[0]["speed"]
				direction = global_position.direction_to(assignments[0]["target"].global_position)


func move_state():
	velocity = (direction * speed) + safe_velocity
	#velocity *= delta
	
	if velocity == Vector2.ZERO:
		show_sprite("Idle")
		$AnimationPlayer.play("Idle")

	elif velocity:
		show_sprite("Walk")
		$AnimationPlayer.play("Walk")

	if len(assignments) > 0:
		execute_assignment()


func move_to(dir:String, distance:int, spd=default_speed):
	assignments.append({
		"name": "move_to",
		"direction": DIR_VECTOR[dir],
		"distance": distance,
		"speed": spd
	})


func move_to_point(point:Vector2, use_nav2D:bool=false, spd=default_speed):
	assignments.append({
		"name": "move_to_point",
		"position": point,
		"direction": global_position.direction_to(point),
		"use_nav2D": use_nav2D,
		"speed": spd
	})


func follow_target(t:Node2D, space:int = 30, use_nav2D:bool=false, spd=default_speed):
	assignments.append({
		"name": "follow_target",
		"target": t,
		"space": space,
		"use_nav2D": use_nav2D,
		"speed": spd
	})


func unfollow_target(t:Node2D):
	for assignment in assignments:
		if assignment["name"] == "follow_target":
			if assignment["target"] == t:
				assignments.erase(assignment)
		continue

	direction = Vector2.ZERO
	speed = default_speed


func _on_hurtbox_area_entered(area):
	if area.name == "Hitbox":
		if $TintEffect.is_playing():
			$TintEffect.stop()
		$TintEffect.play("Damaged")
		print("-", area.get_parent().attack, " hp")
		if not invincible:
			hp -= area.get_parent().attack
			if hp <= 0:
				queue_free()
