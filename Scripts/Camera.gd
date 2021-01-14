extends Camera2D


onready var player = get_owner().find_node("Player_KinematicBody2D")
onready var beetle = get_owner().find_node("Beetle_TypeItem_Sprite")

var camera_to_world = false
var camera_to_player = true
var camera_to_beetle = false # cuts into credits
var current_world = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if camera_to_player:
		self.position = lerp(self.position, player.position, .1)
		self.zoom.x = lerp(self.zoom.x, 1, .1)
		self.zoom.y = lerp(self.zoom.y, 1, .1)
	elif camera_to_world:
		var camera_position_world
		match current_world:
			1:
				camera_position_world = get_owner().find_node("CameraPosition_World1")
			2:
				camera_position_world = get_owner().find_node("CameraPosition_World2")
			3:
				camera_position_world = get_owner().find_node("CameraPosition_World3")
			_:
				pass
		self.position = lerp(self.position, camera_position_world.get_global_transform().origin, .05)
		
		self.zoom.x = lerp(self.zoom.x, 1.5, .05)
		self.zoom.y = lerp(self.zoom.y, 1.5, .05)
		
		if self.position == camera_position_world.get_global_transform().origin:
			camera_to_world = false
	elif camera_to_beetle:
		self.position = lerp(self.position, beetle.position, .001)
		self.zoom.x = lerp(self.zoom.x, 5, .001)
		self.zoom.y = lerp(self.zoom.y, 5, .001)
	
func move_camera_to_world() -> void:
#	self.zoom.x = 1.5
#	self.zoom.y = 1.5
	camera_to_player = false
	camera_to_world = true

func move_camera_to_player() -> void:
#	self.zoom.x = 1
#	self.zoom.y = 1
	camera_to_player = true
	camera_to_world = false

func set_current_world(current_world: int) -> void:
	self.current_world = current_world
