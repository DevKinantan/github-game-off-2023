extends Area2D


@onready var prompt = $Prompt


func _ready():
	prompt.visible = false


func show_prompt(v:bool, label:String = "Interact"):
	prompt.visible = v
	if visible:
		prompt.get_node("Label").text = label
