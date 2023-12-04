extends Node2D

signal resource_updated(stock, max, resource_type)
signal resource_status(wood, rock)
signal tower_updated()

@export var max_wood:int = 10
@export var max_rock:int = 10

var wood_stock:int = 6
var rock_stock:int = 6


func _ready():
	emit_signal("resource_status", wood_stock, rock_stock)
#	get_tree().paused = true


func set_wood_stock(n:int):
	if ((n > 0) and (wood_stock < max_wood)) or ((n < 0) and (wood_stock > 0)):
		wood_stock += n
	emit_signal("resource_updated", wood_stock, max_wood, "wood")
	emit_signal("resource_status", wood_stock, rock_stock)


func set_rock_stock(n:int):
	if ((n > 0) and (rock_stock < max_rock)) or ((n < 0) and (rock_stock > 0)):
		rock_stock += n
	emit_signal("resource_updated", rock_stock, max_rock, "rock")
	emit_signal("resource_status", wood_stock, rock_stock)


func _on_tower_placement_tower_build(wood, rock):
	set_wood_stock(-wood)
	set_rock_stock(-rock)
