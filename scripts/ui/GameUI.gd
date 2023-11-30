extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	var p = get_parent()
	$ResourceBar.update_bar(p.wood_stock, p.max_wood, "wood")
	$ResourceBar.update_bar(p.rock_stock, p.max_rock, "rock")


func _on_level_resource_updated(s, m, rt):
	$ResourceBar.update_bar(s, m, rt)
