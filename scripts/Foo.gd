extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hurtbox_area_entered(area):
	print("test")


func _on_area_entered(area):
	print("Yay")


func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("testing")


func _on_body_entered(body):
	print("Wew")
