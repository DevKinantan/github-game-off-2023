extends Marker2D

var tower_scn = preload("res://scenes/towers/basic_tower.tscn")

var can_build = true
var player_in_area = false


func _on_interaction_area_body_entered(body):
	if body is Player and can_build:
		player_in_area = true
		$InteractionArea.show_prompt(true, "Build Tower")


func _on_interaction_area_body_exited(body):
	if body is Player and can_build:
		player_in_area = false
		$InteractionArea.show_prompt(false)


func _input(event):
	if player_in_area and event.is_action_pressed("interact"):
		can_build = false
		var tower = tower_scn.instantiate()
		tower.global_position = global_position
		get_parent().add_child(tower)
		$InteractionArea.show_prompt(false)

