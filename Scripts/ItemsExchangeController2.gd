extends Node2D

onready var anim_player = $AnimationPlayer
onready var player = get_owner().find_node("Player_KinematicBody2D")

var current_item = null
var current_npc = null
var throw_to_player = false
var throw_to_npc = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimationPlayer").connect("finished", self, "do_anim_finished")
	pass # Replace with function body.

func _physics_process(delta):
	if throw_to_player:
		current_item.position = lerp(current_item.position, player.position, .02)
	if throw_to_npc:
		current_item.position = lerp(player.position, current_npc.position, .02)

func throw(item: String, npc: Sprite) -> bool:
	current_item = get_owner().find_node(item)
	current_npc = npc
	var anim_name = "materialize_" + current_item.get_name()
	if (anim_player.is_playing()):
		anim_player.queue(anim_name)
	else:
		anim_player.play(anim_name)
	return current_item.get_reusable()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name.substr(0, 11) == "materialize": # item has finished materializing
		if current_item.get_throw_to() == "player":
			throw_to_player = true
		elif current_item.get_throw_to() == "npc":
			throw_to_npc = true
		# var anim_dissipate = "dissipate_" + current_item.get_name()
		var anim_dissipate
		if current_item.get_throw_to() == "player":
			anim_dissipate = "dissipate_to_player_" + current_item.get_name()
		elif current_item.get_throw_to() == "npc":
			anim_dissipate = "dissipate_to_npc_" + current_item.get_name()
		anim_player.play(anim_dissipate)

	if anim_name.substr(0, 19) == "dissipate_to_player":
		throw_to_player = false
#		current_item.queue_free()
#		current_item = null
	elif anim_name.substr(0, 19) == "dissipate_to_npc":
		throw_to_npc = false
		current_npc = null


