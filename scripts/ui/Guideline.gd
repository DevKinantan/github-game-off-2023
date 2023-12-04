extends Panel


func _ready():
	get_tree().paused = true


func _on_ok_button_pressed():
	get_tree().paused = false
	visible = false
