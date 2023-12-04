extends Node2D

var rock_scene = preload("res://scenes/props/rock.tscn")
var tree_scene = preload("res://scenes/props/tree.tscn")


func _ready():
	add_resources()


func add_resources():
	for marker in get_children():
		var offset = Vector2(randi_range(-50, 50), randi_range(-50, 50))
		var scale_variant = randf_range(0.7, 1.3)
		var is_rock = randi_range(0, 1)
		var is_fliped = randi_range(0, 1)
		var stock = randi_range(3, 7)
		var resource_node = rock_scene.instantiate() if is_rock else tree_scene.instantiate()
		
		get_parent().add_child.call_deferred(resource_node)
		resource_node.global_position = marker.global_position + offset
		resource_node.scale = Vector2(scale_variant, scale_variant)
		resource_node.get_node("Sprite2D").flip_h = true if is_fliped == 1 else false
		resource_node.resource_stock = stock

