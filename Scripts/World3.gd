extends Node2D

onready var end_anim_player = $World3_AnimationPlayer
onready var beetle = $TypeItemsContainer/Beetle_TypeItem_Sprite
onready var audio_controller = get_owner().find_node("AudioController")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reveal_beetle():
	end_anim_player.play("Reveal_Beetle")
	end_anim_player.queue("Beetle_Idle")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_World3_AnimationPlayer_animation_finished(anim_name):
#	if anim_name == "Reveal_Beetle":
#		(beetle.get_node("AnimationPlayer2")).play("FadeInText") # fade in "beetle"
#		beetle.yet_to_type = true
	pass


func _on_World3_AnimationPlayer_animation_changed(old_name, new_name):
	if old_name == "Reveal_Beetle":
		(beetle.get_node("AnimationPlayer2")).play("FadeInText") # fade in "beetle"
		beetle.yet_to_type = true
		#audio_controller.play_music("music_flowersuspense.ogg")
