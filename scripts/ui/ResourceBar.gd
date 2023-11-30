extends Control

var max_height = 132


func _ready():
	max_height = $WoodBar/Bar.size.y


func update_bar(c:int, m:int, rt:String):
	var percentage = c/float(m)
	match rt:
		"wood":
			$WoodBar/Bar.size.y = max_height * percentage
			$WoodBar/Current.text = str(c)
			$WoodBar/Max.text = str(m)

		"rock":
			$RockBar/Bar.size.y = max_height * percentage
			$RockBar/Current.text = str(c)
			$RockBar/Max.text = str(m)
