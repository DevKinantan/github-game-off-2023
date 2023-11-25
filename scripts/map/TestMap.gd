extends Node2D


@onready var npc:Character = $NPC

var enemy_scn = preload("res://scenes/characters/basic_character.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
#	npc.move_to_point($Route_1.global_position, true, 50)
#	npc.move_to_point($Goal.global_position, true, 50)
#	spawn_enemy($Route_2)
	pass


func spawn_enemy(route):
	var enemy = enemy_scn.instantiate()
	enemy.tags.append("enemy")
	enemy.move_to_point(route.global_position, true, 50)
	enemy.move_to_point($Goal.global_position, true, 50)
	enemy.global_position = $Start.global_position
	add_child(enemy)


func _on_goal_area_body_entered(body):
	if body is Character:
		if "enemy" in body.tags:
			body.queue_free()


func _on_timer_timeout():
	var routes = [$Route_1, $Route_2, $Route_3]
	spawn_enemy(routes[randi_range(0, len(routes)-1)])
