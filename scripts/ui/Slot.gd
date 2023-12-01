extends TextureButton

const NORMAL_COLOR = Color(1.0, 1.0, 1.0)
const DISABLED_COLOR = Color(0.33, 0.74, 1.0)
const FOCUS_COLOR = Color(0.5, 0.5, 0.5)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func disable_slot(val:bool):
	disabled = val
	modulate = DISABLED_COLOR if disabled else NORMAL_COLOR


func slot_hovered(val:bool):
	if not disabled:
		modulate = FOCUS_COLOR if val else NORMAL_COLOR


func _on_mouse_entered():
	slot_hovered(true)


func _on_mouse_exited():
	slot_hovered(false)
