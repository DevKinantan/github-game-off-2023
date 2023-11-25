class_name Item extends Node


enum Type {
	COMSUMABLE,
	SEED,
	KEY
}

var label: String
var image: Resource
var price: int
var type: Type

func _init(item_label:String, image_path:String, item_price:int, item_type:Type = Type.COMSUMABLE):
	self.label = item_label
	self.image = load(image_path)
	self.price = item_price
	self.type = item_type
