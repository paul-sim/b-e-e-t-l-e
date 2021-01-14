extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func throw(item: String, npc: Sprite) -> void:
	var item_object = get_owner().find_node(item)
	item_object.throw(npc) # throws to npc OR npc throws to player

func is_reusable(item: String, npc: Sprite) -> bool:
	var item_object = get_owner().find_node(item)
	return item_object.is_reusable()
