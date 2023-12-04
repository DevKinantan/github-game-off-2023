extends Label

@export var count_down:int = 300
var current_time:int = count_down


# Called when the node enters the scene tree for the first time.
func _ready():
	current_time = count_down
	
	text = sec_to_min(current_time)
	
	$CountDown.start(count_down)
	$LabelUpdate.start(1)


func sec_to_min(t:int):
	var minute = int(t / 60)
	var second = t - (minute * 60)
	
	minute = "%s"%[minute] if minute >= 10 else "0%s"%[minute]
	second = "%s"%[second] if second >= 10 else "0%s"%[second]
	
	return "%s:%s" %[minute, second]


func _on_label_update_timeout():
	current_time -= 1
	text = sec_to_min(current_time)
	
	if current_time <= 0:
		$LabelUpdate.stop()
