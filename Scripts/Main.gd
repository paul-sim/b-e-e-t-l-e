extends Node2D

onready var audio_controller = $AudioController
onready var fade_anim_player = $Fade_AnimationPlayer

onready var typeItems_container0 = $World0/TypeItemsContainer # intro island
onready var typeItems_container1 = $World1/TypeItemsContainer # junkyard
onready var typeItems_container2 = $World2/TypeItemsContainer # medieval
onready var typeItems_container3 = $World3/TypeItemsContainer # plant biome

onready var camera = $Camera2D
onready var player = $Player_KinematicBody2D

var typeItems_container = null
var player_inventory = []
onready var items_exchange_controller = $ItemsExchangeController

var active_typeItem = null
var current_letter_index: int = -1

var current_world = 0
var game_over = false

func _ready() -> void:
	# player_inventory.append("flower2")
	# player_inventory.append("battery_full2")
	# player_inventory.append("key2")
	# audio_controller.play_music("test_music.ogg")
	# player_inventory.append("instrument2")
	camera.position = player.position
	audio_controller.play_music("music_world0.ogg")
	pass
	

func _process(delta):
	if game_over:
		end_game()

func find_new_active_typeItem(typed_character: String):
	match current_world:
		0:
			typeItems_container = typeItems_container0
		1:
			typeItems_container = typeItems_container1
		2:
			typeItems_container = typeItems_container2
		3:
			typeItems_container = typeItems_container3
		_:
			# don't try and look for an item. ignore input
			return
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
				if check_typeItem_item_wanted():
					active_typeItem.play_anim()
					active_typeItem.finish()
					check_typeItem_item()
					active_typeItem = null
				else:
					reset_typeItem()
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
					if check_typeItem_item_wanted():
						active_typeItem.play_anim()
						active_typeItem.finish()
						check_typeItem_item()
						active_typeItem = null
					else:
						reset_typeItem()
			else:
				print("incorrectly typed %s instead of %s" % [key_typed, next_character])

func check_typeItem_item() -> void:
	var item = active_typeItem.get_item()
	if item != "":
		items_exchange_controller.throw(item, active_typeItem)
		if items_exchange_controller.is_reusable(item, active_typeItem):
			item = item + "2"  # e.g. "battery" becomes "battery2"
		player_inventory.append(item)
		active_typeItem.item = ""

func check_typeItem_item_wanted() -> bool:
	var item_wanted = active_typeItem.get_item_wanted()
	
	if item_wanted == "":
		return true # there was nothing to check
	else:
		for item in player_inventory:
			if item == item_wanted:
				items_exchange_controller.throw(item, active_typeItem)
				active_typeItem.item_wanted = ""
				player_inventory.erase(item)
				return true
		active_typeItem.show_wanted_item()
		return false

func reset_typeItem() -> void:
	if active_typeItem != null:
		active_typeItem.reset_text()
		active_typeItem = null

func set_current_world(world_number: int) -> void:
	reset_typeItem() # close whatever business you were doing
	current_world = world_number
	camera.set_current_world(world_number)
	if current_world != 0:
		move_camera_to_world()
	else:
		move_camera_to_player()

func move_camera_to_world() -> void:
	camera.move_camera_to_world()

func move_camera_to_player() -> void:
	camera.move_camera_to_player()


# signal called from Beetle_TypeItem_Sprite/AnimationPlayer2
func _on_AnimationPlayer2_animation_finished(anim_name):
	if anim_name == "FadeOutText":
		game_over = true

func end_game() -> void:
	camera.camera_to_player = false
	camera.camera_to_world = false
	camera.camera_to_beetle = true
	play_credits()
	
func play_credits() -> void:
	fade_anim_player.play("FadeOutScreen")
	audio_controller.play_long_fade();
	pass
	
func switch_to_credits() -> void:
	get_tree().change_scene("res://Credits_Scene.tscn")


func _on_Fade_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOutScreen":
		switch_to_credits()
	elif anim_name == "FadeInScreen":
		player.anim_player_intro.play("Searching_Beetle")
