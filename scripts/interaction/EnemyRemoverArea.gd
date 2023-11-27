extends Area2D


func _on_body_entered(body):
	if body is Character:
		if "enemy" in body.tags:
			body.queue_free() 
