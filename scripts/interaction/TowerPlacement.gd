extends Node2D

enum TOWER {
	BASIC
}

const NORMAL_COLOR = Color(1.0, 1.0, 1.0, 0.5)
const RED_COLOR = Color(1.0, 0.0, 0.0, 0.5)

const TOWERS = [
	{
		"sprite": preload("res://assets/sprite/tower/TreeTower1.png"),
		"scene": preload("res://scenes/towers/basic_tower.tscn")
	}
]


@export var max_distance = 100.0

@onready var tower = $Tower

var selected_tower = TOWER.BASIC

var origin = Vector2.ZERO
var placement_mode = true


func _ready():
	placement_mode = false
	$Tower.position = get_local_mouse_position()
	$Tower.visible = placement_mode


func toggle_tower_placement():
	placement_mode = !placement_mode
	$Tower.visible = placement_mode


func place_tower(pos:Vector2):
	var tower_node = TOWERS[selected_tower]["scene"].instantiate()
	get_parent().get_parent().add_child(tower_node)
	tower_node.global_position = pos


func _input(event):
	if placement_mode and InputEventMouseMotion:
		tower.position = get_local_mouse_position()
		
		var valid_place = origin.distance_to(get_local_mouse_position()) <= max_distance
		tower.modulate = NORMAL_COLOR if valid_place else RED_COLOR
		
		if valid_place and event.is_action_pressed("interact"):
			place_tower(get_global_mouse_position())

	if event.is_action_pressed("toggle_tower_placement"):
		toggle_tower_placement()
