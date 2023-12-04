extends Control

var start_menu = load("res://scenes/ui/start_menu.tscn")
var level = load("res://scenes/maps/forest.tscn")


func _on_continue_pressed():
	get_tree().paused = false
	$PauseMenu.visible = false


func _on_pause_button_pressed():
	get_tree().paused =  true if not get_tree().paused else false
	$PauseMenu.visible = get_tree().paused


func _on_restart_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(level)


func _on_exit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(start_menu)


func _on_pause_button_mouse_entered():
	$AnimationPlayer.play("button_rotate")


func _on_pause_button_mouse_exited():
	$AnimationPlayer.play_backwards("button_rotate")


func _input(event):
	if event.is_action_pressed("pause"):
		_on_pause_button_pressed()
