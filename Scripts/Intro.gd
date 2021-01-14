extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var typeItems_container = $TypeItemsContainer

var active_typeItem = null
var current_letter_index: int = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func find_new_active_typeItem(typed_character: String):

	for typeItem in typeItems_container.get_children():
		# if already finished typing this word, we don't want to type this again
		if typeItem.get_yet_to_type() == false: 
			continue
		var prompt = typeItem.get_prompt()
		var next_character = prompt.substr(0, 1)
		if next_character.to_lower() == typed_character.to_lower():
			print("found new typeItem that starts with %s" % next_character)
			active_typeItem = typeItem
			current_letter_index = 1
			
			if (active_typeItem.get_prompt()).length() == 1:
				# the word is a 1 letter word. this word is done
				current_letter_index += 1
				active_typeItem.set_next_character(current_letter_index)
				current_letter_index = -1
			else:
				active_typeItem.set_next_character(current_letter_index)
			return

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var typed_event = event as InputEventKey		
		var key_typed = PoolByteArray([typed_event.unicode]).get_string_from_utf8()

		if event.is_action_pressed("ui_backspace"):
			reset_typeItem()
			return

		if active_typeItem == null:
			find_new_active_typeItem(key_typed)
		else:
			var prompt = active_typeItem.get_prompt()
			var next_character = prompt.substr(current_letter_index, 1)
			if key_typed.to_lower() == next_character.to_lower():
				print("successfully typed %s" % key_typed)
				current_letter_index += 1
				active_typeItem.set_next_character(current_letter_index)
				if current_letter_index == prompt.length():
					print("done")
					current_letter_index = -1
					active_typeItem.play_anim()
					active_typeItem.finish()
					active_typeItem = null
			else:
				print("incorrectly typed %s instead of %s" % [key_typed, next_character])
				
func reset_typeItem() -> void:
	if active_typeItem != null:
		active_typeItem.reset_text()
		active_typeItem = null
