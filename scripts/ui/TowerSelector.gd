extends Control

signal tower_selected(tower_index, sprite)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_slot(towers):
	$BasePanel/Slot1/Label.text = "%s/%s"%[towers[0]["wood"], towers[0]["rock"]]
	$BasePanel/Slot1.disable_slot(not towers[0]["buildable"])

	$BasePanel/Slot2/Label.text = "%s/%s"%[towers[1]["wood"], towers[1]["rock"]]
	$BasePanel/Slot2.disable_slot(not towers[1]["buildable"])

	$BasePanel/Slot3/Label.text = "%s/%s"%[towers[2]["wood"], towers[2]["rock"]]
	$BasePanel/Slot3.disable_slot(not towers[2]["buildable"])

	$BasePanel/Slot4/Label.text = "%s/%s"%[towers[3]["wood"], towers[3]["rock"]]
	$BasePanel/Slot4.disable_slot(not towers[3]["buildable"])


func _on_slot_1_pressed():
	emit_signal("tower_selected", 0, $BasePanel/Slot1/Icon.texture)


func _on_slot_2_pressed():
	emit_signal("tower_selected", 1, $BasePanel/Slot2/Icon.texture)


func _on_slot_3_pressed():
	emit_signal("tower_selected", 2, $BasePanel/Slot3/Icon.texture)


func _on_slot_4_pressed():
	emit_signal("tower_selected", 3, $BasePanel/Slot4/Icon.texture)


func _on_tower_placement_towers_update(update):
	update_slot(update)
