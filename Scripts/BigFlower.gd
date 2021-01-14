extends Sprite

onready var anim_player = $AnimationPlayer
onready var audio_controller = get_owner().find_node("AudioController")
# onready var world3_anim_player = get_owner().find_node("World3_AnimationPlayer")

var flower_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func increment_flower_count() -> void:
	flower_count += 1
	if flower_count >= 6:
		# start music cue
		audio_controller.play_music("music_floweropen.ogg")
		anim_player.play("Animate")
		# anim_player.queue("Idle")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Animate":
		reveal_beetle()

func reveal_beetle():
	get_owner().find_node("World3").reveal_beetle()
	anim_player.play("Idle")
	# world3_anim_player.play("Reveal_Beetle")
