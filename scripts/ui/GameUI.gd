extends CanvasLayer

var start_menu = load("res://scenes/ui/start_menu.tscn")
var level = load("res://scenes/maps/forest.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var p = get_parent()
	$GameplayUI/ResourceBar.update_bar(p.wood_stock, p.max_wood, "wood")
	$GameplayUI/ResourceBar.update_bar(p.rock_stock, p.max_rock, "rock")


func _on_level_resource_updated(s, m, rt):
	$GameplayUI/ResourceBar.update_bar(s, m, rt)


func _on_button_pressed():
	get_tree().paused = false


func _on_ancient_rune_tower_destroyed():
	get_tree().paused = true
	$GameOver/BG.texture = load("res://assets/ui/you lose.png")
	$GameplayUI.visible = false
	$GameOver.visible = true


func _on_count_down_timeout():
	get_tree().paused = true
	$GameOver/BG.texture = load("res://assets/ui/congrats.png")
	$GameplayUI.visible = false
	$GameOver.visible = true


func _on_restart_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(level)


func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(start_menu)
