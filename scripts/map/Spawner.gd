extends Marker2D

@export var target = []

@export var tower = 1

var slime = preload("res://scenes/characters/slime.tscn")
var skeleton = preload("res://scenes/characters/skeleton.tscn")
var ghoul = preload("res://scenes/characters/ghoul.tscn")

var enemies = [slime, skeleton, ghoul]


func spawn_enemy(idx):
	var enemy_node = enemies[idx].instantiate()
	
	match tower:
		1:
			enemy_node.target_queue.append(get_parent().get_parent().get_node_or_null("MainTower/AncientTower"))
		2:
			enemy_node.target_queue.append(get_parent().get_parent().get_node_or_null("MainTower/AncientTower2"))
		3:
			enemy_node.target_queue.append(get_parent().get_parent().get_node_or_null("MainTower/AncientTower3"))
		4:
			enemy_node.target_queue.append(get_parent().get_parent().get_node_or_null("MainTower/AncientTower4"))

	enemy_node.target_queue.append(get_parent().get_parent().get_node_or_null("MainTower/AncientRune"))

	get_parent().add_child(enemy_node)
	enemy_node.global_position = global_position


func _on_slime_spawn_timeout():
	spawn_enemy(0)


func _on_skeleton_spawn_timeout():
	spawn_enemy(1)


func _on_ghoul_spawn_timeout():
	spawn_enemy(2)
