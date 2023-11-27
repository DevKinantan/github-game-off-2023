extends Node2D

var enemy_scn = preload("res://scenes/characters/basic_character.tscn")


func spawn_enemy():
	var enemy = enemy_scn.instantiate()
	enemy.tags.append("enemy")
	enemy.move_to_point(get_parent().get_node("EnemyTarget").global_position, true, 50)
	add_child(enemy)
	enemy.global_position = global_position


func _on_timer_timeout():
	print("enemy spawned")
	spawn_enemy()
