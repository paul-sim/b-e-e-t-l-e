extends Node

onready var main = get_owner()
onready var audio_controller = get_owner().find_node("AudioController")

export var world_number : int
export var music : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func activate_world() -> void:
	main.set_current_world(world_number)
	# audio_controller.stop_music()
	audio_controller.play_music(music)

## probably will never need this
#func deactivate_world() -> void:
#	main.set_current_world(-1)
#	pass

func _on_Activate_Area2D_body_entered(body):
	if body.get_name() == "Player_KinematicBody2D":
		activate_world()

#
#func _on_Deactivate_Area2D2_body_entered(body):
#	if body.get_name() == "Player_KinematicBody2D":
#		deactivate_world()


