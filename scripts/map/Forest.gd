extends Node2D

signal resource_updated(stock, max, resource_type)
signal tower_updated()

@export var max_wood:int = 5
@export var max_rock:int = 5

var wood_stock:int = 0
var rock_stock:int = 0

var towers = [
	{
		"scene": "res://scenes/towers/basic_tower.tscn",
		"hp": 10,
		"atk": 1,
		"atk_spd": 1,
		"radius": 100,
		"wood": 1,
		"rock": 1
	},
	{
		"scene": "res://scenes/towers/basic_tower.tscn",
		"hp": 10,
		"atk": 1,
		"atk_spd": 1,
		"radius": 100,
		"wood": 1,
		"rock": 1
	},
	{
		"scene": "res://scenes/towers/basic_tower.tscn",
		"hp": 10,
		"atk": 1,
		"atk_spd": 1,
		"radius": 100,
		"wood": 1,
		"rock": 1
	},
	{
		"scene": "res://scenes/towers/basic_tower.tscn",
		"hp": 10,
		"atk": 1,
		"atk_spd": 1,
		"radius": 100,
		"wood": 1,
		"rock": 1
	},
]


func set_wood_stock(n:int):
	if wood_stock < max_wood:
		wood_stock += n
	emit_signal("resource_updated", wood_stock, max_wood, "wood")


func set_rock_stock(n:int):
	if rock_stock < max_rock:
		rock_stock += n
	emit_signal("resource_updated", rock_stock, max_rock, "rock")
