extends CanvasLayer

var level = preload("res://scenes/maps/forest.tscn")


func change_scene():
	get_tree().change_scene_to_packed(level)


func _on_start_button_pressed():
	$TintPlayer.play("FadeBlack")
