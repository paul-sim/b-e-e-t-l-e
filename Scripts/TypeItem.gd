extends Sprite


export (Color) var blue = Color("#5810cc")  # blue = 4682b4   #306850
export (Color) var black = Color("#000000") # #79858c

onready var big_flower = get_owner().find_node("BigFlower_Sprite")

onready var audio_controller = get_owner().find_node("AudioController")

onready var prompt = $RichTextLabel
onready var prompt_text = prompt.text

onready var anim_player = $AnimationPlayer
onready var anim_player2 = $AnimationPlayer2

onready var yet_to_type = true
var robotDone = false
var flower_open = false

export var item : String = ""
export var item_wanted : String = ""
export var isGate : bool = false
# export var isRobotFlower : bool = false
export var sfx : String = ""

func _ready() -> void:
	# prompt_text = PromptList.get_prompt()
	
	if self.get_name() == "TypeItemRobotFlower_Sprite":
		self.yet_to_type = false # bypass for later use
	elif self.get_name() == "KingQueen_TypeItem_Sprite":
		self.yet_to_type = false # bypass.. will never use
	elif self.get_name() == "KingQueenGift_TypeItem_Sprite":
		self.yet_to_type = false # bypass for later use
	elif self.get_name() == "Sauce_TypeItem_Sprite":
		self.yet_to_type = false # bypass for later use
	elif self.get_name() == "Cheese_TypeItem_Sprite":
		self.yet_to_type = false # bypass for later use
	elif self.get_name() == "Pepperoni_TypeItem_Sprite":
		self.yet_to_type = false # bypass for later use
	elif self.get_name() == "Beetle_TypeItem_Sprite":
		self.yet_to_type = false # bypass for later use
	elif self.get_name() == "World_TypeItem":
		self.yet_to_type = false # bypass for later use
	
	prompt.parse_bbcode(set_center_tags(prompt_text))

func set_next_character(next_character_index: int):
	var blue_text = get_bbcode_color_tag(blue) + prompt_text.substr(0, next_character_index) + get_bbcode_end_color_tag()
	# var green_text = get_bbcode_color_tag(green) + prompt_text.substr(next_character_index, 1) + get_bbcode_end_color_tag()
	var black_text = ""

	if next_character_index != prompt_text.length():
		black_text = get_bbcode_color_tag(black) + prompt_text.substr(next_character_index, prompt_text.length() - next_character_index + 1) + get_bbcode_end_color_tag()

	prompt.parse_bbcode(set_center_tags(blue_text + black_text))

func play_anim() -> void:
	anim_player.play("Animate")
	anim_player.queue("Idle")

func reset_text() -> void:
	var black_text = get_bbcode_color_tag(black) + prompt_text + get_bbcode_end_color_tag()
	prompt.parse_bbcode(set_center_tags(black_text))

func finish() -> void:
	anim_player2.play("FadeOutText")
	# play sfx
	audio_controller.play_SFX(sfx)
	yet_to_type = false

func get_item() -> String:
	return item
	
func get_item_wanted() -> String:
	return item_wanted

func show_wanted_item() -> void:
	anim_player2.play("Show_Wanted_Item")
	audio_controller.play_SFX("item_wanted_response.ogg")

func set_center_tags(string_to_center: String):
	return "[center]" + string_to_center + "[/center]"


func get_bbcode_color_tag(color: Color) -> String:
	return "[color=#" + color.to_html(false) + "]"


func get_bbcode_end_color_tag() -> String:
	return "[/color]"

func get_prompt() -> String:
	return prompt_text
	
func get_yet_to_type() -> bool:
	return yet_to_type

# this function doesn't get called for some reason
func _on_AnimationPlayer_animation_finished(anim_name):
#	if anim_name == "Animate":
#		# robot gets a new word after the first one if finished
#		if self.get_name() == "TypeItemRobot_Sprite" && robotDone == false:
#			var richTextLbl = get_node("RichTextLabel")
#			self.item = "flower"
#			self.item_wanted = ""
#			richTextLbl.bbcode_text = "[center]Hug[/center]"
#			anim_player2.play("FadeInText")
#			yet_to_type = true
#			robotDone = true
	pass

func _on_AnimationPlayer_animation_changed(old_name, new_name):
	if old_name == "Animate":
		# robot gets a new word after the first one if finished
		if self.get_name() == "TypeItemRobot_Sprite" && robotDone == false:
			var robot_flower = get_parent().get_node("TypeItemRobotFlower_Sprite")
			(robot_flower.get_node("AnimationPlayer")).play("Idle")
			robot_flower.position = self.position
			robot_flower.yet_to_type= true
			self.position += ConstantsEnums.HIDE_VECTOR
			robotDone = true
		elif self.get_name() == "Chest_TypeItem_Sprite":
			# dough has flown in since it's baked into the chest animation. spawn sauce object
			var sauce = get_parent().get_node("Sauce_TypeItem_Sprite")
			(sauce.get_node("AnimationPlayer")).play("Init2")
			sauce.yet_to_type= true
		elif self.get_name() == "Sauce_TypeItem_Sprite":
			var cheese = get_parent().get_node("Cheese_TypeItem_Sprite")
			(cheese.get_node("AnimationPlayer")).play("Init2")
			cheese.yet_to_type= true
		elif self.get_name() == "Cheese_TypeItem_Sprite":
			var pepperoni = get_parent().get_node("Pepperoni_TypeItem_Sprite")
			(pepperoni.get_node("AnimationPlayer")).play("Init2")
			pepperoni.yet_to_type= true
		elif self.get_name() == "Pepperoni_TypeItem_Sprite":
			# do king and queen animaion to give player the windpipe gift
			var king_queen = get_parent().get_node("KingQueen_TypeItem_Sprite")
			var king_queen_gift = get_parent().get_node("KingQueenGift_TypeItem_Sprite")
			(king_queen_gift.get_node("AnimationPlayer")).play("Init2")
			king_queen_gift.position = king_queen.position
			king_queen.position += ConstantsEnums.HIDE_VECTOR
			king_queen_gift.yet_to_type= true
		elif self.get_name().substr(0, 10) == "NoteFlower":
			if flower_open == false:
				var note_flowers = get_parent().get_children() # get all noteflowers
				for note_flower in note_flowers:
					note_flower.item_wanted = "" # after the first note flower, erase instrument2 from all the rest of the note flowers
				flower_open = true
			big_flower.increment_flower_count()
			# ((get_parent().get_parent()).get_node("BigFlower_Sprite")).increment_flower_count()
		

#	if old_name == "Animate":
#		# robot gets a new word after the first one if finished
#		if self.get_name() == "TypeItemRobot_Sprite" && robotDone == false:
#			var richTextLbl = get_node("RichTextLabel")
#			self.item = "flower"
#			self.item_wanted = ""
#			richTextLbl.bbcode_text = "[center]Hug[/center]"
#			anim_player2.play("FadeInText")
#			yet_to_type = true
#			robotDone = true


func _on_AnimationPlayer2_animation_finished(anim_name):
	if anim_name == "FadeOutText":
		if self.get_name() == "Start_TypeItem":
			var world = get_parent().get_node("World_TypeItem")
			world.anim_player2.play("FadeInText")
			world.yet_to_type = true
		elif self.get_name() == "World_TypeItem":
			get_tree().change_scene("res://Main.tscn")
