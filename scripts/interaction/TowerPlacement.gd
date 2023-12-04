extends Node2D

signal towers_update(update)
signal tower_build(wood, rock)

const NORMAL_COLOR = Color(1.0, 1.0, 1.0, 0.5)
const RED_COLOR = Color(1.0, 0.0, 0.0, 0.5)

#const TOWERS = [
#	{
#		"sprite": preload("res://assets/sprite/tower/TreeTower1.png"),
#		"scene": preload("res://scenes/towers/basic_tower.tscn")
#	}
#]

var towers = [
	{
		"scene": load("res://scenes/towers/basic_tower.tscn"),
		"sprite": load("res://assets/sprite/tower/TreeTower1.png"),
		"hp": 10,
		"atk": 1,
		"atk_spd": 1,
		"radius": 200,
		"wood": 4,
		"rock": 3
	},
	{
		"scene": load("res://scenes/towers/area_tower.tscn"),
		"sprite": load("res://assets/sprite/tower/TreeTower2.png"),
		"hp": 10,
		"atk": 1,
		"atk_spd": 1,
		"radius": 100,
		"wood": 3,
		"rock": 4
	},
	{
		"scene": load("res://scenes/towers/buff_tower.tscn"),
		"sprite": load("res://assets/sprite/tower/TreeTower3.png"),
		"hp": 10,
		"atk": 1,
		"atk_spd": 1,
		"radius": 200,
		"wood": 8,
		"rock": 8
	},
	{
		"scene": load("res://scenes/towers/decoy_tower.tscn"),
		"sprite": load("res://assets/sprite/tower/Palisade.png"),
		"hp": 10,
		"atk": 0,
		"atk_spd": 1,
		"radius": 100,
		"wood": 6,
		"rock": 6
	},
]
var towers_avaibility = [true, true, true, true]

@export var max_distance = 200.0

@onready var tower = $Tower

var selected_tower = 0

var origin = Vector2.ZERO
var placement_mode = true


func _ready():
	placement_mode = false
	tower.position = get_local_mouse_position()
	tower.visible = placement_mode
	
	update_selected_tower(selected_tower, null)


func update_tower_build_info(wood, rock):
	var res = []
	var idx = 0
	for t in towers:
		res.append({
			"wood": t["wood"],
			"rock": t["rock"],
			"buildable": (wood >= t["wood"]) and (rock >= t["rock"])
		})
		towers_avaibility[idx] = (wood >= t["wood"]) and (rock >= t["rock"])
		idx += 1

	return res


func toggle_tower_placement(is_on:bool):
	placement_mode = is_on
	tower.visible = placement_mode


func place_tower(pos:Vector2):
	var tower_node = towers[selected_tower]["scene"].instantiate()
	tower_node.max_hp = towers[selected_tower]["hp"]
	tower_node.attack = towers[selected_tower]["atk"]
	tower_node.attack_cooldown = towers[selected_tower]["atk_spd"]
	tower_node.attack_radius = towers[selected_tower]["radius"]
	get_parent().get_parent().add_child(tower_node)
	tower_node.global_position = pos
	$TowerBuildAudio.play()

	emit_signal("tower_build", towers[selected_tower]["wood"], towers[selected_tower]["rock"])


func update_selected_tower(idx:int, _sprite):
	selected_tower = idx
	tower.texture = towers[idx]["sprite"]
	var s = towers[idx]["radius"] / 100.0
	tower.get_node("RadiusIndicator").scale = Vector2(s, s)


func _input(event):
	if placement_mode and InputEventMouseMotion:
		tower.position = get_local_mouse_position()
		
		var valid = origin.distance_to(get_local_mouse_position()) <= max_distance
		valid = valid and not $Tower/CollisionArea.has_overlapping_bodies()
		valid = valid and towers_avaibility[selected_tower]
		tower.modulate = NORMAL_COLOR if valid else RED_COLOR
		
		if valid and event.is_action_pressed("interact"):
			place_tower(get_global_mouse_position())

	if event.is_action_pressed("toggle_tower_placement"):
		toggle_tower_placement(not placement_mode)
	
	if event.is_action_pressed("scroll_up"):
		selected_tower -= 1
		if selected_tower < 0:
			selected_tower = 3
		
		update_selected_tower(selected_tower, null)

	if event.is_action_pressed("scroll_down"):
		selected_tower += 1
		if selected_tower > 3:
			selected_tower = 0
		
		update_selected_tower(selected_tower, null)


func _on_tower_selector_tower_selected(tower_index, sprite):
	if not placement_mode:
		update_selected_tower(tower_index, sprite)
		toggle_tower_placement(true)
	
	elif placement_mode:
		if selected_tower == tower_index:
			toggle_tower_placement(false)
		else:
			update_selected_tower(tower_index, sprite)


func _on_level_resource_status(wood, rock):
	emit_signal("towers_update", update_tower_build_info(wood, rock))
