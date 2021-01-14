extends Sprite

onready var anim_player = $AnimationPlayer
onready var player = get_owner().find_node("Player_KinematicBody2D")
var npc = null

export var throw_to = ""
export var reusable = false
var throw_to_player = false
var throw_to_npc = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if throw_to_player:
		self.position = lerp(self.position, player.position, .02)
	if throw_to_npc:
		self.position = lerp(self.position, npc.position, .02)


func throw(npc: Sprite) -> void:
	self.npc = npc
	if throw_to == "npc":
		self.position = player.position # item starts on player position before thrown
	anim_player.play("Materialize")

func get_throw_to() -> String:
	return throw_to

func is_reusable() -> bool:
	return reusable

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Materialize":
		if throw_to == "player":
			throw_to_player = true
			throw_to_npc = false
		elif throw_to == "npc":
			throw_to_player = false
			throw_to_npc = true
		anim_player.play("Dissipate")
	elif anim_name == "Dissipate":
		throw_to_player = false
		throw_to_npc = false
		#self.queue_free()  # this is causing errors
		pass


func _on_AnimationPlayer_animation_changed(old_name, new_name):
	# print("hello")
	pass # Replace with function body.
